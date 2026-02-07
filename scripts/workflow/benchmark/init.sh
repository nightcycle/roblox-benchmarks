#!/bin/sh
set -e
echo "running benchmark"
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
: "${API_KEY:?API_KEY is not set, it should have publish and luau execution perms}"
echo "found API_KEY"
export API_KEY

PLACE_VERSION=$(sh scripts/workflow/benchmark/publish.sh | tail -n 1)
export PLACE_VERSION
echo "Place version: $PLACE_VERSION"