class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1116.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1116.orig.tar.gz"
  # Homepage has an expired SSL cert as of 16/12/2020, so we add a Debian mirror
  sha256 "5020063c755bb182177750221013b199198a7f1eb8ff26c1fb879d375c755891"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "15805f34b5fa27d32c8a86cb69459d03300b11b2ec491597264823899f77568f" => :big_sur
    sha256 "66bef9efce57896b13bfaac552d145d35534e44ab8fe4e3367b8334c10509b34" => :arm64_big_sur
    sha256 "b34252e2bd9dfea5ffc5e56e10523658ff44ecc5686eabda34ce2c19a22faabc" => :catalina
    sha256 "1eacafb5514b416f75a39a50bdfc697123f66be10a892be1906fa674580f9298" => :mojave
    sha256 "3f861a7afd0148f58189325de42bbf34cebdce49fd6952355c2055748bfb768c" => :x86_64_linux
  end

  depends_on "gmp"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "pcre"

  on_linux do
    depends_on "jpeg"
  end

  def install
    ENV.append "CFLAGS", "-m64"
    ENV.deparallelize

    # Workaround for https://git.lysator.liu.se/pikelang/pike/-/issues/10058
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "make", "CONFIGUREARGS='--prefix=#{prefix} --without-bundles --with-abi=64'"

    system "make", "install",
                   "prefix=#{libexec}",
                   "exec_prefix=#{libexec}",
                   "share_prefix=#{libexec}/share",
                   "lib_prefix=#{libexec}/lib",
                   "man_prefix=#{libexec}/man",
                   "include_path=#{libexec}/include",
                   "INSTALLARGS=--traditional"

    bin.install_symlink "#{libexec}/bin/pike"
    share.install_symlink "#{libexec}/share/man"
  end

  test do
    path = testpath/"test.pike"
    path.write <<~EOS
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
