require 'digest'

module BundleCache
  class Client
    def initialize
      required_env = %w(DROPBOX_ACCESS_TOKEN BUNDLE_ARCHIVE)

      required_env.each do |var|
        unless ENV[var]
          puts "Missing ENV[#{var}]"
          exit 1
        end
      end
    end
    
    def upload_file(file_name, file_contents)
      puts "=> Uploading #{file_name}"
      get_client.put_file(file_name, file_contents, true)
    rescue => e
      puts e
    end
    
    def download_file(file_name, processing_dir)
      contents, metadata = get_client.get_file_and_metadata(file_name)
      open(file_path(processing_dir, "remote_#{file_name}"), 'wb') {|f| f.puts contents }
      true
    rescue DropboxError => e
      if ["File not found", "File has been deleted"].include? e.message
        puts "There's no such archive #{file_name}!"
      else
        raise e
      end
      false
    rescue DropboxAuthError => e
      puts e.message
      false
    end

    def get_client
      @client ||= DropboxClient.new(ENV["DROPBOX_ACCESS_TOKEN"])
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
      File.expand_path(file_path(processing_dir, "remote_#{digest_filename}"))
    end
    
    def file_path(processing_dir, file_name)
      File.join(processing_dir, file_name)
    end
    
    def lock_file
      File.join(File.expand_path(ENV["TRAVIS_BUILD_DIR"].to_s), "Gemfile.lock")
    end
    
    def bundle_digest
      Digest::SHA2.file(lock_file).hexdigest
    end
  end
end