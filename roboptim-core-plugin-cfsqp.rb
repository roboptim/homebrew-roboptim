require "formula"

# IMPORTANT: this package is closed-source, you *have* to be a member
# of the jrl-umi3218 organization to install this package. If you
# possess a valid CFSQP licence, please contact us.

class RoboptimCorePluginCfsqp < Formula
  homepage "http://www.roboptim.net/"
  head 'https://github.com/jrl-umi3218/roboptim-core-plugin-cfsqp.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "roboptim/roboptim/roboptim-core"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core >= 0.5")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core")'

    inreplace 'src/CMakeLists.txt', 'SOVERSION 1.1.0', ''

    ENV.append_path "PKG_CONFIG_PATH",
                    "#{HOMEBREW_PREFIX}/lib/pkgconfig"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-core-plugin-cfsqp"
  end
end
