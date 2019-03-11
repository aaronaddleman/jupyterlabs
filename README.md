# JupyterLabs

[![Build Status](https://travis-ci.org/aaronaddleman/jupyterlabs.svg?branch=master)](https://travis-ci.org/aaronaddleman/jupyterlabs)

## what

Docker image running Jupyterlabs and many languages. I use this for creating diagrams, practicing with languages, and documenting things.

## why

JupyterLabs provides a wonderful web interface for running code and documents side-by-side.

## how

To consume these images, just run one of the following:

```
#
# plain ol' jupyterlabs
#
docker run \
-p 8888:8888 \
-e JUPYTER_ENABLE_LAB=yes \
-e USE_SSL=yes \
-e GEN_CERT=yes \
aaronaddleman/jupyterlabs:latest
#
# or if you have $HOME/src (and you should...)
#
docker run \
-p 8888:8888 \
-e JUPYTER_ENABLE_LAB=yes \
-e USE_SSL=yes \
-e GEN_CERT=yes \
-v "$HOME/src:/home/jovyan/src" \
aaronaddleman/jupyterlabs:latest
#
#
# or set your home dir to something you like
#
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
-e GRANT_SUDO=yes
aaronaddleman/jupyterlabs:latest
```

You should get an output similar to this with instructions on visiting a url:

```
[I 05:45:02.890 LabApp] https://(99002e8144b3 or 127.0.0.1):8888/?token=SECRET_TOKEN_HERE
[I 05:45:02.890 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 05:45:02.891 LabApp]

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        https://(99002e8144b3 or 127.0.0.1):8888/?token=SECRET_TOKEN_HERE
```

Open your browser to "https://localhost:8888/?token=SECRET_TOKEN_HERE" and you should be good to launch some notebooks!
