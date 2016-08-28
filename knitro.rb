require "formula"

# KNITRO is a proprietary software and requires a licence.
#
# You *need* to set the environment variables KNITRO_USERNAME and
# KNITRO_PASSWORD to the right values before installing this formula.
class Knitro < Formula
  homepage "http://www.artelys.com/en/optimization-tools/knitro"

  url "https://" + ENV["KNITRO_USERNAME"] + ":" + ENV["KNITRO_PASSWORD"] + "@www.artelys.com/artelys_files/knitro/knitro_10.1/knitro-10.1.1-z-MacOSX-64.zip"
  version "10.1.1"
  sha256 "e53b560e6bca7e1f6a27449427f2b5b7f8e434cd01c7f996838d747e6d7d717c"

  # No install scheme, list content manually.
  def install
    include.install Dir["include/*"]
    lib.install Dir["lib/*"]
    doc.install Dir["doc/*"]
    bin.install "get_machine_ID"
  end

  test do
    system "get_machine_ID"
  end
end
