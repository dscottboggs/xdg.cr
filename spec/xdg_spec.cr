require "spec"
require "../src/xdg"

describe "XDG.config_file" do
  it "works" do
    XDG.config_file("fish").should eq Path.home / ".config" / "fish"
  end
end
