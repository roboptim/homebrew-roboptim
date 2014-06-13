require "formula"

class Libmocap < Formula
  homepage "https://github.com/jrl-umi3218/libmocap"

  head 'https://github.com/jrl-umi3218/libmocap.git'

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    # Remove ROS viewer for now.
    args << "-DENABLE_ROS_VIEWER:BOOL=OFF"


    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "libmocap"
  end
end
