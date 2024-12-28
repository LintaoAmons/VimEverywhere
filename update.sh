#!/bin/bash

# Change to the directory containing the script
cd "$(dirname "$0")" || {
    echo "Error: Failed to change directory."
    exit 1
}

# Source the paths of the configuration files
if [[ -f .local/source-paths.sh ]]; then
    source .local/source-paths.sh
else
    echo "Error: .local/source-paths.sh not found."
    exit 1
fi

# Define items and paths using simple array
items=(
    "nvim"
)
paths=(
    "$NVIM"
)

# Iterate through the items and synchronize each configuration file
for i in "${!items[@]}"; do
    item=${items[$i]}
    path=${paths[$i]}
    if [[ -n "$path" ]]; then
        rsync -avz --delete "$path" "./$item"
    else
        echo "Warning: Path for $item is not set or is empty. Skipping synchronization."
    fi
done
