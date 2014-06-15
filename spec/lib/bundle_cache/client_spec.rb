require_relative '../../../lib/bundle_cache/client'

describe "BundleCache::Client" do
  
  context "dropbox mode" do
    it "loads dropbox" do
      ENV["USE_DROPBOX"] = "true"
      BundleCache::Client.new
      expect{Module.const_get("DropboxClient")}.to_not raise_exception
    end
    it "loads not dropbox" do
      ENV.delete("USE_DROPBOX")
      expect{Module.const_get("DropboxClient")}.to raise_exception
    end
  end
end if false