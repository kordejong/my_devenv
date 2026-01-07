#/usr/bin/env bash
set -eu

configuration_prefix=$MY_DEVENV/configuration
home_prefix=$HOME

rm -f $home_prefix/.clang-format && ln -s $configuration_prefix/clang-format $home_prefix/.clang-format
rm -f $home_prefix/.gitconfig && ln -s $configuration_prefix/gitconfig $home_prefix/.gitconfig
rm -f $home_prefix/.gitconfig-geoneric && ln -s $configuration_prefix/gitconfig-geoneric $home_prefix/.gitconfig-geoneric
rm -f $home_prefix/.gitconfig-uu && ln -s $configuration_prefix/gitconfig-uu $home_prefix/.gitconfig-uu
rm -f $home_prefix/.gitignore && ln -s $configuration_prefix/gitignore $home_prefix/.gitignore
rm -f $home_prefix/.tmux && ln -s $configuration_prefix/tmux $home_prefix/.tmux
rm -f $home_prefix/.tmux.conf && ln -s $configuration_prefix/tmux.conf $home_prefix/.tmux.conf

rm -f $home_prefix/.config/lazygit && ln -s $configuration_prefix/lazygit $home_prefix/.config/lazygit
rm -f $home_prefix/.config/lazyvim && ln -s $configuration_prefix/lazyvim $home_prefix/.config/lazyvim
rm -f $home_prefix/.config/ranger && ln -s $configuration_prefix/ranger $home_prefix/.config/ranger
