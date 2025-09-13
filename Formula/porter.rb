class Porter < Formula
  desc "Porter is a high-performance, Rust-based CLI tool for migrating structured content between different systems. It supports complex nested data structures, parallel processing, and provides an intuitive interactive interface for data transformation."
  homepage "https://github.com/umi-labs/porter"
  version "1.0.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.31/porter-aarch64-apple-darwin.tar.xz"
      sha256 "a414df3b0c62b8815968974636888c3f244d1295df215241b65ec7542b178e60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.31/porter-x86_64-apple-darwin.tar.xz"
      sha256 "a46fa7d9b3247d693313d71490cc720fc5f8a467873c6e62b10ecf29fe74d175"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.31/porter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e672c46ea81bc6bc705a9e10e6b819cacab891810f39a6601e1ece89fa6ae535"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.31/porter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b275a81328bd817ab6e1a2735d1bd6a76312a25ccfd46869914042b92a689d2"
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
