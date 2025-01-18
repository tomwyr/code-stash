#!/bin/bash

set -e

# Rename CLI
cli_source_file="$CLI_FILE_NAME$CLI_EXTENSION"
cli_target_file="gbc-$VERSION-$PLATFORM$CLI_EXTENSION"
cli_source_path=".build/release/$cli_source_file"
cli_target_path=".build/$cli_target_file"
cp $cli_source_path $cli_target_path
chmod +x $cli_target_path
echo "cli_path=$cli_target_path" >> $GITHUB_OUTPUT

# Rename library
lib_source_file="$LIB_FILE_NAME$LIB_EXTENSION"
lib_target_file="gbc-lib-$VERSION-$PLATFORM$LIB_EXTENSION"
lib_source_path=".build/release/$lib_source_file"
lib_target_path=".build/$lib_target_file"
cp $lib_source_path $lib_target_path
chmod +x $lib_target_path
echo "lib_path=$lib_target_path" >> $GITHUB_OUTPUT
