#!/bin/sh
set -e

rokit install

choco install jq -y # if this yields forever, use an admin terminal outside of your IDE
jq --version # restart your terminal if this errors

choco install gh -y # if this yields forever, use an admin terminal outside of your IDE
gh --version # restart your terminal if this errors, otherwise check that C:\Program Files\GitHub CLI is in your path

REPO_URL="https://github.com/nightcycle/roblox-benchmarks-data.git"
SUBMODULE_PATH="data"  # Where you want the submodule in your repo
BRANCH="main"
git submodule add -b "$BRANCH" "$REPO_URL" "$SUBMODULE_PATH"
git submodule update --init --recursive
git add .gitmodules "$SUBMODULE_PATH"
git commit -m "Add benchmark data submodule"

sh scripts/build/init.sh

file-util run