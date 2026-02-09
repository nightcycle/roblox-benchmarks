#!/bin/sh
set -e


if [ ! -d "$DATA_DIR_PATH" ]; then
	mkdir -p "$DATA_DIR_PATH"
fi

# Use while read loop to avoid Windows line ending issues
jq -r '.output.results[0].data.raw | keys[]' "$RAW_RESULTS_FILE" | tr -d '\r' | while IFS= read -r path; do

    echo "Processing path: $path"

    # get directory above the file path
    dir=$(dirname "${DATA_DIR_PATH}/${path}")
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi

    # Extract value directly from file
    jq -r --arg k "$path" '.output.results[0].data.raw[$k]' "$RAW_RESULTS_FILE" > "${DATA_DIR_PATH}/${path}"
done

# Fix: correct path is .output.results[0].data.summary, not .data.summary
jq -r '.output.results[0].data.summary' "$RAW_RESULTS_FILE" > "$DATA_DIR_PATH/summary.csv"
