#!/bin/sh
set -e
echo "Running benchmark"

: "${DATA_SUBMODULE_PATH:?'arg 1, DATA_SUBMODULE_PATH, is not set'}"
echo "Using data submodule: $DATA_SUBMODULE_PATH"

: "${DATA_DIR_PATH:?'arg 1, DATA_DIR_PATH, is not set'}"
echo "Using data directory: $DATA_DIR_PATH"

cd "$DATA_SUBMODULE_PATH"
rm -rf "${DATA_DIR_PATH:?}/"
cd ..

sh scripts/workflow/benchmark/commit.sh "resetting ${DATA_SUBMODULE_PATH}"