#!/bin/sh
set -e

if [ ! -d "$DATA_SUBMODULE_PATH/$DATA_DIR_PATH" ]; then
	mkdir -p "$DATA_SUBMODULE_PATH/$DATA_DIR_PATH"
fi

# Use while read loop to avoid Windows line ending issues
jq -r '.output.results[0].data.raw | keys[]' "$RAW_RESULTS_FILE" | tr -d '\r' | while IFS= read -r path; do

    echo "Processing path: $path"

    # get directory above the file path
    dir=$(dirname "${DATA_SUBMODULE_PATH}/${DATA_DIR_PATH}/${path}")
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi

    # if file doesn't exist, create it and add header
    if [ ! -f "${DATA_SUBMODULE_PATH}/${DATA_DIR_PATH}/${path}" ]; then
        header=$(jq -r --arg k "$path" '.output.results[0].data.raw[$k].header' "$RAW_RESULTS_FILE")
        echo "Creating file with header: $header"
        echo "$header" > "${DATA_SUBMODULE_PATH}/${DATA_DIR_PATH}/${path}"
    fi

    # Extract value directly from file
    jq -r --arg k "$path" '.output.results[0].data.raw[$k].rows' "$RAW_RESULTS_FILE" > "${DATA_SUBMODULE_PATH}/${DATA_DIR_PATH}/${path}"
done
