#!/bin/bash

# Function to log messages with timestamps
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1"
}

# Delete files in order
log "Deleting files:"
rm -f reg-logs.log && log "Deleted reg-logs.log"
rm -f reg-logs-2.log && log "Deleted reg-logs-2.log"
rm -f reg-logs-3.log && log "Deleted reg-logs-3.log"
rm -f reg-logs-4.log && log "Deleted reg-logs-4.log"
rm -f wrapper.pid && log "Deleted wrapper.pid"
rm -f wrapper-2.pid && log "Deleted wrapper-2.pid"
rm -f wrapper-3.pid && log "Deleted wrapper-3.pid"
rm -f wrapper-4.pid && log "Deleted wrapper-4.pid"
rm -f launcher.log && log "Deleted launcher.log"

# Copy files
log "Copying files:"
cp -f sn-reg.sh sn-reg-2.sh && log "Copied sn-reg.sh to sn-reg-2.sh"
cp -f sn-reg.sh sn-reg-3.sh && log "Copied sn-reg.sh to sn-reg-3.sh"
cp -f sn-reg.sh sn-reg-4.sh && log "Copied sn-reg.sh to sn-reg-4.sh"

# Log completion message
log "Script execution completed."
