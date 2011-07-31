require 'rubygems'
require 'zlib'
require 'archive/tar/minitar'
require 'thor'
require 'remote_cp/core_ext'
require 'aws/s3'
require 'right_aws'
require 'logger'

module RemoteCp  
  class Clipboard
    include RightAws
    attr_accessor :content_object, :filename_object, :type_object
    
    def initialize
      connect
      @bucket = @s3.buckets.detect{|a| a.full_name == "RemoteClipboard"}
      @content_object = @bucket.key('content', true)
    end

    def connect
      @s3 = RightAws::S3.new(config[:access_key_id], config[:secret_access_key], :logger => Logger.new('/dev/null'))
    end

    def config
      config_filename = File.join(ENV["HOME"], ".remote_cp")
      old_filename = File.join(ENV["HOME"], ".remote_cp.yml")
 
      if File.exist?(old_filename)
        puts ".remote_cp.yml configuration file name is depricated. Renaming to .remote_cp"
        File.rename(old_filename, config_filename)
      end

      @config ||= if File.exist?(config_filename)
        conf = Hash.new {|key, val| raise "Missing key #{key} in config file: #{config_filename}"} 
        conf.replace(YAML::load_file(config_filename))
      else
        config = {:access_key_id => "MY_ACCESS_KEY", :secret_access_key => "MY_SECRET", :bucket_name => "MY_BUCKET_NAME"}
        File.open(config_filename, "w") do |f| 
          f << YAML::dump(config)
        end
        File.chmod(0600, config_filename)
        raise "Please setup your .remote_cp.yml config file in your home dir."
      end
    end
    
    # str : content to copy
    # type : :file, :directory
    def push(str, filename = "anomymous", type = :file, content_type = nil)
      metadata = { "filename" => filename, "type" => type.to_s}

      @content_object.meta_headers = metadata
      @content_object.data = str
      @content_object.put
    end
    
    def pull
      @content_object.get
    end
    
    def bucket_name
      config[:bucket_name] 
    end
    
    def filetype
      @content_object.meta_headers["type"]
    end
    
    def content
      @content_object.data
    end

    def filename
      @content_object.meta_headers["filename"]
    end
    
    def create_obj(key, value)
      obj = @bucket.new_object
      obj.key = key
      obj.value = value
      obj.store
      obj
    end
  end
end
