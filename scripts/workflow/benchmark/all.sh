#!/bin/sh
set -e
DATA_RELEASE_VERSION="${1:?'arg 1, DATA_RELEASE_VERSION, is not set'}"
export DATA_RELEASE_VERSION="$DATA_RELEASE_VERSION"

RUN_COUNT="${2:?'arg 2, RUN_COUNT, is not set'}"
export RUN_COUNT="$RUN_COUNT"

BRANCH_NAME_ENDING=$(printf '%s' "$DATA_RELEASE_VERSION" | tr '.' '-')
BRANCH_NAME="release/$BRANCH_NAME_ENDING"

export BRANCH_NAME="$BRANCH_NAME"

if [ -f .env ]; then
  echo "Loading environment variables from .env file"
  export "$(grep -v '^#' .env | xargs)"
else
  echo "No .env file found, skipping environment variable loading"
fi

cd "$DATA_SUBMODULE_PATH"
if git ls-remote --exit-code --heads origin "$BRANCH_NAME" >/dev/null 2>&1; then
  git push origin --delete "$BRANCH_NAME"
fi
cd ..

sh scripts/workflow/benchmark/pull.sh
if [ -z "$BENCHMARK_FILTER" ]; then
  sh scripts/workflow/benchmark/reset.sh
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/noise"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/sqrt"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/constrain"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/operations/add"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/operations/bool"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/operations/divide"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/operations/mod"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/operations/multiply"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/operations/subtract"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/rounding"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/bit32"
  # sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/buffer"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/types/brickcolor"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/types/color3"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/types/rect"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/types/vector2"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/types/vector3"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/function"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/loop"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/table"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/tostring"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/type"
  sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/var" --summarize
else
  echo "running '$BENCHMARK_FILTER'"
  if [ -d "$DATA_SUBMODULE_PATH/$DATA_DIR_PATH/$BENCHMARK_FILTER" ]; then
    rm -rf "$DATA_SUBMODULE_PATH/$DATA_DIR_PATH/$BENCHMARK_FILTER"
  fi
  sh scripts/workflow/benchmark/init.sh "$BENCHMARK_FILTER" --summarize
fi



# gh pr create --base main --head "$BRANCH_NAME" --title "$DATA_RELEASE_VERSION" --fill