class MantaCli < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.56.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.7/manta-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ea7030116c14ac32c5ac62e2d8b9f2080d844ad2d35cc656d9a56c0b525f312f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.7/manta-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c2401a01dc1d1ee4a448d4ad5b61c16d5d4373254a0c925353c16727e3c5a376"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.7/manta-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a98b368fd3ae3126132192f617a747108409f3d1ad5aac3afeab8cd8a69ee86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.56.7/manta-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f0b36531674fc95d9ddce91da33668384d4c6ed201403f0695250754f8ca09b"
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
