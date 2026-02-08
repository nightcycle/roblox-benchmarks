#!/bin/bash
set -e
COMMIT_MESSAGE="${1:?'arg 1, COMMIT_MESSAGE, is not set'}"
RELEASE_VERSION="${2:?'arg 2, RELEASE_VERSION, is not set'}"

: "${DATA_REPO:=nightcycle/roblox-benchmarks-data}"
export DATA_REPO
echo "Using repo name: $DATA_REPO"

: "${DATA_REPO_BRANCH:=main}"
export DATA_REPO_BRANCH
echo "Using repo branch: $DATA_REPO_BRANCH"

: "${DATA_DIR_PATH:=data}"
export DATA_DIR_PATH
echo "Using data dir path: $DATA_DIR_PATH"

commit_directory() {
    local dir="$1"
    local message="${2:-Update files}"

    # Get the latest commit SHA
    latest_commit=$(curl -s -H "Authorization: token $DATA_RELEASE_TOKEN" \
        "https://api.github.com/repos/$DATA_REPO/git/refs/heads/$DATA_BRANCH" | jq -r '.object.sha')
	echo "Latest commit: $latest_commit"

    # Get the tree SHA from that commit
    base_tree=$(curl -s -H "Authorization: token $DATA_RELEASE_TOKEN" \
        "https://api.github.com/repos/$DATA_REPO/git/commits/$latest_commit" | jq -r '.tree.sha')

	echo "Base tree: $base_tree"
    # Build tree array from directory files
    tree_items="["
    first=true

    while IFS= read -r -d '' file; do
        # Get relative path from DATA_DIR_PATH
        rel_path="${file#$dir/}"
		echo "Processing file: $rel_path"
        # Read and encode file content
        content=$(base64 -w 0 < "$file" 2>/dev/null || base64 < "$file")

        # Add comma separator for all but first item
        if [ "$first" = true ]; then
            first=false
        else
            tree_items+=","
        fi

        # Add file to tree
        tree_items+=$(cat <<EOF
{
  "path": "$rel_path",
  "mode": "100644",
  "type": "blob",
  "content": "$(echo -n "$content" | jq -Rs .)"
}
EOF
)
    done < <(find "$dir" -type f -print0)

    tree_items+="]"

    # Create new tree
    new_tree=$(curl -s -X POST -H "Authorization: token $DATA_RELEASE_TOKEN" \
        -H "Content-Type: application/json" \
        "https://api.github.com/repos/$DATA_REPO/git/trees" \
        -d "{\"base_tree\": \"$base_tree\", \"tree\": $tree_items}" | jq -r '.sha')
	echo "New tree: $new_tree"

    # Create new commit
    new_commit=$(curl -s -X POST -H "Authorization: token $DATA_RELEASE_TOKEN" \
        -H "Content-Type: application/json" \
        "https://api.github.com/repos/$DATA_REPO/git/commits" \
        -d "{\"message\": \"$message\", \"tree\": \"$new_tree\", \"parents\": [\"$latest_commit\"]}" | jq -r '.sha')
	echo "New commit: $new_commit"
    # Update reference
    curl -s -X PATCH -H "Authorization: token $DATA_RELEASE_TOKEN" \
        -H "Content-Type: application/json" \
        "https://api.github.com/repos/$DATA_REPO/git/refs/heads/$DATA_BRANCH" \
        -d "{\"sha\": \"$new_commit\"}"

    echo "Committed directory $dir as $new_commit"
}

# Usage
commit_directory "$DATA_DIR_PATH" "$COMMIT_MESSAGE"