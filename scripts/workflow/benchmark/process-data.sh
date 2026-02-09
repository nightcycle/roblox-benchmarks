#!/bin/sh
set -e

RAW_BENCHMARK_RESULT="${1:?'arg 1, RAW_BENCHMARK_RESULT, is not set'}"
echo "$RAW_BENCHMARK_RESULT" > "$DATA_DIR_PATH/results.json"
echo "$RAW_BENCHMARK_RESULT"
# RAW_MAP=$(echo "$EXECUTE_RESPONSE" | jq -r '.data.raw')

# # for each key,value in RAW_MAP
# for path in $(echo "$RAW_MAP" | jq -r 'keys[]'); do
# 	echo "Processing path: $path"
# 	value=$(echo "$RAW_MAP" | jq -r --arg k "$path" '.[$k]')
# 	# get directory above the file path
# 	dir=$(dirname "${DATA_DIR_PATH}/${path}")
# 	# if the directory does not exist
# 	if [ ! -d "$dir" ]; then
# 		mkdir -p "$dir"
# 	fi
# 	echo "$value" > "${DATA_DIR_PATH}/${path}"
# done

SUMMARY=$(echo "$EXECUTE_RESPONSE" | jq -r '.data.summary')
echo "sum $SUMMARY"
echo "$SUMMARY" > "$DATA_DIR_PATH/summary.csv"
