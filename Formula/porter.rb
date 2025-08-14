class Porter < Formula
  desc "Porter is a high-performance, Rust-based CLI tool for migrating structured content between different systems. It supports complex nested data structures, parallel processing, and provides an intuitive interactive interface for data transformation."
  homepage "https://github.com/umi-labs/porter"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.0/porter-aarch64-apple-darwin.tar.xz"
      sha256 "c50d8aebc63d9fdc7da3cab6cbadea7c4f0cb412d57b18c64c0597c083df3c42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.0/porter-x86_64-apple-darwin.tar.xz"
      sha256 "b75806b845018fc49e31279e7db75943dc517c2a5bec24059b15d58b6ef856c1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.0/porter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a16635ece38ab0e9374b7d4649db334ed45b8b006a6afa00204260efbdb66db3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.0/porter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa9013068993a8ee6095a40491934157d2837c36bf652bf9255fba741e808215"
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
