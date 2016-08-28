require "formula"

class RoboptimCorePluginIpopt < Formula
  homepage "http://www.roboptim.net"
  url "https://github.com/roboptim/roboptim-core-plugin-ipopt/releases/download/v3.2/roboptim-core-plugin-ipopt-3.2.tar.bz2"
  sha256 "e07a5377be1aeb2f3ae58eee63a7afcc8f479b9dbc493d4bf3e3aca6068c8fea"

  head 'https://github.com/roboptim/roboptim-core-plugin-ipopt.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  # FIXME: explicit eigen dependency required for pkg-config
  depends_on "eigen" => :build
  depends_on "homebrew/science/ipopt"
  depends_on "roboptim/roboptim/roboptim-core"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core >= 3.2")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core")'

    inreplace 'src/CMakeLists.txt', 'SOVERSION 3', ''
    inreplace 'src/CMakeLists.txt', 'VERSION 3.2.0', ''

    # Fixes:
    # ------
    #
    # 1. Fix undefined symbols for modules (fixed upstream)
    if not build.head?
      inreplace 'src/CMakeLists.txt', 'SET_TARGET_PROPERTIES', "SET(CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS \"${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS} -undefined dynamic_lookup\")\n  SET_TARGET_PROPERTIES"
    end

    system "cmake", ".", *args
    system "make", "install"
    system "make", "test"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-core-plugin-ipopt"
  end
end
