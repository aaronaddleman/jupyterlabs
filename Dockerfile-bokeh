ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Aaron Addleman <aaronaddleman@gmail.com>"

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    curl \
    plantuml \
    git \
    net-tools \
    emacs \
    vim \
    unzip \
    nano \
    dumb-init \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

RUN pip install boto3 hvac iplantuml python-lambda-local
RUN mkdir $HOME/src
RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d && \
    git clone https://github.com/aaronaddleman/libsh.git $HOME/src/libsh
RUN cp $HOME/src/libsh/.libshrc $HOME/.libshrc
RUN conda install -c conda-forge ipywidgets
