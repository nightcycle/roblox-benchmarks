#!/bin/sh
RELEASE_VERSION="${1:?'arg 1, RELEASE_VERSION, is not set'}"
BENCHMARK_PATH=src/server/benchmarks/luau/function
export BENCHMARK_PATH
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"
BENCHMARK_PATH=src/server/benchmarks/luau/loop
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"
BENCHMARK_PATH=src/server/benchmarks/luau/math
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"
BENCHMARK_PATH=src/server/benchmarks/luau/table
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"
BENCHMARK_PATH=src/server/benchmarks/luau/tostring
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"
BENCHMARK_PATH=src/server/benchmarks/types/type
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"
BENCHMARK_PATH=src/server/benchmarks/types/var
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"