class Sc < Formula
  desc "CLI tool from sourcecraft"
  homepage "https://sourcecraft.dev/bigbes/sc/"
  url "https://git.sourcecraft.dev/bigbes/sc.git",
    tag:      "v0.4.1",
    revision: "15a2baa994e17e5d359b0dbf3b7e75a48aee95f7"
  head "https://git.sourcecraft.dev/bigbes/sc.git", branch: "master"

  depends_on "go" => :build
  depends_on "just" => :build

  def install
    system "just", "build"
    bin.install "sc"

    generate_completions_from_executable(
      bin/"sc",
      "completion",
    )
  end

  test do
    assert_match "usage:", shell_output("#{bin}/sc --help").downcase
  end
end
