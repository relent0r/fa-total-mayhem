#!/bin/bash

# Check if the source directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <source-directory>"
  exit 1
fi

# Check if the target directory is provided
if [ -z "$2" ]; then
  echo "Usage: $0 <source-directory> <target-directory>"
  exit 1
fi

# Source directory
sourcedir="$1"
echo "Source Directory: $sourcedir"

# Target directory
targetdir="$2"
echo "Target Directory: $targetdir"

# Create the target directory if it doesn't exist
mkdir -p "$targetdir"

# List all files in the source directory
for name in "$sourcedir"/*; do
  # Check if the file ends with 'icon.png' (case insensitive)
  if [[ "${name,,}" == *icon.png ]]; then
    # Extract the base name without the _icon.png part
    base=$(basename "$name")
    newname=$(echo "${base%_icon.png}" | tr '[:lower:]' '[:upper:]')_icon.png
    
    # Copy the file to the target directory with the new name
    cp "$name" "$targetdir/$newname"
  fi
done

echo "end"