require 'rubygems'
require 'zlib'
require 'archive/tar/minitar'
require 'thor'
require 'aws/s3'

include AWS::S3

module RemoteCp  
  class Clipboard
    include AWS::S3
    attr_accessor :content_bucket, :filename_bucket, :type_bucket
    
    def initialize
      connect
      @bucket = Bucket.find(bucket_name)
      @content_bucket = @bucket['content'] || create_obj("content", "")
      @filename_bucket = @bucket['file_name.txt'] || create_obj("file_name.txt", "")
      @type_bucket = @bucket['type'] || create_obj("type", "")
    end

    def connect
      AWS::S3::Base.establish_connection!(
      :access_key_id     => config[:access_key_id],
      :secret_access_key => config[:secret_access_key]
      )
    end

    def config
      config_filename = File.join(ENV["HOME"], ".remote_cp.yml")

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
      @filename_bucket.value = filename
      @filename_bucket.save
      
      @content_bucket.value = str
      @content_bucket.content_type = content_type
      @content_bucket.save
      
      @type_bucket.value = type.to_s
      @type_bucket.save
    end
    
    def pull
      @content_bucket.value
    end
    
    def bucket_name
      config[:bucket_name] 
    end
    
    def filetype
      @type_bucket.value
    end
    
    def content
      @bucket['content'].value
    end

    def filename
      @filename_bucket.value
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