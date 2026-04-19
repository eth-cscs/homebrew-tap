class MantaCli < Formula
  desc "Another CLI for ALPS"
  homepage "https://github.com/eth-cscs/manta/blob/main/README.md"
  version "1.62.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.62.9/manta-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1b5ec1ee3279677e42dea5e87b99ddb46fc0bf785f41417a820602629b5a54c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.62.9/manta-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e90a1c8e354ad4ff7b39f4eeb69fdc6a7164831bd90965b196c30486072cb0a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/manta/releases/download/v1.62.9/manta-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9dd8cb6f897640e6479ab111683a1da132d1e517116b7196f1e32cb0ab700896"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eth-cscs/manta/releases/download/v1.62.9/manta-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1931342b63647e530e9b0964be5debca44a24bf594f465816ec9e005535bace"
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
