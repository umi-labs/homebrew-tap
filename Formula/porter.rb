class Porter < Formula
  desc "Porter is a high-performance, Rust-based CLI tool for migrating structured content between different systems. It supports complex nested data structures, parallel processing, and provides an intuitive interactive interface for data transformation."
  homepage "https://github.com/umi-labs/porter"
  version "1.0.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.22/porter-aarch64-apple-darwin.tar.xz"
      sha256 "a19eba2b858d6ba5152654a845d41b78e53b1c09873a25e0f5af582ee2519139"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.22/porter-x86_64-apple-darwin.tar.xz"
      sha256 "96ff20b270d9e53a56cd4e9348fe2cc31c9d0ffd5bb390f9bac57afa1247bea7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.22/porter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "75d6d0038d8b54a70e281ecc5884b5a6bd0f79e90dcaedd7c0f5e7039a63b873"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.22/porter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b5d812e078abfd72e9ffa6337fec83104ee77f3598ae980e472b84c3ed969c30"
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
