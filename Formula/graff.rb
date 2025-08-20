class Graff < Formula
  desc "Fast, deterministic Rust CLI for converting CSV data into beautiful PNG/SVG/PDF charts"
  homepage "https://github.com/umi-labs/graff"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-labs/graff/releases/download/v1.0.3/graff-aarch64-apple-darwin.tar.xz"
      sha256 "1720372f38afe459d12a1be326f5623cbf0e5a3c48c0df9b180871c0ecc72f34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-labs/graff/releases/download/v1.0.3/graff-x86_64-apple-darwin.tar.xz"
      sha256 "4f933a43af0951937298be4195891be8c0e195c4050214981efdf2481407b7d6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/umi-labs/graff/releases/download/v1.0.3/graff-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "aa09fb0958ce8d0e8014ad6c2cf54c82f89321b640771663825efed224d2d63f"
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
