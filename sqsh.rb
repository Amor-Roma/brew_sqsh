class Sqsh < Formula
  desc "Sybase Shell"
  homepage "https://sourceforge.net/projects/sqsh/"
  url "https://downloads.sourceforge.net/project/sqsh/sqsh/sqsh-2.5/sqsh-2.5.16.1.tgz"
  sha256 "d6641f365ace60225fc0fa48f82b9dbed77a4e506a0e497eb6889e096b8320f2"

  bottle do
    sha256 "e66731b10a932cc72cb29e5fe4cf42b668a1e2736a4f588f867cd876e5cad11b" => :el_capitan
    sha256 "39c8bc82d3e1c229d10590a03ba97004df93b325061a0633a03f6f5bdf051dc1" => :yosemite
    sha256 "113379e4656eb5e0e3c45fffb1ea7fa568bf25e901a0e993bea18d21042bd24c" => :mavericks
  end

  deprecated_option "enable-x" => "with-x11"

  depends_on :x11 => :optional
  depends_on "freetds"
  depends_on "readline"

  # this patch fixes detection of freetds being installed, it was reported
  # upstream via email and should be fixed in the next release
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-readline
    ]

    readline = Formula["readline"]
    ENV["LIBDIRS"] = readline.opt_lib
    ENV["INCDIRS"] = readline.opt_include

    if build.with? "x11"
      args << "--with-x"
      args << "--x-libraries=#{MacOS::X11.lib}"
      args << "--x-includes=#{MacOS::X11.include}"
    end

    ENV["SYBASE"] = Formula["freetds"].opt_prefix
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    assert_equal "sqsh-#{version}", shell_output("#{bin}/sqsh -v").chomp
  end
end
