#!/bin/bash

# Constants
SOURCE_ORG="WordPress"
TARGET_ORG="WPBackup"

# Authenticate with GitHub CLI
# Ensure you have logged in using `gh auth login` before running this script

# List all repositories in the source organization with a limit of 500
repos=$(gh repo list $SOURCE_ORG --limit 500 --json name --jq '.[].name')

# Fork each repository to the target organization
for repo in $repos; do
    echo "Forking $repo..."
    gh repo fork "$SOURCE_ORG/$repo" --org $TARGET_ORG --clone=false
    if [ $? -eq 0 ]; then
        echo "Successfully forked $repo to $TARGET_ORG."
    else
        echo "Failed to fork $repo."
    fi
done
