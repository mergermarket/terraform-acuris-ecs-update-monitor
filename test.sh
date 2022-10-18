#!/bin/bash

set -euo pipefail

repo_dir=$(git rev-parse --show-toplevel)
name=$(basename $repo_dir)-test

docker build -t $name -f Dockerfile.test .

docker run \
    --name $name \
    --rm \
    -i $(tty -s && echo -t) \
    $(tty -s && echo -v $(pwd)/.hypothesis/:/usr/src/app/.hypothesis/) \
    $name \
        py.test \
        -n auto \
        --cov=./ecs_update_monitor \
        --cov-report term-missing \
        --tb=short \
        "$@"

docker run \
    --name $name \
    --rm \
    $name \
        flake8 --max-complexity=5
