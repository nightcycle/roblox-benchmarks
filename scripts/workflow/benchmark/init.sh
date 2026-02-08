#!/bin/sh
set -e
echo "Running benchmark"

DATA_RELEASE_VERSION="${1:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
echo "Using data release version: $DATA_RELEASE_VERSION"

: "${BENCHMARK_PATH:=src/server/benchmarks}"
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

: "${DATA_UPDATE_TOKEN:?DATA_UPDATE_TOKEN is not set, you need it to commit / release results on the github repository}"
export DATA_UPDATE_TOKEN
echo "Found DATA_UPDATE_TOKEN"

# Initialize and update
echo "Initializing data submodule..."
git submodule update --init --recursive
echo "Data submodule initialized."

echo "Publishing build..."
PLACE_VERSION=$(sh scripts/workflow/benchmark/publish.sh | tail -n 1)
export PLACE_VERSION
echo "Place version: $PLACE_VERSION"

echo "executing benchmark..."
# scripts/workflow/benchmark/run.sh "$BENCHMARK_PATH"
BENCHMARK_RESULT=$(sh scripts/workflow/benchmark/run.sh "$BENCHMARK_PATH" | tail -n 1)
if [ -z "$BENCHMARK_RESULT" ]; then
	echo "benchmark failed"
	exit 1
fi
echo "benchmark completed: $BENCHMARK_RESULT"

DATA_SUBMODULE_PATH="data"

# Commit the submodule addition
echo "loading data submodules"
git add .gitmodules "$DATA_SUBMODULE_PATH"
git commit -m "Add benchmark data submodule"

echo "writing benchmark results to file..."
# write BENCHMARK results to file
echo "$BENCHMARK_RESULT" > "$DATA_SUBMODULE_PATH/results.txt"

# make a branch off of the submodule "data"
echo "creating data release branch..."
cd $DATA_SUBMODULE_PATH
# swap . with "-" for release name
BRANCH_NAME=$(echo "$DATA_RELEASE_NAME" | tr '.' '-')
git checkout -b "release/$BRANCH_NAME" origin/main  # or whatever base branch/commit
cd ..

