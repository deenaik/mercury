#!/bin/bash

# Set the environment variable with both paths
export PROJECT_PATH="/home/deepak/workspace/project-mercury"

# Extract the paths from the environment variable
requirements_file_path="$PROJECT_PATH/requirements.txt"
server_file_path="$PROJECT_PATH/server.py"

# Set the PostgreSQL password
export PG_PASSWORD="mercury"

# Set the PostgreSQL user and database names
export PG_USER="mercury"
export PG_DATABASE="mercury"

# Install required Python packages from requirements file
pip3 install -r "$requirements_file_path"

# Start the Python server
python "$server_file_path"
