class Manta < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.56.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.2/manta-aarch64-apple-darwin.tar.xz"
      sha256 "f56595f3a269092a4c7d63b16f5534c3323b86d5ff88dc63d01c79eba8f19d10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.2/manta-x86_64-apple-darwin.tar.xz"
      sha256 "80f84b4c5cb35cfcd7d1ae5568a88dfaba847d70389f7b9496b60b5c0ef0af95"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/eth-cscs/manta/releases/download/v1.56.2/manta-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "942cc54981fd39999838316cf14aeb6dc93df08310f8fa8081c68e78caaff692"
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
