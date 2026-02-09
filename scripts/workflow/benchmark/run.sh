#!/bin/sh
set -e
echo "running benchmark"
BENCHMARK_PATH="${1:?'arg 1, BENCHMARK_PATH, is not set'}"
echo "Using benchmark path: $BENCHMARK_PATH"
SCRIPT_PATH="./scripts/workflow/benchmark/Agent.luau"
TIMEOUT=240
# append an s to the end of TIMEOUT
echo "Executing benchmark script..."
echo "Using universe id: $UNIVERSE_ID"
echo "Using place id: $PLACE_ID"
echo "Using place version: $PLACE_VERSION"
echo "Using script path: $SCRIPT_PATH"
SCRIPT_CONTENTS=$(cat "$SCRIPT_PATH")
# append "_G.FILTER_PATH='$BENCHMARK_PATH' to the top of $SCRIPT_CONTENTS"
SCRIPT_CONTENTS="_G.FILTER_PATH='${BENCHMARK_PATH}'_G.DATA_DIR='${DATA_DIR_PATH}';_G.IS_DEBUG=false;${SCRIPT_CONTENTS}"
echo "Using script contents:"
echo "------------------------"
echo "$SCRIPT_CONTENTS"
echo "------------------------"
EXECUTE_RESPONSE=$(rbxcloud luau execute \
	-u "$UNIVERSE_ID" \
	-i "$PLACE_ID" \
	-r "$PLACE_VERSION" \
	-s "${SCRIPT_CONTENTS}" \
	-t "${TIMEOUT}s" \
	-a "$RBX_API_KEY" \
	-p
)
echo "response: $EXECUTE_RESPONSE"
EXECUTE_PATH=$(echo "$EXECUTE_RESPONSE" | jq -r '.path')

# universes/9690745121/places/111123068113322/versions/3/luau-execution-sessions/157bfe18-3070-4950-b9b4-3a0a34376950/tasks/157bfe18-3070-4950-b9b4-3a0a34376950
# get the number after /tasks/ in EXECUTE_PATH
TASK_ID=$(echo "$EXECUTE_PATH" | awk -F'/tasks/' '{print $2}')
echo "Task ID: $TASK_ID"
SESSION_ID=$(echo "$EXECUTE_PATH" | awk -F'/luau-execution-sessions/' '{print $2}' | awk -F'/tasks/' '{print $1}')
echo "Session ID: $SESSION_ID"

echo "Waiting for execution to complete"
TASK_STATE=$(echo "$EXECUTE_RESPONSE" | jq -r '.state')
TASK_OUTPUT=""
TASK_RESPONSE=""
# ATTEMPTS=0
while [ "$TASK_STATE" = "PROCESSING" ]; do #&& [ $ATTEMPTS -lt $TIMEOUT ]; do
	echo "polling.."
	TASK_RES_HOLDER=""
	TASK_RES_HOLDER=$(curl \
		--request GET "https://apis.roblox.com/cloud/v2/universes/${UNIVERSE_ID}/places/${PLACE_ID}/versions/${PLACE_VERSION}/luau-execution-sessions/${SESSION_ID}/tasks/${TASK_ID}" \
		--header "x-api-key: $RBX_API_KEY"
	)
	LOGS_RESPONSE=$(rbxcloud luau get-logs \
		-u "$UNIVERSE_ID" \
		-i "$PLACE_ID" \
		-r "$PLACE_VERSION" \
		-s "$SESSION_ID" \
		-t "$TASK_ID" \
		-a "$RBX_API_KEY" \
		-w "flat" \
		-p
	)
	echo "$LOGS_RESPONSE"
	NEXT_PAGE_TOKEN=$(echo "$LOGS_RESPONSE" | jq -r '.nextPageToken')
	if [ -n "$NEXT_PAGE_TOKEN" ]; then
		echo "$NEXT_PAGE_TOKEN"
	fi
	TASK_RESPONSE="$TASK_RES_HOLDER"
	echo "Task response: $TASK_RESPONSE"
	TASK_STATE=$(echo "$TASK_RESPONSE" | jq -r '.state')
	echo "Task state: $TASK_STATE"
	if [ "$TASK_STATE" = "COMPLETE" ]; then
		TASK_OUTPUT=$(echo "$TASK_RESPONSE" | jq -r '.output.results[0]')
	fi
	sleep 5
	# ATTEMPTS=$((ATTEMPTS + 5))
done
if [ "$TASK_STATE" != "COMPLETE" ]; then
	echo "task failed"
	exit 1
fi
# echo this TASK_OUTPUT (a json value) on a single line
echo "$TASK_OUTPUT" | jq -c '.'