#!/usr/bin/env bash

# set your permissions for .gnupg
if [ -d $HOME/.gnupg ]; then
  sudo chown -R "$USER":users $HOME/.gnupg
fi

# if rvm is missing, install it
if ! command -v rvm > /dev/null; then
 curl -sSL https://get.rvm.io | bash -s stable
fi

if [ -d /data/resources ]; then
  if [ ! -d $HOME/.rvm/hooks ]; then
    mkdir -p $HOME/.rvm/hooks
  fi

  if [ ! -d $HOME/.rvm/gemsets ]; then
    mkdir -p $HOME/.rvm/gemsets
  fi

  if [ ! -f $HOME/.rvm/hooks/after_install ]; then
    cp /data/resources/rvm/after_install $HOME/.rvm/hooks/after_install
    chmod u+x $HOME/.rvm/hooks/after_install
  fi

  if [ ! -f $HOME/.rvm/hooks/after_use_removing ]; then
    cp /data/resources/rvm/after_use_removing $HOME/.rvm/hooks/after_use_removing
    chmod u+x $HOME/.rvm/hooks/after_use_removing
  fi

  if [ ! -f $HOME/.rvm/gemsets/default.gems ]; then
    cp /data/resources/rvm/gemsets/default.gems $HOME/.rvm/gemsets/default.gems
  else
    cat /data/resources/rvm/gemsets/default.gems >> $HOME/.rvm/gemsets/default.gems
  fi
fi

# load rvm
source /home/addlema/.rvm/scripts/rvm

# ignore rvm warnings
if ! grep -q "rvm_silence_path_mismatch_check_flag" $HOME/.rvmrc; then
  echo "rvm_silence_path_mismatch_check_flag=1" > $HOME/.rvmrc
fi

# if the link to src is missing, link it
# its linked because upon boot, jupyterlabs tries
# to set permissions when setting the NB_USER
# environment variable
if [ ! -L $HOME/src ]; then
 ln -s /data/src $HOME/src
fi

# set your CDPATH for easy navigation
export CDPATH=$HOME/src

#
# install oh-my-zsh
#
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#
# set things for zsh and oh-my-zsh
#
sed -i "s%export\ ZSH=.*%export\ ZSH='/home/$USER/.oh-my-zsh'%g" ~/.zshrc
source ~/.zshrc

if [ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]; then
        git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d $ZSH_CUSTOM/plugins/zsh-history-substring-search ]; then
        git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
fi

if [ ! -d $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [ ! -d $ZSH_CUSTOM/themes/spaceship-prompt ]; then
        git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
fi

sed -i "s/plugins=.*/plugins=(aws git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)/g" ~/.zshrc
if [ ! -L "$ZSH_CUSTOM/themes/spaceship.zsh-theme" ]; then
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi
sed -i "s/ZSH_THEME=.*/ZSH_THEME='spaceship'/g" ~/.zshrc
source ~/.zshrc

# set the TERM for nice emacs
export set TERM=xterm-256color

# cache the git credentials,
# you will get prompted once, then it will
# stick for a while
git config --global credential.helper cache

# set the default editor
export EDITOR=vi

# set permissions for .emacs.d and .spacemacs
sudo chown -R "$USER":users $HOME/.emacs.d
sudo chown -R "$USER":users $HOME/.spacemacs

# set things for vault
export VAULT_LOGIN_METHOD=ldap
export VAULT_LOGIN_USER=$USER
alias vault_login="vault login -method=$VAULT_LOGIN_METHOD username=$VAULT_LOGIN_USER"

# set things for chef
export CHEF_USER=$USER
export CHEF_ENV=dev

if [ -d /data/resources/user-settings ]; then
  if [ ! -L "$HOME/.jupyter/lab/user-settings" ]; then
    ln -s /data/resources/user-settings $HOME/.jupyter/lab/
  fi
fi

if [ -f /data/resources/git/commit-message.txt ]; then
  git config --global commit.template /data/resources/git/commit-message.txt
fi

