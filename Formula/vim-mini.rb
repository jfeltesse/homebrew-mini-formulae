class VimMini < Formula
  desc "Minimalistic Vim formula with optional dependencies"
  homepage "https://www.vim.org/"
  url "https://github.com/vim/vim/archive/v8.1.0800.tar.gz"
  sha256 "ecc04dea54eb6b096c5df91a3ddbdfb19eebb2adf4aa481c758261555cbcf574"
  head "https://github.com/vim/vim.git"

  LANGUAGES = %w[lua perl python ruby].freeze

  LANGUAGES.each do |language, msg|
    option "with-#{language}", "Build vim with #{language} support"
  end

  depends_on "gettext"
  depends_on "lua" => :optional
  depends_on "perl" => :optional
  depends_on "python" => :optional
  depends_on "ruby" => :optional

  conflicts_with "ex-vi",
    :because => "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "vim",
    :because => "vim-mini and vim install the same executables"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    opts = []

    if build.with?("lua")
      opts << "--enable-luainterp"
      opts << "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    end

    if build.with?("python")
      opts << "--enable-python3interp"

      ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"

      # vim doesn't require any Python package, unset PYTHONPATH.
      ENV.delete("PYTHONPATH")
    end

    %w["perl ruby"].each do |language|
      opts << "--enable-#{language}interp" if build.with? language
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--with-compiledby=Homebrew",
                          "--enable-gui=no",
                          "--without-x",
                          *opts
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    if build.with? "python"
      (testpath/"commands.vim").write <<~EOS
        :python3 import vim; vim.current.buffer[0] = 'hello python3'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello python3", File.read("test.txt").chomp
    end

    assert_match "+gettext", shell_output("#{bin}/vim --version")
  end
end
