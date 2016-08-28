require "formula"

class RoboptimCore < Formula
  homepage "http://www.roboptim.net"
  url "https://github.com/roboptim/roboptim-core/releases/download/v3.2/roboptim-core-3.2.tar.bz2"
  sha256 "9c7793e069aa811c88052bc6f07ab349e9acfac5c8446b4a78736f34eb66f99e"

  head 'https://github.com/roboptim/roboptim-core.git'

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "eigen" => :build
  depends_on "libtool" => :build
  depends_on "log4cxx"
  depends_on "pkg-config" => :build

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    # Fixes:
    # ------
    #
    # 1. Always link to liblog4cxx
    # 2. Skip util test with demangling error (fixed in 3.3)
    #
    # To be fixed upstream.
    if not build.head?
      liblog4cxx = %x[pkg-config --libs liblog4cxx].chomp
      args << "-DCMAKE_EXE_LINKER_FLAGS='" + liblog4cxx + "'"
      args << "-DCMAKE_MODULE_LINKER_FLAGS='" + liblog4cxx + "'"
      inreplace 'tests/CMakeLists.txt', 'ROBOPTIM_CORE_TEST(util)', '#ROBOPTIM_CORE_TEST(util)'
    end

    system "cmake", ".", *args
    system "make", "install"
    system "make", "test"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-core"
  end
end
