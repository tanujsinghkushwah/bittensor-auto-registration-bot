#!/bin/bash

SCRIPT="./sn-reg-3.sh"
LOG_FILE="reg-logs-3.log"
WRAPPER_PID="wrapper-3.pid"

# Function to log messages with timestamp
log_message() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1"
}

# Check if the wrapper is already running
if [ -f "$WRAPPER_PID" ]; then
    log_message "Wrapper is already running. Exiting."
    exit 1
fi

# Store the current PID in a file
echo $$ > "$WRAPPER_PID"

# Main loop
while true; do
    # Run the main script in the background
    nohup $SCRIPT > $LOG_FILE 2>&1 &

    # Get the PID of the background process
    PID=$!

    # Wait for the background process to finish
    wait $PID

    # Check the exit status of the background process
    EXIT_STATUS=$?
    log_message "auto-reg.sh process exited with status: $EXIT_STATUS"
    
    if [ $EXIT_STATUS -eq 128 ]; then
        log_message "auto-reg.sh process completed successfully. Exiting wrapper."
        break  # Exit the main loop
    else
        log_message "Error: auto-reg.sh process exited with non-zero status. Restarting script..."
    fi

    # Wait for a while before restarting
    sleep 3
done

# Remove the PID file when the script exits
rm "$WRAPPER_PID"
