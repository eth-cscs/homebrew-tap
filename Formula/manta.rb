class Manta < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.54.46"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.54.46/manta-aarch64-apple-darwin.tar.xz"
      sha256 "c130045febb71fbd149626b692d1ad8b6f711588f15c76502979ccf077f56330"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.54.46/manta-x86_64-apple-darwin.tar.xz"
      sha256 "8a1b0f9518be1695043dca6ab29ec54ca4b8a9347cff4a487bc2e960f0b9f0cf"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/eth-cscs/manta/releases/download/v1.54.46/manta-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2380fddbc1aa63ba940c295fc4b65af210b2d66ce881d4f18c54cf4d00af6bc8"
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
