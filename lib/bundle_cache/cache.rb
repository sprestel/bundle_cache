module BundleCache
  class Client
    def cache
      if changes?
        puts "=> There were no changes, doing nothing"
      else
        puts "=> There was no existing digest, uploading a new version of the archive" if old_digest == ""

        preparing_bundle_archive        
        upload_files

      end
      puts "All done now."
    end
    
    def preparing_bundle_archive
      puts "=> Preparing bundle archive"
      `tar -C #{File.dirname(bundle_dir)} -cjf #{file_path(processing_dir,"/#{file_name}")} #{File.basename(bundle_dir)}`

      if 1 == $?.exitstatus
        puts "=> Archive failed. Please make sure '--path=#{bundle_dir}' is added to bundle_args."
        exit 1
      end
    end
    
    def upload_files
      begin
        upload_file(file_name, open(file_path(processing_dir,"/#{file_name}"), "r").read)
        upload_file(digest_filename, bundle_digest)
      end
    end
    
    def changes?
      puts "Checking for changes"
      bundle_digest.to_s.strip == old_digest.to_s.strip
    end
    
  end
end
