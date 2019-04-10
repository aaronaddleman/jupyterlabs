FROM jupyter/datascience-notebook:latest
MAINTAINER apr
USER root

EXPOSE 3449

RUN apt update
RUN apt install -y zsh vim emacs ssh dnsutils

USER jovyan

RUN mkdir -p /home/jovyan/apps
COPY apps/spacemacs /home/jobyan/apps/spacemacs
RUN pip install boto3 hvac iplantuml bash_kernel python-lambda-local
RUN jupyter labextension install @jupyterlab/git
RUN jupyter labextension install @jupyterlab/google-drive
RUN pip install jupyterlab-git
RUN jupyter serverextension enable --py jupyterlab_git
