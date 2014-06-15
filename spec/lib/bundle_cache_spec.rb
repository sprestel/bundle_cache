require_relative '../../lib/bundle_cache'

describe BundleCache::Client do
  
  let(:processing_dir) { subject.send(:processing_dir) }
  let(:file_name) { subject.send(:file_name) }
  let(:digest_filename) { subject.send(:digest_filename) }
  
  let(:tgz_test_file) { File.open(File.dirname(__FILE__) + '/../assets/bundle_archive-x86_64.tgz').read }
  let(:sha2_test_file) { File.open(File.dirname(__FILE__) + '/../assets/bundle_archive-x86_64.tgz.sha2').read }

  # stub dropbox transfers
  before do
    allow_any_instance_of(DropboxClient).to receive(:get_file_and_metadata).with(file_name) {tgz_test_file}
    allow_any_instance_of(DropboxClient).to receive(:get_file_and_metadata).with(digest_filename) {sha2_test_file}
    allow_any_instance_of(DropboxClient).to receive(:put_file) {true}
  end
  
  describe "#install" do

    it { expect{subject.install}.not_to raise_exception }
    
    it "downloads 2 files" do
      subject.install

      file1 = File.expand_path(subject.send(:file_path, processing_dir, "remote_#{file_name}"))
      file2 = File.expand_path(subject.send(:file_path, processing_dir, "remote_#{digest_filename}"))
      expect(File.exists?(file1)).to be true
      expect(File.exists?(file2)).to be true
    end
    
    it "calls extract tgz after downloading" do
      expect(subject).to receive(:extract_bundle)
      subject.install
    end

  end

  describe "#cache" do
    it { expect{ subject.cache }.not_to raise_exception }
    
    context "install before caching" do
      before { subject.install }
      
      context "uploaded digest is not eql to local digest" do
        before { allow(subject).to receive(:changes?) { true } }
        
        it "preparing_bundle_archive and upload_files" do
          expect(subject).to receive(:preparing_bundle_archive)
          expect(subject).to receive(:upload_files)
          subject.cache
        end
        it "creates a tar file" do
          subject.cache
          path = subject.send(:file_path, processing_dir,"#{file_name}")
          expect(File.exists?(path)).to be true
        end
      end
  
      context "uploaded digest is eql to local digest" do
         before { allow(subject).to receive(:changes?) { false } }

         it "preparing_bundle_archive and upload_files are not called" do
           expect(subject).not_to receive(:preparing_bundle_archive)
           expect(subject).not_to receive(:upload_files)
           subject.cache 
         end
      end
    end
  end

  describe "#get_client" do

    it "returns an instance of dropbox client" do
      expect(subject.get_client).to be_instance_of DropboxClient
    end
  end

end