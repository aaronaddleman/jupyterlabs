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

RUN apt-get update && apt-get install -my wget gnupg

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install -y nodejs && \
  jupyter labextension install @yunabe/lgo_extension && jupyter lab clean && \
  apt-get remove -y nodejs --purge && rm -rf /var/lib/apt/lists/*

RUN chown -R jovyan:users $LGOPATH
### golang

RUN pip3 install --upgrade pip && hash -r pip

RUN chown -R jovyan:users /home/jovyan
USER jovyan

RUN go get github.com/yunabe/lgo/cmd/lgo && go get -d github.com/yunabe/lgo/cmd/lgo-internal
RUN go get -u github.com/nfnt/resize 
RUN go get -u gonum.org/v1/gonum/... 
RUN go get -u gonum.org/v1/plot/... 
RUN go get -u github.com/wcharczuk/go-chart


RUN lgo install 
RUN lgo installpkg github.com/nfnt/resize
RUN lgo installpkg gonum.org/v1/gonum/...
RUN lgo installpkg gonum.org/v1/plot/...
RUN lgo installpkg github.com/wcharczuk/go-chart
RUN python $GOPATH/src/github.com/yunabe/lgo/bin/install_kernel


RUN pip install boto3 hvac iplantuml
RUN pip install bash_kernel
RUN pip install python-lambda-local
RUN python -m bash_kernel.install
RUN conda install -c conda-forge ipywidgets beakerx
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install beakerx-jupyterlab
RUN python3 $GOPATH/src/github.com/yunabe/lgo/bin/install_kernel

