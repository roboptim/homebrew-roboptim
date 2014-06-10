require "formula"

class RoboptimTrajectory < Formula
  homepage "http://www.roboptim.net/"

  head 'https://github.com/roboptim/roboptim-trajectory.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "roboptim/roboptim/roboptim-core"

  #FIXME: should be optional
  depends_on "roboptim/roboptim/roboptim-core-plugin-ipopt"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core >= 2.0")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core")'

    inreplace 'src/CMakeLists.txt', 'SOVERSION 2', ''
    inreplace 'src/CMakeLists.txt', 'VERSION 2.0.0', ''

    ENV.append_path "PKG_CONFIG_PATH",
                    "#{HOMEBREW_PREFIX}/lib/pkgconfig"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-trajectory"
  end
end
