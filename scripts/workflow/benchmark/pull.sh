#!/bin/sh
set -e
echo "Running benchmark"

# initialize git submodules
git submodule update --init --recursive

: "${DATA_RELEASE_VERSION:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
echo "Using data release version: $DATA_RELEASE_VERSION"

: "${DATA_SUBMODULE_PATH:?'arg 1, DATA_SUBMODULE_PATH, is not set'}"
echo "Using data submodule: $DATA_SUBMODULE_PATH"

: "${DATA_DIR_PATH:?'arg 1, DATA_DIR_PATH, is not set'}"
echo "Using data directory: $DATA_DIR_PATH"

cd "$DATA_SUBMODULE_PATH"
git pull origin "$BRANCH_NAME"
git checkout "$BRANCH_NAME" || git checkout -b "$BRANCH_NAME"
cd ..