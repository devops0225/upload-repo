#!/bin/bash

# Function to set up Maven settings
setup_maven() {
  echo "Setting up Maven..."
  cd ~
  mkdir -p ~/.m2
  cat <<EOF > ~/.m2/settings.xml
<settings xmlns="https://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <offline>true</offline>
</settings>
EOF
  echo "Maven setup complete."
}

# Function to update setenv file
update_setenv() {
  echo "Updating setenv file..."
  cd /opt/tlm/matching-3.0.1.11/
  cat <<EOF >> bin/setenv
export JAVA_MIN_MEM=6G
export JAVA_MAX_MEM=12G
export JAVA_PERM_MEM=256M
export JAVA_MAX_PERM_MEM=512M
EOF
  echo "setenv file updated."
}

# Function to execute matching and related commands
execute_matching() {
  echo "Executing matching..."
  cd /opt/tlm/matching/bin
  chmod 755 *
  ./matching

  echo "Waiting for matching shell to load..."
  tail -f /opt/tlm/matching/data/log/matching.log | while read -r line; do
    if [[ $line == *"Matching shell loaded"* ]]; then
      break
    fi
  done

  echo "Executing additional commands..."
  ./client_command1.sh &
  ./client_command2.sh &
  ./client_command3.sh &

  echo "Waiting for missing components to be resolved..."
  while [[ $(./mfw | grep "Missing components") ]]; do
    ./mfw
    sleep 5
  done

  echo "Exporting config if needed..."
  ./app-config:export
}

# Main script execution
echo "Starting setup..."
setup_maven
update_setenv
execute_matching
echo "Setup complete."