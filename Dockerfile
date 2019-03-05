FROM jupyter/datascience-notebook:latest
MAINTAINER apr
USER root

RUN chown -R jovyan:users /home/jovyan 
COPY apps/spacemacs /home/jovyan/.emacs.d
RUN chown -R jovyan:users /home/jovyan/.emacs.d
RUN apt update
RUN apt install -y zsh vim emacs

USER jovyan

ADD .zshrc /home/jovyan/.zshrc
RUN pip install boto3 hvac iplantuml bash_kernel python-lambda-local
RUN python -m bash_kernel.install
RUN jupyter labextension install @jupyterlab/git
RUN pip install jupyterlab-git
RUN jupyter serverextension enable --py jupyterlab_git
