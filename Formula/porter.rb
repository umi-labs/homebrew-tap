class Porter < Formula
  desc "Porter is a CLI for migrating content between CMS platforms."
  homepage "https://github.com/umi-labs/porter"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v2.0.0/porter-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c2b04544b4c1125e11f6924b9592b845143d5caa110051faa3a9acb0b963ffb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v2.0.0/porter-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8e9392fe81feda9f8a2773a84bbf1f62f06974ac7ef2fb70e366a2bcad84841d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v2.0.0/porter-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7f77e651cdeab24573cd22d09224ba7f2cc75462d3634ca2f9588270789f33e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v2.0.0/porter-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9887d555b809f530d4081cebb9c72e292c79fc16c79fa6c4516872ad37741714"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "porter"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "porter"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "porter"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "porter"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
