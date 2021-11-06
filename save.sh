#!/usr/bin/env bash

# I haven't found much point in writing commit messages for content updates to
# my solo blog. So I'm going to try an empty-commit-message-only approach.

set -ex

shellcheck "${BASH_SOURCE[0]}"

cd "$(dirname "${BASH_SOURCE[0]}")"
git add -A
git commit --allow-empty-message -m ""
