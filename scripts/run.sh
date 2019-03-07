NB_USER=$1
IMAGE=$2
PORT=${3:=8888}

docker run \
--user root \
-p $PORT:8888 \
-e NB_USER=$NB_USER \
-e SHELL=/usr/bin/zsh \
-e JUPYTER_ENABLE_LAB=yes \
-e USE_SSL=yes \
-e GEN_CERT=yes \
-e GRANT_SUDO=yes \
-v "$PWD:/data" \
$IMAGE

