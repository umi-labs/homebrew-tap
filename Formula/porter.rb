class Porter < Formula
  desc "Porter is a high-performance, Rust-based CLI tool for migrating structured content between different systems. It supports complex nested data structures, parallel processing, and provides an intuitive interactive interface for data transformation."
  homepage "https://github.com/umi-labs/porter"
  version "1.0.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.25/porter-aarch64-apple-darwin.tar.xz"
      sha256 "e1e8e198bc609a481db6726292dfb88c868f9507c63aef04bd5ea93d134b41e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.25/porter-x86_64-apple-darwin.tar.xz"
      sha256 "89c110d7ecf3962ed255fe5a1f94a68cb6433efa8733ab0071d852126b6933ec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.25/porter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17588ab6366c56855f2d7b63417dd0029ac8e08eb8cfaa86e1a447ba9c2ed853"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v1.0.25/porter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d4eaea0b46fa50f8f57439294e913a0a8432d0968358b21018a311b91ceea54"
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
