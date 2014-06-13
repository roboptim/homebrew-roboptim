require "formula"

class RoboptimRetargeting < Formula
  homepage "http://www.roboptim.net/"

  head 'https://github.com/roboptim/roboptim-retargeting.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  depends_on "yaml-cpp"

  depends_on "roboptim/roboptim/choreonoid"

  depends_on "roboptim/roboptim/roboptim-core"
  depends_on "roboptim/roboptim/roboptim-trajectory"

  #FIXME: should be optional
  depends_on "roboptim/roboptim/roboptim-core-plugin-ipopt"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    #FIXME: depend on HRP4C model cannot be satisfied currently.
    args << "-DHRP4C_DIRECTORY:STRING=/FIXME"

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core >= 0.5")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core")'

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core-plugin-ipopt >= 0.5")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-core-plugin-ipopt")'

    inreplace 'CMakeLists.txt',
    'ADD_REQUIRED_DEPENDENCY("roboptim-trajectory >= 0.5")',
    'ADD_REQUIRED_DEPENDENCY("roboptim-trajectory")'

    inreplace 'src/CMakeLists.txt', 'SOVERSION 2', ''
    inreplace 'src/CMakeLists.txt', 'VERSION 2.0.0', ''

    ENV.append_path "PKG_CONFIG_PATH",
                    "#{HOMEBREW_PREFIX}/lib/pkgconfig"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-retargeting"
  end
end
