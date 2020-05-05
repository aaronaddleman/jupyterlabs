ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Aaron Addleman <aaronaddleman@gmail.com>"

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    curl \
    plantuml \
    git \
    unzip \
    nano \
    dumb-init \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

RUN pip install boto3 hvac iplantuml bash_kernel python-lambda-local
RUN conda install -c conda-forge ipywidgets
