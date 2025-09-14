class Porter < Formula
  desc "Porter is a high-performance, Rust-based CLI tool for migrating structured content between different systems. It supports complex nested data structures, parallel processing, and provides an intuitive interactive interface for data transformation."
  homepage "https://github.com/umi-labs/porter"
  version "1.0.35"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.35/porter-aarch64-apple-darwin.tar.xz"
      sha256 "aeaf598d677cf8698d4dd79fd98a52a92f48a4192d5018789c94526747dc4ca1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.35/porter-x86_64-apple-darwin.tar.xz"
      sha256 "f998a8497cf90d5dd15e6cbac3382d030fe5045f31a21c596c4d39f5866f1928"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.35/porter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c84df7818eb1f4661af4ef8b52975e7ee688c9c431628a3651269cf053aa0007"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.35/porter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "481a0aa714a9cda18c415b5dcffa4bfadcfd1e24461142d78ddf65774570e4f6"
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
