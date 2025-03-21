class Manta < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.54.43"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.54.43/manta-aarch64-apple-darwin.tar.xz"
      sha256 "9bff103b69e60896c76aefb6a2150a91e49d73a2ebdb7e4d7bde47a9f6b324a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.54.43/manta-x86_64-apple-darwin.tar.xz"
      sha256 "d151ba5320078f5570df25eef57cc086f91aac453dff4fdabeb6c681bf1e85ed"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/eth-cscs/manta/releases/download/v1.54.43/manta-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "35b337777825c61915d6935cc58bdb553caf95af15a1d2852f53ce47bb20b328"
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
