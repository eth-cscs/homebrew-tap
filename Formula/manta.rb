class Manta < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.56.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.1/manta-aarch64-apple-darwin.tar.xz"
      sha256 "57be0895079928c53e1d0b1b72aab9b329cb2e15558e8a43303161ed89cf1b28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.1/manta-x86_64-apple-darwin.tar.xz"
      sha256 "c1a51b0d35872707aedffff90e1d4b21b7c75afc81271982c4a543182f06b10f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/eth-cscs/manta/releases/download/v1.56.1/manta-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6e6f9b7b1dfff541b1ae974ece353514fde1d415ffeed1e50ef54a80dd334e0f"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
    bin.install "manta" if OS.mac? && Hardware::CPU.arm?
    bin.install "manta" if OS.mac? && Hardware::CPU.intel?
    bin.install "manta" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
