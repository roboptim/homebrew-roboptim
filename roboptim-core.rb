require "formula"

class RoboptimCore < Formula
  homepage "http://www.roboptim.net/"
  url "https://github.com/roboptim/roboptim-core/releases/download/v2.0/roboptim-core-2.0.tar.bz2"
  sha1 "626c8c13a9f758f29e15b6ea56de06d41f8c306e"

  head 'https://github.com/roboptim/roboptim-core.git'

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "eigen" => :build
  depends_on "libtool"
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
    # 2. Do not version plugins.
    #
    # To be fixed upstream.
    if not build.head?
      liblog4cxx = %x[pkg-config --libs liblog4cxx].chomp
      inreplace 'src/CMakeLists.txt', '  SOVERSION 2.0.0)', ')'
      args << "-DCMAKE_EXE_LINKER_FLAGS='" + liblog4cxx + "'"
      args << "-DCMAKE_MODULE_LINKER_FLAGS='" + liblog4cxx + "'"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-core"
  end
end
