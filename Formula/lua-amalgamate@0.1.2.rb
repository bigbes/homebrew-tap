class LuaAmalgamateAT012 < Formula
  desc "Lua amalgamator"
  homepage "https://github.com/bigbes/lua-amalgamate"
  url "https://github.com/bigbes/lua-amalgamate.git",
    tag: "v0.1.2",
    revision: "e89f7ec4db409192f755e08b3ff632e5547bff97"
  license "MIT"
  head "https://github.com/bigbes/lua-amalgamate.git", branch: "master"
  revision 2

  depends_on "go" => :build

  def install
    build_date = Time.now.strftime("%Y-%m-%d-%H:%M:%S")
    build_commit = Utils.git_head&.slice(0, 7) || "unknown"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{build_commit} -X main.date=#{build_date}"

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/lua-amalgamate"

    bin.install_symlink "lua-amalgamate@0.1.2" => "lua-amalgamate"
  end

  test do
    output = shell_output("#{bin}/lua-amalgamate --version")
    assert_match(/^lua-amalgamate version #{version}/, output)
  end
end
