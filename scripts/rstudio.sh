NB_USER=$1
IMAGE=jupyter/r-notebook

docker run \
--user root \
-p 8888:8888 \
-e NB_USER=$NB_USER \
-e JUPYTER_ENABLE_LAB=yes \
-e USE_SSL=yes \
-e GEN_CERT=yes \
-e GRANT_SUDO=yes \
-v "$PWD:/data/resources" \
-v "$HOME/src:/data/src" \
$IMAGE
