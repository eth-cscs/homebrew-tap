class CscsKey < Formula
  desc "CLI tool to manage SSH keys for the Swiss National Supercomputing Centre (CSCS)"
  homepage "https://github.com/eth-cscs/cscs-key"

  on_macos do
    on_arm do
      url "https://github.com/eth-cscs/cscs-key/releases/download/v1.1.0/cscs-key-v1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "cb88d18627b3e12759def7762f815500b0426301f0072a020c44c87555122ab8"
    end
    on_intel do
      url "https://github.com/eth-cscs/cscs-key/releases/download/v1.1.0/cscs-key-v1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "dc887001b2d6cfb503e184dd1620f024d49ac6599cc42857d1d41d5c437d1c4f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/eth-cscs/cscs-key/releases/download/v1.1.0/cscs-key-v1.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c3856521f4d37a495f0d17998ebd3e64a3dbec00b05ed0d11c3d6068d655bc49"
    end
    on_intel do
      url "https://github.com/eth-cscs/cscs-key/releases/download/v1.1.0/cscs-key-v1.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "299f6952dae32aa43b5b8b95f6218fd62e5c727724bec646433acf461117f9ed"
    end
  end

  def install
    bin.install "cscs-key"
    generate_completions_from_executable(bin/"cscs-key", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cscs-key --version")

    output = shell_output("#{bin}/cscs-key --help")
    assert_match "Usage: cscs-key", output
    assert_match "sign", output

    assert_match "_cscs-key", (zsh_completion/"_cscs-key").read
  end
end
