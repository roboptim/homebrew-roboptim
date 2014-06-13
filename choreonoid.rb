require "formula"

class Choreonoid < Formula
  url "http://choreonoid.org/_downloads/choreonoid-1.4.0.zip"
  sha1 "c6c3c5fa743adfe8f239e25de768d0dd451f28cc"
  homepage "http://choreonoid.org/en/"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "eigen" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

  depends_on "qt"
  depends_on "glew"
  depends_on "libjpeg"
  depends_on "libpng"
  depends_on "open-scene-graph"
  depends_on "libyaml"

  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo"
    args << "-DINSTALL_SDK:BOOL=ON "
    args << "-DINSTALL_SDK_WITH_EXTLIBS:BOOL=ON "
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "choreonoid", "--version"
  end
end
