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

# Install prerequisites
sudo apt update
sudo apt install -y python3 python3-pip postgresql

# Check if the PostgreSQL user exists
sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$PG_USER'" | grep -q 1
if [ $? -ne 0 ]; then
  # Create the PostgreSQL user
  sudo -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PASSWORD';"
fi

# Check if the PostgreSQL database exists
sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "$PG_DATABASE"
if [ $? -ne 0 ]; then
  # Create the PostgreSQL database
  sudo -u postgres createdb $PG_DATABASE

  # Grant privileges to the user on the database
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PG_DATABASE TO $PG_USER;"

  # Connect to the database and create the table
  sudo -u postgres psql -d $PG_DATABASE -c "$CREATE_TABLE_SQL"

  # Grant privileges to the user on the table
  sudo -u postgres psql -d $PG_DATABASE -c "GRANT ALL PRIVILEGES ON $TABLE_NAME TO $PG_USER;"
fi

# Install required Python packages from requirements file
pip3 install -r "$requirements_file_path"
