class Prwarden < Formula
  include Language::Python::Virtualenv

  desc "Self-hosted AI pull-request reviewer built on your AI and GitHub CLIs"
  homepage "https://github.com/bruha/prwarden"
  url "https://github.com/bruha/prwarden/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "f942e0819f2c2e9fb368c0bc013f83e34f86ba93c5b42fc553f77db9d1a789d0"
  license "Apache-2.0"

  depends_on "gh"
  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Run `prwarden setup` to configure it and `prwarden doctor` to check it.
      Settings live in ~/.config/prwarden and review records in
      ~/.local/state/prwarden.
      It reviews with an AI CLI such as kiro-cli, claude, codex, or agy; setup
      checks which you have, and offers to install and sign in to the rest.
    EOS
  end

  test do
    assert_equal "PR Warden #{version}", shell_output("#{bin}/prwarden --version").strip

    # With no configuration it names where an installed copy looks, and creates
    # nothing there, rather than looking beside the installed package.
    ENV["HOME"] = testpath
    ENV.delete("XDG_CONFIG_HOME")
    ENV.delete("XDG_STATE_HOME")
    ENV.delete("PRWARDEN_HOME")
    ENV["GITHUB_REVIEWER_USERNAME"] = "brew-test"
    output = shell_output("#{bin}/prwarden 2>&1", 2)
    assert_match "#{testpath}/.config/prwarden/repositories.json", output
    refute_path_exists testpath/".config"
    refute_path_exists testpath/".local"
  end
end
