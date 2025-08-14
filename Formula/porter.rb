class Porter < Formula
  desc "Porter is a high-performance, Rust-based CLI tool for migrating structured content between different systems. It supports complex nested data structures, parallel processing, and provides an intuitive interactive interface for data transformation."
  homepage "https://github.com/umi-labs/porter"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v0.2.0/porter-aarch64-apple-darwin.tar.xz"
      sha256 "ffbcab04083a93b5dde94b05b09847569cb3013f9a8b53887309c7d275e6063d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v0.2.0/porter-x86_64-apple-darwin.tar.xz"
      sha256 "eaf15673f1d42a4ec92733395de92225be2a7cab57666de0c9dd86b1de3036cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v0.2.0/porter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "568f5fc91e0fe7cd1b34622750d1cfde15a99a56753b888fe7efc79948e6db40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v0.2.0/porter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "556855401e90d6f61a913fcdc13fcb2fafd71df6cc677a401fda8b59089337ac"
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
    bin.install "porter" if OS.mac? && Hardware::CPU.arm?
    bin.install "porter" if OS.mac? && Hardware::CPU.intel?
    bin.install "porter" if OS.linux? && Hardware::CPU.arm?
    bin.install "porter" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
