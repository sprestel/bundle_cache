require 'digest'

module BundleCache
  class Client
    def initialize(dropbox_mode = false)
      @dropbox_mode = dropbox_mode

      if dropbox_mode?
        required_env = %w(DROPBOX_ACCESS_TOKEN BUNDLE_ARCHIVE)
      else
        required_env = %w(AWS_S3_KEY AWS_S3_SECRET AWS_S3_BUCKET BUNDLE_ARCHIVE)
      end

      required_env.each do |var|
        unless ENV[var]
          puts "Missing ENV[#{var}]"
          exit 1
        end
      end
    end
        
    def download_file(file_name, processing_dir)
      if dropbox_mode?
        download_via_dropbox(file_name, processing_dir)
      else
        download_via_s3
      end  
    end
    
    def upload_file(file_name, processing_dir)
      if dropbox_mode?
        upload_via_dropbox(file_name, processing_dir)
      else
        upload_via_s3
      end
    end
    
    def upload_via_dropbox(file_name, file_contents)
      puts "=> Uploading #{file_name}"
      get_client.put_file(file_name, file_contents, true)
    rescue => e
      puts e
    end
    
    def upload_via_s3
      # S3 mode not implemented yet
    end
    
    def download_via_s3
      # S3 mode not implemented yet
    end
    
    def download_via_dropbox(file_name, processing_dir)
      contents, metadata = get_client.get_file_and_metadata(file_name)
      open(file_path(processing_dir, "/remote_#{file_name}"), 'wb') {|f| f.puts contents }
    rescue DropboxError => e
      if ["File not found", "File has been deleted"].include? e.message
        puts "There's no such archive #{file_name}!"
      else
        raise e
      end
      return false
    rescue DropboxAuthError => e
      puts e.message
      return false
    end

    def get_client
      if dropbox_mode?
        @client ||= DropboxClient.new(ENV["DROPBOX_ACCESS_TOKEN"])
      else
        # S3 mode not implemented yet
      end
    end

    def dropbox_mode?
      @dropbox_mode
    end
    
    private
    
    def architecture 
      `uname -m`.strip
    end
    
    def file_name 
      "#{ENV['BUNDLE_ARCHIVE']}-#{architecture}.tgz"
    end
    
    def digest_filename 
      "#{file_name}.sha2"
    end
    
    def processing_dir
      ENV['PROCESS_DIR'] || ENV['HOME']
    end
    
    def bundle_dir 
      ENV["BUNDLE_DIR"] || "~/.bundle"
    end
    
    def old_digest
      File.exists?(old_digest_path) ? File.read(old_digest_path) : ""
    end
    
    def old_digest_path
      File.expand_path(file_path(processing_dir, "/remote_#{digest_filename}"))
    end
    
    def file_path(processing_dir, file_name)
      "#{processing_dir}/#{file_name}"
    end
    
    def lock_file
      File.join(File.expand_path(ENV["TRAVIS_BUILD_DIR"].to_s), "Gemfile.lock")
    end
    
    def bundle_digest
      Digest::SHA2.file(lock_file).hexdigest
    end
  end
end