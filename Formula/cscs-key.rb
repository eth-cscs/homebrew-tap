class CscsKey < Formula
  desc "CLI tool to manage SSH keys for the Swiss National Supercomputing Centre (CSCS)"
  homepage "https://github.com/eth-cscs/cscs-key"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eth-cscs/cscs-key/releases/download/1.0.0/cscs-key-1.0.0-macos-aarch64.tar.gz"
      sha256 "4bd06f69cf2416cc06538816eda520060b812096e6726338f21702e51d2137a2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/eth-cscs/cscs-key/releases/download/1.0.0/cscs-key-1.0.0-linux-x86_64.tar.gz"
    sha256 "b0a31197d9d6e7d65281924b2312b2bb397f52909eb47da88c037fe435358e12"
  end

  BINARY_ALIASES = {
    "macos-aarch64":     {},
    "linux-x86_64": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "macos" : "linux"

    "#{os}-#{cpu}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cscs-key" if OS.mac? && Hardware::CPU.arm?
    bin.install "cscs-key" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!
  end
end
