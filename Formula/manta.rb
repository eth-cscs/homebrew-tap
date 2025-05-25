class Manta < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.54.100"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.54.100/manta-aarch64-apple-darwin.tar.xz"
      sha256 "aea7ba5137c14a7894df0b5a4327c2b5de4061558bfc5d232343ff754457ed1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.54.100/manta-x86_64-apple-darwin.tar.xz"
      sha256 "67fff0f12db626454c6750413d802358a034bd8bbc7bb41555f09bd2307377fd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/eth-cscs/manta/releases/download/v1.54.100/manta-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5cfb57ffdacbe71e84f14a27f65e07e39d4dc0f081f41ee89cf605d2802a0b38"
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
