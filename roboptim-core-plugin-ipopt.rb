require "formula"

class RoboptimCorePluginIpopt < Formula
  homepage "http://www.roboptim.net/"
  url "https://github.com/roboptim/roboptim-core-plugin-ipopt/releases/download/v2.0/roboptim-core-plugin-ipopt-2.0.tar.bz2"
  sha1 "5237e268838de5d92714139d6419ec9f27cd63fc"

  head 'https://github.com/roboptim/roboptim-core-plugin-ipopt.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "homebrew/science/ipopt"
  depends_on "roboptim/roboptim/roboptim-core"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core >= 0.5")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core")'

    inreplace 'src/CMakeLists.txt', 'SOVERSION 2', ''
    inreplace 'src/CMakeLists.txt', 'VERSION 2.0.0', ''

    ENV.append_path "PKG_CONFIG_PATH",
                    "#{HOMEBREW_PREFIX}/lib/pkgconfig"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-core-plugin-ipopt"
  end
end
