class Porter < Formula
  desc "Porter is a CLI for migrating content between CMS platforms."
  homepage "https://github.com/umi-labs/porter"
  version "2.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v2.1.0/porter-cli-aarch64-apple-darwin.tar.xz"
      sha256 "73eba55fc76a55715db99b286751e8c9a182228f1444f5a80a93605313030d20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v2.1.0/porter-cli-x86_64-apple-darwin.tar.xz"
      sha256 "19bd0f534cf663904b6e4b105293aa7e7c09a22b4189bbdab221cc44ddd4a3c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/porter/releases/download/v2.1.0/porter-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc182c3da96e11c2b54a1942a9b6bbb64c277f4d6c3ca23520307bf108a3bc06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/porter/releases/download/v2.1.0/porter-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e33e0e2c31681b991d6a06bcdffbfe5f1de0bc14d893ffd012f5da3bd7ddd4f"
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
