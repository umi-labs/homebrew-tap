class Graff < Formula
  desc "Fast, deterministic Rust CLI for converting CSV data into beautiful PNG/SVG/PDF charts"
  homepage "https://github.com/umi-labs/graff"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/graff/releases/download/v1.0.2/graff-aarch64-apple-darwin.tar.xz"
      sha256 "a2809c3516769ea64a11c4a2c6413fb76e5df423e8cb9a0dc074c483102ffecd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/graff/releases/download/v1.0.2/graff-x86_64-apple-darwin.tar.xz"
      sha256 "bf0d1c4e0c351381480324ab63fbfd609504784d98c386943255241819900bca"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/umi-labs/graff/releases/download/v1.0.2/graff-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f21c3bc351f8282b76963013fc372238e6aa81f86f83f91173e71338e3a8c38f"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "graff" if OS.mac? && Hardware::CPU.arm?
    bin.install "graff" if OS.mac? && Hardware::CPU.intel?
    bin.install "graff" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
