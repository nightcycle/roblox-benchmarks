#!/bin/sh
set -e
RELEASE_VERSION="${1:?'arg 1, RELEASE_VERSION, is not set'}"

# remove old data
BRANCH_NAME_ENDING=$(printf '%s' "$RELEASE_VERSION" | tr '.' '-')
BRANCH_NAME="release/$BRANCH_NAME_ENDING"
DATA_SUBMODULE_PATH="data"
git pull origin "$BRANCH_NAME"
git submodule update --init --recursive
cd "$DATA_SUBMODULE_PATH"
git rm -r src/
git commit -m "reset data"
git push origin "$BRANCH_NAME"
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