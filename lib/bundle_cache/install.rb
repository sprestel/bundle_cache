require "digest"

module BundleCache
  class Client
    def install
      files_downloaded? && extract_bundle
    end
    
    def extract_bundle
      puts "=> Completed bundle and digest download"
      puts "=> Extract the bundle"
      `cd #{File.dirname(bundle_dir)} && tar -xf "#{processing_dir}/remote_#{file_name}"`
    end
    
    def files_downloaded?
      download_file(file_name, processing_dir) && 
        download_file(digest_filename, processing_dir)
    end
  end

end
