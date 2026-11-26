# Template: the release workflow fills in the values and publishes it to the tap.
class Lazycode < Formula
  desc "Lightweight IDE with the power and look of LazyVim"
  homepage "https://github.com/pimpoknot/lazycode"
  url "https://github.com/pimpoknot/lazycode/releases/download/v0.2.0/lazycode-0.2.0.tar.gz"
  version "0.2.0"
  sha256 "d642b8b98f2b90440da8e59cd79994d539a36812e74eca937766ae97f94eed86"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "git"

  def install
    system "cargo", "build", "--release", "--locked", "--manifest-path", "app/Cargo.toml"
    # install.sh picks up this prebuilt window instead of downloading one.
    (buildpath/"bin").install "app/target/release/lazycode-app"
    rm_r "app/target"
    libexec.install Dir["*"], ".lazycode"
    chmod 0755, libexec/"bin/lazycode"
    chmod 0755, libexec/"install.sh"
    bin.install_symlink libexec/"bin/lazycode"
  end

  def caveats
    <<~EOS
      The first `lazycode` run downloads its isolated runtime and plugins to your home folder.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycode version")
    assert_match version.to_s, shell_output("#{libexec}/bin/lazycode-app --version")
  end
end
