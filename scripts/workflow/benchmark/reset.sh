#!/bin/sh
set -e
echo "Resetting benchmark data"

: "${DATA_SUBMODULE_PATH:?'arg 1, DATA_SUBMODULE_PATH, is not set'}"
echo "Using data submodule: $DATA_SUBMODULE_PATH"

: "${DATA_DIR_PATH:?'arg 1, DATA_DIR_PATH, is not set'}"
echo "Using data directory: $DATA_DIR_PATH"

cd "$DATA_SUBMODULE_PATH"
if [ ! -d "$DATA_DIR_PATH" ]; then
	echo "Data directory does not exist, nothing to reset"
	exit 0
fi
echo "Resetting benchmark data in ${DATA_SUBMODULE_PATH}/${DATA_DIR_PATH}"
git rm -rf "${DATA_DIR_PATH:?}/"
echo "Committing reset benchmark data"
git commit -m "resetting ${DATA_SUBMODULE_PATH}"
echo "Pushing reset benchmark data to ${BRANCH_NAME}"
git push origin HEAD:"${BRANCH_NAME}"
echo "Finished pushing reset benchmark data"
cd ..
echo "Finished resetting benchmark data"