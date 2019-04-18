#!/bin/bash

set -euo pipefail
export IFS=$'\n\t'

name=corydodt/circus-base

ver=$(python3 setup.py --version)

docker build -f Dockerfile . -t $name:latest
docker tag $name:latest $name:${ver}
