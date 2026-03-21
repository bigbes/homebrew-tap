class BwServe < Formula
  desc "Bitwarden vault management API server (bw-serve compatible)"
  homepage "https://sourcecraft.dev/bigbes/go-bitwarden/"
  head "https://git.sourcecraft.dev/bigbes/go-bitwarden.git", branch: "master"

  depends_on "go" => :build
  depends_on "just" => :build

  def install
    system "just", "build-serve"
    bin.install "bin/bw-serve"

    generate_completions_from_executable(
      bin/"bw-serve",
      "completion",
    )
  end

  service do
    run opt_bin/"bw-serve"
    keep_alive true
    log_path var/"log/bw-serve.log"
    error_log_path var/"log/bw-serve.log"
  end

  test do
    assert_match "bw-serve", shell_output("#{bin}/bw-serve version")
  end
end
