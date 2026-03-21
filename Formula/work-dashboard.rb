class WorkDashboard < Formula
  desc "Terminal UI work-dashboard"
  homepage "https://sourcecraft.dev/bigbes/work-dashboard/"
  url "ssh://ssh.sourcecraft.dev/bigbes/work-dashboard.git",
    using:    :git,
    tag:      "v1.1.0",
    revision: "3f2711c9dd104dc974256b136e7b364262567765"
  head do
    url "ssh://ssh.sourcecraft.dev/bigbes/work-dashboard.git", branch: "master", using: :git
  end

  depends_on "go" => :build
  depends_on "just" => :build

  def install
    system "just", "build"
    bin.install "work-dashboard"

    generate_completions_from_executable(
      bin/"work-dashboard",
      "completion",
    )
  end

  test do
    assert_match "work-dashboard", shell_output("#{bin}/work-dashboard --help").downcase
  end
end
