require "digest"
require "dropbox_sdk"

module BundleCache
  def self.cache
    bundle_dir = ENV["BUNDLE_DIR"] || "~/.bundle"
    processing_dir = ENV["PROCESS_DIR"] || ENV["HOME"]

    architecture    = `uname -m`.strip

    file_name       = "#{ENV['BUNDLE_ARCHIVE']}-#{architecture}.tgz"
    file_path       = "#{processing_dir}/#{file_name}"
    lock_file       = File.join(File.expand_path(ENV["TRAVIS_BUILD_DIR"].to_s), "Gemfile.lock")
    digest_filename = "#{file_name}.sha2"
    old_digest      = File.expand_path("#{processing_dir}/remote_#{digest_filename}")

    puts "Checking for changes"
    bundle_digest = Digest::SHA2.file(lock_file).hexdigest
    old_digest    = File.exists?(old_digest) ? File.read(old_digest) : ""

    if bundle_digest.to_s.strip == old_digest.to_s.strip
      puts "=> There were no changes, doing nothing"
    else
      if old_digest == ""
        puts "=> There was no existing digest, uploading a new version of the archive"
      else
        puts "=> There were changes, uploading a new version of the archive"
        puts "  => Old checksum: #{old_digest}"
        puts "  => New checksum: #{bundle_digest}"
      end

      puts "=> Preparing bundle archive"
      `tar -C #{File.dirname(bundle_dir)} -cjf #{file_path} #{File.basename(bundle_dir)}`
    
      if 1 == $?.exitstatus
        puts "=> Archive failed. Please make sure '--path=#{bundle_dir}' is added to bundle_args."
        exit 1
      end

      client = DropboxClient.new(ENV["DROPBOX_ACCESS_TOKEN"])

      puts "=> Uploading"
      begin
        client.put_file(file_name, open(file_path, "r").read, true)
        client.put_file(digest_filename, bundle_digest, true)
      end

    end

    puts "All done now."
  end
end
