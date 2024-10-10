#!/bin/bash

LOG_FILE="launcher.log"

# Function to log messages with timestamp in IST
log_message() {
    local timestamp=$(TZ=Asia/Kolkata date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> $LOG_FILE
}

# Create clones of sn-reg.sh
cp sn-reg.sh sn-reg-2.sh
cp sn-reg.sh sn-reg-3.sh
cp sn-reg.sh sn-reg-4.sh

# Start wrapper scripts in sequence with a 10-second interval
nohup ./wrapper.sh >> $LOG_FILE 2>&1 &
log_message "Started wrapper.sh"
sleep 10
nohup ./wrapper-2.sh >> $LOG_FILE 2>&1 &
log_message "Started wrapper-2.sh"
sleep 10
nohup ./wrapper-3.sh >> $LOG_FILE 2>&1 &
log_message "Started wrapper-3.sh"
sleep 10
nohup ./wrapper-4.sh >> $LOG_FILE 2>&1 &
log_message "Started wrapper-4.sh"

# Store the PIDs of the wrapper processes and their corresponding sn-reg.sh scripts
WRAPPER_PIDS=("$(pgrep -f "wrapper.sh") $(pgrep -f "wrapper-2.sh") $(pgrep -f "wrapper-3.sh") $(pgrep -f "wrapper-4.sh")")
SN_REG_PIDS=("$(pgrep -f "sn-reg.sh") $(pgrep -f "sn-reg-2.sh") $(pgrep -f "sn-reg-3.sh") $(pgrep -f "sn-reg-4.sh")")

# Monitor the wrapper processes
while true; do
    # Check if any of the wrapper processes have exited
    for PID in $WRAPPER_PIDS; do
        if ! ps -p $PID > /dev/null; then
            # If any wrapper process has exited, kill all other wrapper processes and their corresponding sn-reg.sh scripts
            log_message "Wrapper process with PID $PID exited. Terminating other wrapper processes."
            kill $WRAPPER_PIDS $SN_REG_PIDS
            exit 0
        fi
    done
    sleep 10  # Check every 10 seconds
done

