class GostEngineAT303 < Formula
  desc "GOST cryptographic engine and provider for OpenSSL 3"
  homepage "https://github.com/gost-engine/engine"
  url "https://github.com/gost-engine/engine.git",
      tag:      "v3.0.3",
      revision: "e0a500ab877ba72cb14026a24d462dd923b90ced"
  license "OpenSSL"
  head "https://github.com/gost-engine/engine.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]

    engines_dir = libexec/"engines-3"
    modules_dir = libexec/"ossl-modules"

    args = std_cmake_args + %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DOPENSSL_ROOT_DIR=#{openssl.opt_prefix}
      -DOPENSSL_ENGINES_DIR=#{engines_dir}
      -DCMAKE_INSTALL_LIBDIR=lib
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build", "--config", "Release"
    system "cmake", "--install", "build"

    # CMake install writes ossl-modules under lib/ossl-modules; relocate
    # both the engine and provider into libexec so they don't collide
    # with openssl@3's keg and are discoverable via the config below.
    modules_dir.mkpath
    lib_modules = lib/"ossl-modules"
    if lib_modules.exist?
      lib_modules.children.each { |f| mv f, modules_dir }
      lib_modules.rmdir
    end

    (etc/"gost").mkpath

    # Provider-only config (recommended for OpenSSL 3.x).
    (etc/"gost/gost.cnf").write <<~EOS
      openssl_conf = openssl_def

      [openssl_def]
      providers = provider_section

      [provider_section]
      default = default_sect
      gostprov = gostprov_sect

      [default_sect]
      activate = 1

      [gostprov_sect]
      module   = #{modules_dir}/gostprov.dylib
      activate = 1
    EOS

    # Legacy engine config (older apps that still use ENGINE API).
    # Kept separate because the engine prints "NID creation failed" on
    # load and aborts further config processing, which otherwise would
    # prevent the provider from loading in the same OPENSSL_CONF.
    (etc/"gost/gost-engine.cnf").write <<~EOS
      openssl_conf = openssl_def

      [openssl_def]
      engines = engine_section

      [engine_section]
      gost = gost_section

      [gost_section]
      engine_id     = gost
      dynamic_path  = #{engines_dir}/gost.dylib
      default_algorithms = ALL
    EOS
  end

  def caveats
    openssl = Formula["openssl@3"]
    <<~EOS
      The GOST provider and legacy engine were installed into:
        #{libexec}/ossl-modules/gostprov.dylib
        #{libexec}/engines-3/gost.dylib

      Two OpenSSL configs are provided:
        #{etc}/gost/gost.cnf          (provider, recommended)
        #{etc}/gost/gost-engine.cnf   (legacy ENGINE API)

      Always use the keg-only openssl@3 binary — system /usr/bin/openssl
      is LibreSSL and cannot load these modules:

        # Provider (recommended for OpenSSL 3.x)
        export OPENSSL_CONF=#{etc}/gost/gost.cnf
        #{openssl.opt_bin}/openssl list -providers

        # Legacy engine (only if your app needs the ENGINE API)
        export OPENSSL_CONF=#{etc}/gost/gost-engine.cnf
        #{openssl.opt_bin}/openssl engine -t -c gost

      The two configs should not be combined: the engine's init prints
      "NID creation failed" and aborts config processing, preventing the
      provider section from loading in the same run.

      Utilities installed to #{HOMEBREW_PREFIX}/bin:
        gost12sum, gostsum
    EOS
  end

  test do
    # Standalone hash tool works without any engine/provider loaded.
    (testpath/"sample.txt").write "The quick brown fox jumps over the lazy dog"
    assert_match(/[0-9a-f]{64}/, shell_output("#{bin}/gost12sum #{testpath}/sample.txt"))

    openssl = Formula["openssl@3"].opt_bin/"openssl"

    # Provider loads via the default config.
    ENV["OPENSSL_CONF"] = etc/"gost/gost.cnf"
    assert_match "gostprov", shell_output("#{openssl} list -providers")

    # Legacy engine loads via its dedicated config.
    ENV["OPENSSL_CONF"] = etc/"gost/gost-engine.cnf"
    assert_match "gost", shell_output("#{openssl} engine -t -c gost")
  end
end
