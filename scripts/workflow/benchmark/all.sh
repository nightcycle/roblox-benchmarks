#!/bin/sh
RELEASE_VERSION="${1:?'arg 1, RELEASE_VERSION, is not set'}"

BENCHMARK_PATH=src/server/benchmarks/luau/function
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

BENCHMARK_PATH=src/server/benchmarks/luau/loop
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

BENCHMARK_PATH=src/server/benchmarks/luau/math
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

BENCHMARK_PATH=src/server/benchmarks/luau/table
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

BENCHMARK_PATH=src/server/benchmarks/luau/tostring
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

BENCHMARK_PATH=src/server/benchmarks/types/type
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

BENCHMARK_PATH=src/server/benchmarks/types/var
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"