#!/bin/sh
set -e


if [ ! -d "$DATA_DIR_PATH" ]; then
	mkdir -p "$DATA_DIR_PATH"
fi

RAW_FILE_CONTENT=$(cat "$RAW_RESULTS_FILE")
RAW_MAP=$(printf '%s' "$RAW_FILE_CONTENT" | jq '.output.results[0].data.raw')

for path in $(echo "$RAW_MAP" | jq -r 'keys[]'); do
    echo "Processing path: $path"
    value=$(printf '%s' "$RAW_MAP" | jq -r --arg k "$path" '.[$k]')

    # get directory above the file path
    dir=$(dirname "${DATA_DIR_PATH}/${path}")
    # if the directory does not exist
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
    printf '%s' "$value" > "${DATA_DIR_PATH}/${path}"
done

SUMMARY=$(printf "%s" "$RAW_FILE_CONTENT" | jq -r '.data.summary')
printf "%s" "$SUMMARY" > "$DATA_DIR_PATH/summary.csv"
