#!/bin/bash

# Array of wrapper script names
wrapper_scripts=("wrapper.sh" "wrapper-2.sh" "wrapper-3.sh" "wrapper-4.sh")

# Array of registration script names
registration_scripts=("sn-reg.sh" "sn-reg-2.sh" "sn-reg-3.sh" "sn-reg-4.sh")

# Function to kill processes by name
kill_processes() {
  local script_names=("$@")
  for script_name in "${script_names[@]}"; do
    pids=$(pgrep -f "$script_name")
    if [ ! -z "$pids" ]; then
      echo "Killing processes for $script_name: $pids"
      kill $pids
    else
      echo "No processes found for $script_name."
    fi
  done
}

# Kill processes associated with wrapper scripts
kill_processes "${wrapper_scripts[@]}"

# Kill processes associated with registration scripts
kill_processes "${registration_scripts[@]}"
