require "digest"
require "dropbox_sdk"

module BundleCache
  def self.install
    architecture = `uname -m`.strip
    file_name = "#{ENV['BUNDLE_ARCHIVE']}-#{architecture}.tgz"
    digest_filename = "#{file_name}.sha2"

    bundle_dir = ENV["BUNDLE_DIR"] || "~/.bundle"
    processing_dir = ENV['PROCESS_DIR'] || ENV['HOME']
    
    client = DropboxClient.new(ENV["DROPBOX_ACCESS_TOKEN"])

    puts "=> Downloading the bundle"
    
    contents, metadata = client.get_file_and_metadata(file_name)
    open("#{processing_dir}/remote_#{file_name}", 'wb') {|f| f.puts contents }

    puts "  => Completed bundle download"

    puts "=> Extract the bundle"
    `cd #{File.dirname(bundle_dir)} && tar -xf "#{processing_dir}/remote_#{file_name}"`

    puts "=> Downloading the digest file"
    contents, metadata = client.get_file_and_metadata(digest_filename)
    open("#{processing_dir}/remote_#{file_name}.sha2", 'wb') {|f| f.puts contents }
    
    puts "  => Completed digest download"

    puts "=> All done!"
  rescue => e
    puts "There's no such archive!"
  end

end
