class MantaCli < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.57.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.57.3/manta-cli-aarch64-apple-darwin.tar.xz"
      sha256 "baea47b1d68e3fc2c684c8c8d61235a937627f15c61b4d702062b3b7e21be3dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.57.3/manta-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f7694d62f17e9aa5834ecbbe091193297ce7689248a4d0ed2c444c0351eeb311"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.57.3/manta-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e20c2742c604e3263f77f5c15a6f2cd6854fbfa4c89586cf782102aa550bda4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.57.3/manta-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "285e289316fc7f376ff730ede5687de23b9b2771103fa3bdcafbd392c75942d6"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "manta-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "manta-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "manta-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "manta-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
