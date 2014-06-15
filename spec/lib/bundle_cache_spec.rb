require_relative '../../lib/bundle_cache'

describe BundleCache::Client do
  
  context "dropbox mode" do  
    # sinnvoll?
    
    after do
      path = subject.send(:old_digest_path)
      FileUtils.rm(path) if File.exists?(path)
    end
    
    subject {described_class.new(true)}
    
    describe ".install" do
      context "File has been deleted" do
        
      end
      context "File not found" do
        
      end
      it "runs without errors" do
        expect{subject.install}.not_to raise_exception
      end
    end

    describe ".cache" do
      before {allow(subject).to receive(:bundle_dir) {File.dirname(__FILE__) + '/../assets/test_file.txt'}}
      it "runs without errors" do
        expect{subject.cache}.not_to raise_exception
      end
      
      context "install before caching" do
        before { subject.install }
        context "uploaded digest is eql to local digest" do
          before {allow(subject).to receive(:changes?) {true}
        end
        
        context "bundle has changed" do
          
        end
      end
    end

    describe ".get_client" do

      it "returns an instance of dropbox client" do
        expect(subject.get_client).to be_instance_of DropboxClient
      end
      it "raises if no DROPBOX_ACCESS_TOKEN is given" do
        #expect{subject.get_client}.to raise_exception
      end
    end
    
    describe ".dropbox_mode?" do
      it {expect(subject.dropbox_mode?).to be}
    end
    
  end

end