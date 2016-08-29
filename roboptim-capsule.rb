require "formula"

class RoboptimCapsule < Formula
  homepage "http://www.roboptim.net"
  url "https://github.com/roboptim/roboptim-capsule/releases/download/v3.2/roboptim-capsule-3.2.tar.bz2"
  sha256 "dd591bfa1f76db8ddcc22a33ea9811a6c4ef62beee8f7a8c6d72a987e6544150"

  head 'https://github.com/roboptim/roboptim-capsule.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "homebrew/science/qhull"
  # FIXME: explicit eigen dependency required for pkg-config
  depends_on "eigen" => :build
  depends_on "roboptim/roboptim/roboptim-core"

  #FIXME: should be optional / configurable
  depends_on "roboptim/roboptim/roboptim-core-plugin-ipopt"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    # Fixes:
    # ------
    #
    # 1. Always link to liblog4cxx
    #
    # To be fixed upstream.
    if not build.head?
      liblog4cxx = %x[pkg-config --libs liblog4cxx].chomp
      args << "-DCMAKE_EXE_LINKER_FLAGS='" + liblog4cxx + "'"
      args << "-DCMAKE_MODULE_LINKER_FLAGS='" + liblog4cxx + "'"
    end

    # Remove SOVERSION.
    inreplace 'src/CMakeLists.txt',
              'SET_TARGET_PROPERTIES(${LIBRARY_NAME}',
              '# SET_TARGET_PROPERTIES(${LIBRARY_NAME}'

    system "cmake", ".", *args
    system "make", "install"

    if build.head?
      system "make", "test"
    end
  end

  test do
    system "pkg-config", "--cflags", "roboptim-capsule"
  end
end
