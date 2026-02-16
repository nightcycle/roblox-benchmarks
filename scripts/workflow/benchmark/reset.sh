#!/bin/sh
set -e
echo "Running benchmark"

: "${DATA_SUBMODULE_PATH:?'arg 1, DATA_SUBMODULE_PATH, is not set'}"
echo "Using data submodule: $DATA_SUBMODULE_PATH"

: "${DATA_DIR_PATH:?'arg 1, DATA_DIR_PATH, is not set'}"
echo "Using data directory: $DATA_DIR_PATH"

cd "$DATA_SUBMODULE_PATH"
if [ ! -d "$DATA_DIR_PATH" ]; then
	exit 0
fi
git rm -rf "${DATA_DIR_PATH:?}/"
git commit -m "resetting ${DATA_SUBMODULE_PATH}"
git push origin HEAD:"${BRANCH_NAME}"
cd ..
echo "Finished resetting benchmark data"