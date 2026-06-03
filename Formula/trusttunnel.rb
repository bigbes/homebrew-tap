class Trusttunnel < Formula
  desc "Open-source VPN protocol that mimics regular HTTPS traffic"
  homepage "https://github.com/TrustTunnel/TrustTunnel"
  url "https://github.com/TrustTunnel/TrustTunnel.git",
    tag:      "v1.0.41",
    revision: "7948fd9e0e6e22d8fc9aa1e18f7648c840d75f87"
  license "Apache-2.0"
  head "https://github.com/TrustTunnel/TrustTunnel.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "rust" => :build

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib

    system "cargo", "install", *std_cargo_args(path: "endpoint")
    system "cargo", "install", *std_cargo_args(path: "tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trusttunnel_endpoint --version")
    assert_match "Generate configuration files", shell_output("#{bin}/setup_wizard --help")
  end
end
