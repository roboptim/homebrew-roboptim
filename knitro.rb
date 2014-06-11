require "formula"

# KNITRO is a proprietary software and require a licence.
#
# You *need* to set the environment variables KNITRO_USERNAME and
# KNITRO_PASSWORD to the right values before installing this formula.
class Knitro < Formula
  homepage "http://www.artelys.com/en/optimization-tools/knitro"

  url "http://" + ENV["KNITRO_USERNAME"] + ":" + ENV["KNITRO_PASSWORD"] + "@www.artelys.com/artelys_files/knitro/knitro_9.0/knitro-9.0.1-z-MacOSX-64.zip"
  version "9.0.1"
  sha1 "c28b4465531b184d22d0e164c5ae8931966f41be"

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
