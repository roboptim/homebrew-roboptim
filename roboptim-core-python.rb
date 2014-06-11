require "formula"

class RoboptimCorePython < Formula
  homepage "http://www.roboptim.net/"

  head 'https://github.com/roboptim/roboptim-core-python.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python"
  depends_on "homebrew/python/numpy"
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
    system "pkg-config", "--cflags", "roboptim-core-plugin-cminpack"
  end
end
