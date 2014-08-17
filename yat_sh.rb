require "formula"

class YatSh < Formula
  homepage "https://github.com/farfanoide/yat.sh"
  head "https://github.com/farfanoide/yat.sh/archive/master.zip"

  depends_on "tmux" => :build

  def install
    prefix.install Dir['*']
  end

  test do
      system "yat.sh", "version"
  end
end
