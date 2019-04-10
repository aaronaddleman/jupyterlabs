#!/bin/bash

set -e

# build docker file
docker build -t gcr.io/${PROJECT}/${IMAGE}:$TRAVIS_COMMIT .

# configure gcloud
gcloud --quiet config set project $PROJECT
gcloud --quiet config set compute/zone ${ZONE}

# push docker image
gcloud docker -- push gcr.io/${PROJECT}/${IMAGE}
