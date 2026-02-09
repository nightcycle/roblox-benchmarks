#!/bin/sh
set -e
echo "Running benchmark"

DATA_RELEASE_VERSION="${1:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
echo "Using data release version: $DATA_RELEASE_VERSION"

: "${BENCHMARK_PATH:=src/server/benchmarks/types/vector3/init}"
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

echo "Publishing build..."
PLACE_VERSION=$(sh scripts/workflow/benchmark/publish.sh | tail -n 1)
export PLACE_VERSION
echo "Place version: $PLACE_VERSION"

# saving the results
DATA_SUBMODULE_PATH="data"
DATA_DIR_PATH="$DATA_SUBMODULE_PATH/src"
export DATA_DIR_PATH

echo "executing benchmark..."
# scripts/workflow/benchmark/run.sh "$BENCHMARK_PATH"
BENCHMARK_RESULT=$(sh scripts/workflow/benchmark/run.sh "$BENCHMARK_PATH" | tail -n 1)
if [ -z "$BENCHMARK_RESULT" ]; then
	echo "benchmark failed"
	exit 1
fi
echo "benchmark completed"

cd $DATA_SUBMODULE_PATH
BRANCH_NAME_ENDING=$(echo "$DATA_RELEASE_VERSION" | tr '.' '-')
BRANCH_NAME="release/$BRANCH_NAME_ENDING"
# git pull origin "$BRANCH_NAME"
# if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
# 	echo "creating data release branch at $BRANCH_NAME"
# 	git checkout -b "$BRANCH_NAME" origin/main  # or whatever base branch/commit
# 	echo "data release branch created: $BRANCH_NAME"
# else
# 	git checkout "$BRANCH_NAME"
# 	echo "data release branch checked out: $BRANCH_NAME"
# fi
cd ..

echo "processing benchmark results..."
sh scripts/workflow/benchmark/process-data.sh "$BENCHMARK_RESULT"
echo "finished processing benchmark results"

# # commit and push the results
# cd $DATA_SUBMODULE_PATH
# git commit -m "Update benchmark results for $DATA_RELEASE_VERSION"
# git push origin "$BRANCH_NAME"
# echo "benchmark results committed and pushed to branch: $BRANCH_NAME"
cd ..

echo "benchmark workflow completed successfully."
exit 0