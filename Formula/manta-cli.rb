class MantaCli < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.58.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.0/manta-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c98b5edea4b8409f2cd68c191f3964e15961f4b25637432ed47429cf8b55b1d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.0/manta-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1ac2ed3cfa2f1e6948f4e602623ff9b6d617b2f38b2254c8c04cdffb469e2892"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.0/manta-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ce1f9ee65591911bcdcdc456926915117c1cee4af896a6dce81c460e9cedb93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.58.0/manta-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "039cb1fe6ff986d47ecb028ce57b828d5daeef3a8cc42afe50edff9e175550fd"
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
