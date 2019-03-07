FROM jupyter/datascience-notebook:latest
MAINTAINER apr
USER root

RUN apt-get update && \
    apt-get install -y libtool-bin libffi-dev ruby ruby-dev make git autoconf pkg-config plantuml python3-pip git libtinfo-dev libzmq3-dev libcairo2-dev libpango1.0-dev libmagic-dev libblas-dev liblapack-dev nodejs wget gnupg fonts-powerline zsh vim dnsutils less jq httpie ssh man gnupg2 iputils-ping libczmq-dev 
# install gems for iruby
RUN gem install cztop ffi-rzmq iruby pry pry-doc awesome_print gnuplot rubyvis nyaplot
RUN iruby register --force
RUN chown jovyan:users /home/jovyan/.ipython && chmod 740 /home/jovyan/.ipython

# install tools
ADD https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip  /usr/local/bin/vault.zip
RUN unzip /usr/local/bin/vault.zip -d /usr/local/bin

ADD https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip /usr/local/bin/terraform.zip
RUN unzip /usr/local/bin/terraform.zip -d /usr/local/bin

ADD https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_linux_amd64.zip /usr/local/bin/packer.zip
RUN unzip /usr/local/bin/packer.zip -d /usr/local/bin

ADD https://packages.chef.io/files/stable/chefdk/3.2.30/ubuntu/18.04/chefdk_3.2.30-1_amd64.deb /tmp/chef.deb
RUN dpkg -i /tmp/chef.deb

### golang
RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.9
ENV LGOPATH /lgo
RUN mkdir -p $LGOPATH

RUN set -eux; \
    \
# this "case" statement is generated via "update.sh"
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) goRelArch='linux-amd64'; goRelSha256='d70eadefce8e160638a9a6db97f7192d8463069ab33138893ad3bf31b0650a79' ;; \
        armhf) goRelArch='linux-armv6l'; goRelSha256='b9d16a8eb1f7b8fdadd27232f6300aa8b4427e5e4cb148c4be4089db8fb56429' ;; \
        arm64) goRelArch='linux-arm64'; goRelSha256='98a42b9b8d3bacbcc6351a1e39af52eff582d0bc3ac804cd5a97ce497dd84026' ;; \
        i386) goRelArch='linux-386'; goRelSha256='e74f2f37b43b9b1bcf18008a11e0efb8921b41dff399a4f48ac09a4f25729881' ;; \
        ppc64el) goRelArch='linux-ppc64le'; goRelSha256='23291935a299fdfde4b6a988ce3faa0c7a498aab6d56bbafbf1e7476468529a3' ;; \
        s390x) goRelArch='linux-s390x'; goRelSha256='a67ef820ef8cfecc8d68c69dd5bf513aaf647c09b6605570af425bf5fe8a32f0' ;; \
        *) goRelArch='src'; goRelSha256='042fba357210816160341f1002440550e952eb12678f7c9e7e9d389437942550'; \
            echo >&2; echo >&2 "warning: current architecture ($dpkgArch) does not have a corresponding Go binary release; will be building from source"; echo >&2 ;; \
    esac; \
    \
    url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
    wget -O go.tgz "$url"; \
    echo "${goRelSha256} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    \
    if [ "$goRelArch" = 'src' ]; then \
        echo >&2; \
        echo >&2 'error: UNIMPLEMENTED'; \
        echo >&2 'TODO install golang-any from jessie-backports for GOROOT_BOOTSTRAP (and uninstall after build)'; \
        echo >&2; \
        exit 1; \
    fi; \
    \
    export PATH="/usr/local/go/bin:$PATH"; \
    go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p $GOPATH
RUN chown -R jovyan:users $GOPATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

### golang

RUN pip3 install --upgrade pip && hash -r pip

RUN chown -R jovyan:users /home/jovyan /lgo
COPY apps/spacemacs /home/jovyan/.emacs.d
RUN chown -R jovyan:users /home/jovyan/.emacs.d

USER jovyan

RUN go get github.com/yunabe/lgo/cmd/lgo && go get -d github.com/yunabe/lgo/cmd/lgo-internal
RUN go get -u github.com/nfnt/resize 
#RUN go get -u gonum.org/v1/gonum/... 
RUN go get -u gonum.org/v1/plot/... 
RUN go get -u github.com/wcharczuk/go-chart

RUN lgo install 
RUN lgo installpkg github.com/nfnt/resize
RUN lgo installpkg gonum.org/v1/gonum/...
RUN lgo installpkg gonum.org/v1/plot/...
RUN lgo installpkg github.com/wcharczuk/go-chart
RUN python $GOPATH/src/github.com/yunabe/lgo/bin/install_kernel

RUN pip install boto3 hvac iplantuml bash_kernel python-lambda-local
RUN python -m bash_kernel.install
RUN conda install -c conda-forge ipywidgets beakerx
RUN conda install -c pyviz holoviews bokeh
RUN jupyter labextension install beakerx-jupyterlab
RUN jupyter labextension install @pyviz/jupyterlab_pyviz
RUN python3 $GOPATH/src/github.com/yunabe/lgo/bin/install_kernel
RUN node /opt/conda/lib/python3.6/site-packages/jupyterlab/staging/yarn.js install
RUN jupyter labextension install @yunabe/lgo_extension
RUN jupyter labextension install @pyviz/jupyterlab_pyviz
ADD .zshrc $HOME/.zshrc

# install aws
RUN pip install awscli --upgrade --user
# install rise plugin for slides
RUN conda install rise --no-deps --yes
