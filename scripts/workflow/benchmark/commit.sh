#!/bin/sh
set -e
echo "Running benchmark"

: "${DATA_RELEASE_VERSION:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
echo "Using data release version: $DATA_RELEASE_VERSION"

: "${DATA_SUBMODULE_PATH:?'arg 1, DATA_SUBMODULE_PATH, is not set'}"
echo "Using data submodule: $DATA_SUBMODULE_PATH"

: "${DATA_DIR_PATH:?'arg 1, DATA_DIR_PATH, is not set'}"
echo "Using data directory: $DATA_DIR_PATH"

: "${1:=benchmark data generated from \"${BENCHMARK_PATH}\" for release \"${DATA_RELEASE_VERSION}\"}"
echo "Using commit message: $1"

# # commit and push the results
cd "$DATA_SUBMODULE_PATH"

# git add all files under DATA_DIR_PATH
git add "$DATA_DIR_PATH/"
git commit -m "$1"
git push origin

cd ..