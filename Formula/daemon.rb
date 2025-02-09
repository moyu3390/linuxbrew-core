class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "https://libslack.org/daemon/"
  url "https://libslack.org/daemon/download/daemon-0.8.tar.gz"
  sha256 "74f12e6d4b3c85632489bd08431d3d997bc17264bf57b7202384f2e809cff596"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?daemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c41545411b2f4b31dc059df14eb622bfd30586c1f2bd3af7f4e0514bb5001277"
    sha256 cellar: :any_skip_relocation, big_sur:       "224349f2fd389edc70b78ef94b2df74251da1c659792b0dea21b9955fb57efae"
    sha256 cellar: :any_skip_relocation, catalina:      "e631aea609e5e1b623b39b735c0a76e391ba117c920ff5fc9d185ff8e9ea332f"
    sha256 cellar: :any_skip_relocation, mojave:        "df18db1a4c13107967c7e78e398b658823036279e4baf0c94ea5504d298f2d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7225197ff9ba2999d2ac501c48d373d712f194df9880acff722e1a94da5184d" # linuxbrew-core
  end

  def install
    system "./configure"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
