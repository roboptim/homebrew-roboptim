require "formula"

class RoboptimTrajectory < Formula
  homepage "http://www.roboptim.net"
  url "https://github.com/roboptim/roboptim-trajectory/releases/download/v3.2/roboptim-trajectory-3.2.tar.bz2"
  sha256 "d700eabc80985ed178b55cdb0a7f8260b083bdb02d5598eb07831dc023426a6d"

  head 'https://github.com/roboptim/roboptim-trajectory.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  # FIXME: explicit eigen dependency required for pkg-config
  depends_on "eigen" => :build
  depends_on "roboptim/roboptim/roboptim-core"

  #FIXME: should be optional
  depends_on "roboptim/roboptim/roboptim-core-plugin-ipopt"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    inreplace 'src/CMakeLists.txt', 'SET_TARGET_PROPERTIES(',
      '#SET_TARGET_PROPERTIES('

    system "cmake", ".", *args
    system "make", "install"
    system "make", "test"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-trajectory"
  end
end
