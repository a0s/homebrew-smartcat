class Smartcat < Formula
  desc "Context-aware cat that renders Markdown, images and code in your terminal"
  homepage "https://github.com/a0s/smartcat"
  url "https://github.com/a0s/smartcat/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5df06e9a374c67d605352051282570dc11434bab7af14fd1a3bd1c083178ceb6"
  license "MIT"
  head "https://github.com/a0s/smartcat.git", branch: "main"

  def install
    bin.install "bin/smartcat"
    pkgshare.install "share/smartcat/config.default.yaml"
    (pkgshare/"init").install Dir["share/smartcat/init/*"]
  end

  def caveats
    <<~EOS
      smartcat doesn't render files itself - it calls a viewer for each type and
      falls back to plain cat when one isn't installed. Install the backends for
      the types you use:

        brew install glow       # Markdown
        brew install bat        # code, JSON/YAML/CSV
        brew install poppler    # PDF (text)
        brew install chafa      # images, outside iTerm2

      In iTerm2, images use the built-in imgcat (iTerm2 -> Install Shell
      Integration). Run `smartcat -status` to see what's covered.

      Make `cat` smart in interactive shells (pipes and scripts stay untouched)
      by adding this to your ~/.zshrc:

        eval "$(smartcat init zsh)"

      To customize file-type handlers, copy the default config and edit it:

        mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/smartcat"
        cp "#{pkgshare}/config.default.yaml" \\
           "${XDG_CONFIG_HOME:-$HOME/.config}/smartcat/config.yaml"
    EOS
  end

  test do
    assert_match "smartcat #{version}", shell_output("#{bin}/smartcat --version")

    (testpath/"sample.md").write("# Title\nbody\n")
    piped = pipe_output("#{bin}/smartcat #{testpath}/sample.md")
    assert_equal File.read(testpath/"sample.md"), piped

    assert_match "command smartcat", shell_output("#{bin}/smartcat init zsh")
  end
end
