class TrusttunnelClient < Formula
  desc "Console client for the TrustTunnel VPN protocol"
  homepage "https://github.com/TrustTunnel/TrustTunnelClient"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/TrustTunnel/TrustTunnelClient/releases/download/v1.0.49/trusttunnel_client-v1.0.49-macos-universal.tar.gz"
      sha256 "f2dab732d17a885dcc4c81831fa4b263db250f5bea8a151416b518e936979c64"
    end
    on_intel do
      url "https://github.com/TrustTunnel/TrustTunnelClient/releases/download/v1.0.49/trusttunnel_client-v1.0.49-macos-universal.tar.gz"
      sha256 "f2dab732d17a885dcc4c81831fa4b263db250f5bea8a151416b518e936979c64"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/TrustTunnel/TrustTunnelClient/releases/download/v1.0.49/trusttunnel_client-v1.0.49-linux-aarch64.tar.gz"
      sha256 "a0189fd182c478679fae89e3747e79c5edab56c8fcc34e1f80783a96f56b95d6"
    end
    on_intel do
      url "https://github.com/TrustTunnel/TrustTunnelClient/releases/download/v1.0.49/trusttunnel_client-v1.0.49-linux-x86_64.tar.gz"
      sha256 "01f9f8c46cd673215c3a4052ef790166e874c59295e35daf6b13103e6366f4e5"
    end
  end

  def install
    bin.install "trusttunnel_client"
    bin.install "setup_wizard"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trusttunnel_client --version")
    assert_match "configuration files", shell_output("#{bin}/setup_wizard --help")
  end
end
