class MantaCli < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.58.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.6/manta-cli-aarch64-apple-darwin.tar.xz"
      sha256 "95b530233844680eb2b02151626611aa7824d14400ce33f0581200e8c7defd92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.6/manta-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6957fd8865625c2bec74d9843904bd832d51c4fab78fc7deed4b9182cfce8f04"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.6/manta-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3fb8123dabd65dcc6cc0de9862267fe82d19ab31502e6418c4593fdee57b30dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.6/manta-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "626b68d450284fdfeb31b0de3a62c5393a45ff0055e3e95b017f4a276baf9630"
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
