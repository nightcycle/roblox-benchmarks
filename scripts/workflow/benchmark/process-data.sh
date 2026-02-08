#!/bin/sh
set -e

RAW_BENCHMARK_RESULT="${1:?'arg 1, RAW_BENCHMARK_RESULT, is not set'}"

echo "$RAW_BENCHMARK_RESULT" > "$DATA_SUBMODULE_PATH/results.json"

