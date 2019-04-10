NB_USER=$1
IMAGE=$2

docker run \
--user root \
-p 8888:8888 \
-e NB_USER=$NB_USER \
-e SHELL=/usr/bin/zsh \
-e JUPYTER_ENABLE_LAB=yes \
-e USE_SSL=yes \
-e GEN_CERT=yes \
-e GRANT_SUDO=yes \
-e LIBSH_HOME=/data/.libsh \
-e USE_RVM=true \
-e USE_OMZ=true \
-e USE_OMZ_EXTRA_PLUGS="zsh-autosuggestions,zsh-history-substring-search,zsh-syntax-highlighting" \
-e USE_OMZ_PLUGS="aws git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting" \
-e USE_EMACS_DAEMON=true \
-v "$HOME/src/jupyter-bootstrap:/data/jupyter-bootstrap" \
-v "$HOME/.spacemacs:/data/.spacemacs" \
-v "$HOME/src:/data/src" \
-v "$HOME/Downloads:/data/downloads" \
-v "$HOME/.chef:/data/chef" \
$IMAGE
