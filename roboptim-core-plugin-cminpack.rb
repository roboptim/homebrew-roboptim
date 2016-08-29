require "formula"

class RoboptimCorePluginCminpack < Formula
  homepage "http://www.roboptim.net/"
  url "https://github.com/roboptim/roboptim-core-plugin-cminpack/releases/download/v3.2/roboptim-core-plugin-cminpack-3.2.tar.bz2"
  sha256 "7c0eba6f5f6a23211c5141278383e12f5bed13a87c4f1e2c01853a62cbcf4b04"

  head 'https://github.com/roboptim/roboptim-core-plugin-cminpack.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "homebrew/science/cminpack"
  # FIXME: explicit eigen dependency required for pkg-config
  depends_on "eigen" => :build
  depends_on "roboptim/roboptim/roboptim-core"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    inreplace 'src/CMakeLists.txt', 'SOVERSION 3.2.0', ''

    system "cmake", ".", *args
    system "make", "install"
    system "make", "test"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-core-plugin-cminpack"
  end
end
