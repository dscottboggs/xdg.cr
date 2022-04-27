require "spec"
require "../src/xdg"

macro describe_xdg_file(kind, at base_dir)
  describe "XDG.{{kind.id}}_file" do
    it "returns a created config file location" do
      mock_content = "XDG.{{kind.id}}_file test\n"
      tempfile = File.tempfile "XDG_{{kind.id.upcase}}_HOME_TEST", dir: XDG::{{kind.id.upcase}}::HOME.to_s do |file|
        file << mock_content
      end
      path = Path[tempfile.path]
      subject = XDG.{{kind.id}}_file(path.basename).not_nil!
      subject.should eq {{base_dir}} / path.basename
      File.read(subject).should eq mock_content
    ensure
      tempfile.try &.delete
    end

    it "returns nil for a file that doesn't exist" do
      tempfile = File.tempfile "XDG_{{kind.id.upcase}}_HOME_TEST", dir: XDG::{{kind.id.upcase}}::HOME.to_s
      tempfile.delete
      XDG.{{kind.id}}_file(Path[tempfile.path].basename).should be_nil
    end

    it "yields a file for appending, returns the result of the block" do
      mock_content = "XDG.{{kind.id}}_file test\n"
      mock_content_pt_2 = "appending to file\n"
      mock_content_combined = mock_content + mock_content_pt_2
      tempfile = File.tempfile "XDG_{{kind.id.upcase}}_HOME_TEST-with-bang", dir: XDG::{{kind.id.upcase}}::HOME.to_s do |file|
        file << mock_content
      end
      path = Path[tempfile.path]
      original_pos = nil
      XDG.{{kind.id}}_file path.basename do |file|
        Path[file.path].should eq {{base_dir}} / path.basename
        original_pos = file.tell
        # Observe, #tell indicates READ position, writes are appended
        # regardless of read position, and that files opened like this can be
        # read from the beginning without a call to #rewind.
        # file.rewind.tell.should_not eq original_pos
        file.gets_to_end.should eq mock_content
        file.tell.should_not eq original_pos
        file
      end.closed?.should be_true
      subject = XDG.{{kind.id}}_file path.basename do |file|
        # Re-opening the file resets the read position.
        file.tell.should eq original_pos
        file << mock_content_pt_2
      end
      subject.should be_a File
      subject.closed?.should be_true
      subject = Path[subject.path]
      subject.should eq {{base_dir}} / path.basename
      File.read(subject).should eq mock_content_combined
    ensure
      tempfile.try &.delete
    end
  end
end

describe_xdg_file :config, at: XDG::CONFIG::HOME
describe_xdg_file :data, at: XDG::DATA::HOME
describe_xdg_file :state, at: XDG::STATE::HOME
describe_xdg_file :cache, at: XDG::CACHE::HOME
