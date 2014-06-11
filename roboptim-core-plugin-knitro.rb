require "formula"

class RoboptimCorePluginKnitro < Formula
  homepage "http://www.roboptim.net/"

  head 'https://github.com/roboptim/roboptim-core-plugin-knitro.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "roboptim/roboptim/knitro"
  depends_on "roboptim/roboptim/roboptim-core"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core >= 0.5")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core")'

    inreplace 'CMakeLists.txt',
    'LINK_DIRECTORIES("${KNITRO_DIR}/lib/gcc41-sequential")',
    'LINK_DIRECTORIES("${KNITRO_DIR}/lib")'

    inreplace 'CMakeLists.txt',
    'SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-undefined")',
    '#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-undefined")'

    inreplace 'src/CMakeLists.txt', 'SOVERSION 0.1.0', ''

    ENV.append_path "PKG_CONFIG_PATH",
                    "#{HOMEBREW_PREFIX}/lib/pkgconfig"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-core-plugin-knitro"
  end
end
