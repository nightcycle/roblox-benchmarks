#!/bin/sh
set -e
echo "Running benchmark"

: "${DATA_RELEASE_VERSION:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
echo "Using data release version: $DATA_RELEASE_VERSION"

: "${DATA_SUBMODULE_PATH:?'arg 1, DATA_SUBMODULE_PATH, is not set'}"
echo "Using data submodule: $DATA_SUBMODULE_PATH"

: "${DATA_DIR_PATH:?'arg 1, DATA_DIR_PATH, is not set'}"
echo "Using data directory: $DATA_DIR_PATH"

if [ -z "$1" ]; then
	COMMIT_MESSAGE="benchmark data generated from '$BENCHMARK_PATH' for release '$DATA_RELEASE_VERSION'"
else
	COMMIT_MESSAGE="$1"
fi
echo "Using commit message: $COMMIT_MESSAGE"

# # commit and push the results
cd "$DATA_SUBMODULE_PATH"

# git add all files under DATA_DIR_PATH
git add -A "$DATA_DIR_PATH"
git commit -m "$COMMIT_MESSAGE"
git push origin HEAD:"${BRANCH_NAME}"

cd ..