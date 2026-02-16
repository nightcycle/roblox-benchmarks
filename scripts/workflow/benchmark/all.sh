#!/bin/sh
set -e
DATA_RELEASE_VERSION="${1:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
export DATA_RELEASE_VERSION="$DATA_RELEASE_VERSION"

BRANCH_NAME_ENDING=$(printf '%s' "$DATA_RELEASE_VERSION" | tr '.' '-')
BRANCH_NAME="release/$BRANCH_NAME_ENDING"

export BRANCH_NAME="$BRANCH_NAME"

cd "$DATA_SUBMODULE_PATH"
if git ls-remote --exit-code --heads origin "$BRANCH_NAME" >/dev/null 2>&1; then
  git push origin --delete "$BRANCH_NAME"
fi
cd ..

sh scripts/workflow/benchmark/pull.sh
sh scripts/workflow/benchmark/reset.sh

export BENCHMARK_PATH=src/server/benchmarks/types/brickcolor
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/types/color3
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/types/rect
sh scripts/workflow/benchmark/init.sh "$DATA_RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/types/vector2
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/types/vector3
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/function
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/loop
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/math/constrain
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/math/noise
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/math/operations
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/math/rounding
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/math/sqrt
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/table
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/tostring
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/type
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"

export BENCHMARK_PATH=src/server/benchmarks/luau/var
sh scripts/workflow/benchmark/init.sh "$RELEASE_VERSION"