require 'rubygems'
require 'zlib'
require 'archive/tar/minitar'
require 'thor'
require 'aws/s3'
require 'remote_cp/core_ext'

include AWS::S3

module RemoteCp  
  class Clipboard
    include AWS::S3
    attr_accessor :content_object, :filename_object, :type_object
    
    def initialize
      connect
      @bucket = Bucket.find(bucket_name)
      @content_object = @bucket['content'] || create_obj("content", "")
      @filename_object = @bucket['file_name.txt'] || create_obj("file_name.txt", "")
      @type_object = @bucket['type'] || create_obj("type", "")
    end

    def connect
      AWS::S3::Base.establish_connection!(
      :access_key_id     => config[:access_key_id],
      :secret_access_key => config[:secret_access_key]
      )
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
      # I think that all this info should be included file's metadata 
      # AWS::S3 does not support metadata setting on creation.
      @filename_object.value = filename
      @filename_object.save
      
      @content_object.value = str
      @content_object.content_type = content_type
      @content_object.save
      
      @type_object.value = type.to_s
      @type_object.save
    end
    
    def pull
      @content_object.value
    end
    
    def bucket_name
      config[:bucket_name] 
    end
    
    def filetype
      @type_object.value
    end
    
    def content
      @bucket['content'].value
    end

    def filename
      @filename_object.value
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
