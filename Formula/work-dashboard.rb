class WorkDashboard < Formula
  desc "Terminal UI work-dashboard"
  homepage "https://sourcecraft.dev/bigbes/work-dashboard/"
  url "https://git.sourcecraft.dev/bigbes/work-dashboard.git",
    tag:      "v1.1.0",
    revision: "f6089a69ce09e2286dc773fbafc19d94e97de317"
  head "https://git.sourcecraft.dev/bigbes/work-dashboard.git", branch: "master"

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
