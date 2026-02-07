#!/bin/sh
set -e
echo "running benchmark"
BENCHMARK_PATH="${1:?'arg 1, BENCHMARK_PATH, is not set'}"
echo "Using benchmark path: $BENCHMARK_PATH"
