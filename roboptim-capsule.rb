require "formula"

class RoboptimCapsule < Formula
  homepage "http://www.roboptim.net/"

  head 'https://github.com/roboptim/roboptim-capsule.git'

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "qhull"
  depends_on "roboptim/roboptim/roboptim-core"

  #FIXME: should be optional / configurable
  depends_on "roboptim/roboptim/roboptim-core-plugin-ipopt"

  def install
    args = std_cmake_args

    # Always remove -Werror flag.
    args << "-DCXX_DISABLE_WERROR:BOOL=ON"

    # Remove SOVERSION.
    inreplace 'src/CMakeLists.txt',
              'SET_TARGET_PROPERTIES(${LIBRARY_NAME}',
              '# SET_TARGET_PROPERTIES(${LIBRARY_NAME}'

    ENV.append_path "PKG_CONFIG_PATH",
                    "#{HOMEBREW_PREFIX}/lib/pkgconfig"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--cflags", "roboptim-capsule"
  end
end
