#!/bin/bash

set -euo pipefail
export IFS=$'\n\t'

name=corydodt/circus-base

ver=$(python3 -c 'from circusbase import __version__ as v; print(v)')

docker build -f Dockerfile . -t $name:latest
docker tag $name:latest $name:${ver}
