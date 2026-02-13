#!/bin/sh
set -e
echo "Running benchmark"

# initialize git submodules
git submodule update --init --recursive

DATA_RELEASE_VERSION="${1:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
echo "Using data release version: $DATA_RELEASE_VERSION"

: "${BENCHMARK_PATH:?'arg 1, BENCHMARK_PATH, is not set'}"
export BENCHMARK_PATH
echo "Using benchmark path: $BENCHMARK_PATH"

: "${PROJECT:=default.project.json}"
export PROJECT
echo "Using project file: $PROJECT"

: "${BUILD_PATH:=build.rbxl}"
export BUILD_PATH
echo "Using build path: $BUILD_PATH"

: "${SOURCEMAP:=sourcemap.json}"
export SOURCEMAP
echo "Using sourcemap path: $SOURCEMAP"

: "${UNIVERSE_ID:=9690745121}"
export UNIVERSE_ID
echo "Using universe id: $UNIVERSE_ID"

: "${PLACE_ID:=111123068113322}"
export PLACE_ID
echo "Using place id: $PLACE_ID"

: "${RBX_API_KEY:?RBX_API_KEY is not set, it should have publish and luau execution perms}"
export RBX_API_KEY
echo "Found RBX_API_KEY"

echo "Publishing build..."
PLACE_VERSION=$(sh scripts/workflow/benchmark/publish.sh | tail -n 1)
export PLACE_VERSION
echo "Place version: $PLACE_VERSION"

# saving the results
DATA_SUBMODULE_PATH="data"
DATA_DIR_PATH="$DATA_SUBMODULE_PATH/src"
export DATA_DIR_PATH

# if DATA_DIR_PATH doesn't exist, create it
if [ ! -d "$DATA_DIR_PATH" ]; then
	mkdir -p "$DATA_DIR_PATH"
fi

# RAW_RESULTS_FILE=$(mktemp)
RAW_RESULTS_FILE="$DATA_DIR_PATH/raw.json"
export RAW_RESULTS_FILE

echo "executing benchmark..."
sh scripts/workflow/benchmark/run.sh "$BENCHMARK_PATH"
echo "benchmark completed"

cd $DATA_SUBMODULE_PATH
BRANCH_NAME_ENDING=$(printf '%s' "$DATA_RELEASE_VERSION" | tr '.' '-')
BRANCH_NAME="release/$BRANCH_NAME_ENDING"
# check if branch exists
set +e
git fetch origin "$BRANCH_NAME"
git checkout -b "$BRANCH_NAME"
set -e
git fetch origin "$BRANCH_NAME"
git checkout "$BRANCH_NAME"
cd ..

echo "processing benchmark results..."
sh scripts/workflow/benchmark/process-data.sh
echo "finished processing benchmark results"
rm -f "$RAW_RESULTS_FILE"

echo "opening data submodule"
# # commit and push the results
cd $DATA_SUBMODULE_PATH
# git add all files under src
echo "committing data changes"
git pull origin "$BRANCH_NAME"
git add src/
git commit -m "benchmark data generated from '$BENCHMARK_PATH' for release '$DATA_RELEASE_VERSION'"
git push origin "$BRANCH_NAME"
echo "benchmark results committed and pushed to branch: $BRANCH_NAME"
cd ..

echo "benchmark workflow completed successfully."
exit 0