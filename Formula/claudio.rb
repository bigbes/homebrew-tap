class Claudio < Formula
  desc "CLI wrapper for Claude Code with alternative LLM providers support"
  homepage "https://sourcecraft.dev/bigbes/claudio/"
  url "https://git.sourcecraft.dev/bigbes/claudio.git",
    tag:      "v0.3.0",
    revision: "091ea713969a0bd0adb04cb9a7f4e4cb0f973017"
  head "https://git.sourcecraft.dev/bigbes/claudio.git", branch: "master"

  depends_on "go" => :build

  def install
    build_date = Time.now.strftime("%Y-%m-%d-%H:%M:%S")
    build_commit = Utils.git_head&.slice(0, 7) || "unknown"

    ldflags = "-s -w -X main.commit=#{build_commit} -X main.date=#{build_date}"

    system "go", "build", *std_go_args(ldflags: ldflags), "."

    generate_completions_from_executable(
      bin/"claudio",
      "completion",
    )
  end

  test do
    assert_match "Claude Code CLI wrapper", shell_output("#{bin}/claudio --help")
  end
end
