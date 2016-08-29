require "formula"

class RoboptimCorePluginEigen < Formula
  homepage "http://www.roboptim.net"
  url "https://github.com/roboptim/roboptim-core-plugin-eigen/releases/download/v3.2/roboptim-core-plugin-eigen-3.2.tar.bz2"
  sha256 "e7661e2074f1885a7cbe72d8309fc36f65d3b859378a4caed0a9b8903b1d0320"

  head 'https://github.com/roboptim/roboptim-core-plugin-eigen.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
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
    system "pkg-config", "--cflags", "roboptim-core-plugin-eigen"
  end
end
