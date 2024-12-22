#!/bin/bash

# Constants
SOURCE_ORG="WordPress"
TARGET_ORG="WPBackup"

# Authenticate with GitHub CLI
if [ -n "$GITHUB_TOKEN" ]; then
    echo "Authenticating with GitHub using the provided token..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
fi

# Check existing GitHub CLI authentication
echo "Checking existing GitHub CLI authentication..."
if ! gh auth status &>/dev/null; then
    echo "No valid GitHub CLI authentication found. Please log in using 'gh auth login'."
    exit 1
fi

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
