#!/bin/bash

# Create a new directory named "copied_files" (if it doesn't already exist)
mkdir -p copied_files

# Loop through all .wgs.txt symbolic links
for symlink in *.wgs.txt; do
    # Get the actual file the symlink points to
    target_file=$(readlink -f "$symlink")
    
    # Copy the target file to the new folder
    cp "$target_file" copied_files/
done

