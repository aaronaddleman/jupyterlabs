FROM jupyter/datascience-notebook
MAINTAINER apr
USER root
RUN apt-get update
RUN apt-get install -y libtool-bin libffi-dev ruby ruby-dev make
RUN apt-get install -y ruby
RUN apt-get install -y git autoconf pkg-config
RUN gem install ffi-rzmq
RUN gem install iruby
RUN iruby register --force
RUN apt install -y plantuml
RUN apt install -y python3-pip git libtinfo-dev libzmq3-dev libcairo2-dev libpango1.0-dev libmagic-dev libblas-dev liblapack-dev
RUN chown jovyan:users /home/jovyan/.ipython
RUN chmod 740 /home/jovyan/.ipython
USER jovyan
RUN pip install boto3 hvac iplantuml
RUN pip install bash_kernel
RUN pip install python-lambda-local
RUN pip install 'holoviews[all]'
RUN python -m bash_kernel.install
RUN conda install -c conda-forge ipywidgets beakerx
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install beakerx-jupyterlab
RUN jupyter labextension install @pyviz/jupyterlab_pyviz

