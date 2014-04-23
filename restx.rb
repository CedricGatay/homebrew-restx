require "formula"

class Restx < Formula
  homepage "http://www.restx.io"
  url "http://repo1.maven.org/maven2/io/restx/restx-package/0.32/restx-package-0.32.tar.gz"
  sha1 "b3e40a98e92e54cfd56ea751a6fbd9598bb9dd46"


  def install
    libexec.install Dir['*'] # copy everything under libexec
    # symlinks are messing up path detection done via restx launch script
    # we simply generate a new script allowing restx restart while preventing
    # auto update mecanism (to make homebrew happy)
    (bin+'restx').write <<-EOS.undent
      #!/bin/sh
      while [ 1 ]; do
          sh "#{libexec}/launch.sh" "$@"

          if [ -f "#{libexec}/.restart" ]; then
             rm -f "#{libexec}/.restart"
          else
            break
          fi
      done
    EOS
  end

  def caveats
    s = <<-EOS.undent
      /!\\ You will need to reinstall your plugins. /!\\
      Don't forget to call `restx shell install` on your first launch.

      `restx shell upgrade` is disabled as it would clash with homebrew package management.
    EOS
    s
  end

  test do
    system "restx exit"
  end
end
