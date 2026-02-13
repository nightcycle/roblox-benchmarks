#!/bin/sh
set -e
RELEASE_VERSION="${1:?'arg 1, RELEASE_VERSION, is not set'}"

# saving the results
DATA_SUBMODULE_PATH="data"
cd "$DATA_SUBMODULE_PATH"
git rm -r src/
git commit -m "reset data"
cd ..

# export BENCHMARK_PATH=src/server/benchmarks/types/brickcolor
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/types/color3
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/types/rect
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/types/vector2
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/types/vector3
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/luau/function
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/luau/loop
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/luau/math
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/luau/table
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/luau/tostring
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/luau/type
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

# export BENCHMARK_PATH=src/server/benchmarks/luau/var
# sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"