#!/bin/sh
set -e
echo "Running benchmark"

DATA_SUBMODULE_PATH="${1:?'arg 1, DATA_SUBMODULE_PATH, is not set'}"
echo "Using data submodule: $DATA_SUBMODULE_PATH"

DATA_DIR_PATH="${1:?'arg 1, DATA_DIR_PATH, is not set'}"
echo "Using data directory: $DATA_DIR_PATH"

DATA_RELEASE_VERSION="${1:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
echo "Using data release version: $DATA_RELEASE_VERSION"

BRANCH_NAME_ENDING=$(printf '%s' "$DATA_RELEASE_VERSION" | tr '.' '-')
BRANCH_NAME="release/$BRANCH_NAME_ENDING"
export BRANCH_NAME="$BRANCH_NAME"
sh scripts/workflow/benchmark/pull.sh

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

# if DATA_DIR_PATH doesn't exist, create it
cd "$DATA_SUBMODULE_PATH"
if [ ! -d "$DATA_DIR_PATH" ]; then
	mkdir -p "$DATA_DIR_PATH"
fi
cd ..
# RAW_RESULTS_FILE=$(mktemp)
RAW_RESULTS_FILE="$DATA_SUBMODULE_PATH/$DATA_DIR_PATH/raw.json"
export RAW_RESULTS_FILE

echo "executing benchmark..."
sh scripts/workflow/benchmark/run.sh "$BENCHMARK_PATH"
echo "benchmark completed"

cd "$DATA_SUBMODULE_PATH"
BRANCH_NAME_ENDING=$(printf '%s' "$DATA_RELEASE_VERSION" | tr '.' '-')
BRANCH_NAME="release/$BRANCH_NAME_ENDING"
# check if branch exists
set +e
git fetch origin
git checkout -b "$BRANCH_NAME"
set -e
git fetch origin
git checkout "$BRANCH_NAME"
cd ..

echo "processing benchmark results..."
sh scripts/workflow/benchmark/process-data.sh
echo "finished processing benchmark results"
rm -f "$RAW_RESULTS_FILE"

sh scripts/workflow/benchmark/commit.sh

echo "opening data submodule"
echo "benchmark workflow completed successfully."
exit 0