# JupyterLabs

[![Build Status](https://travis-ci.org/aaronaddleman/jupyterlabs.svg?branch=master)](https://travis-ci.org/aaronaddleman/jupyterlabs)

## what

Docker image running Jupyterlabs and many languages. I use this for creating diagrams, practicing with languages, and documenting things.

## why

JupyterLabs provides a wonderful web interface for running code and documents side-by-side.

## how

To consume these images, just run the following:

```
docker run aaronaddleman/jupyterlabs:latest -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e USE_SSL=yes -e GEN_CERT=yes -v "your/src:/home/jovyan/src"
```

You should get an output similar to this with instructions on visiting a url:

```
[I 05:45:02.890 LabApp] https://(99002e8144b3 or 127.0.0.1):8888/?token=609bab05d33c768c50e71d89e27dc007194aa243b349a4f1
[I 05:45:02.890 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 05:45:02.891 LabApp]

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        https://(99002e8144b3 or 127.0.0.1):8888/?token=SECRET_TOKEN_HERE
```

Open your browser to "https://localhost:8888/?token=SECRET_TOKEN_HERE" and you should be good to launch some notebooks!
