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
echo "Checking out ${BRANCH_NAME}"
git checkout main
echo "Pulling latest changes from main and ${BRANCH_NAME}"
git pull origin main
echo "Pulling latest changes from ${BRANCH_NAME}"
git pull origin "$BRANCH_NAME" || {
	echo "Branch ${BRANCH_NAME} does not exist, creating it"
	git checkout -b "$BRANCH_NAME"
	echo "Pushing ${BRANCH_NAME} to origin"
	git push -u origin "$BRANCH_NAME"
	echo "Finished setting up ${BRANCH_NAME}"
}
echo "Finished pulling benchmark data"
git checkout "$BRANCH_NAME"
echo "Finished setting up ${BRANCH_NAME}"
cd ..