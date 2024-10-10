#!/usr/bin/expect

set timeout 30  ;# Increase timeout value
set retry_interval 10  ;# Reduced retry interval

# Function to get the current timestamp
proc timestamp {} {
    set now [clock seconds]
    set date [clock format $now -format "%Y-%m-%d %H:%M:%S"]
    return $date
}

# Function to run after successful registration
proc run_after_successful_registration {} {
    # This function contains the command to run after successful registration.
    spawn pm2 restart miner_26
    expect "Process successfully started"
    exit 128
}

# Function for registration
proc registration {} {
    spawn btcli s register --subtensor.network finney --netuid 26 --wallet.name sn26 --wallet.hotkey sn26-hot

    # Log timestamp for registration attempt
    puts "[timestamp] Attempting registration..."

    expect "Enter password to unlock key" {
        send "XXXXXXX\r"
        expect ""
    }

    expect {
        -re ".*TooManyRegistrationsThisInterval.*|.*❌ Failed.*" {
            puts "[timestamp] Error encountered: TooManyRegistrationsThisInterval or ❌ Failed. Restarting registration..."
            registration
        }
        -re ".*NotEnoughBalanceToStake.*|.*❌ Failed.*" {
            puts "[timestamp] Error encountered: NotEnoughBalanceToStake or ❌ Failed. Restarting registration..."
            registration
        }
        -re ".*RegistrationDisabled.*|.*❌ Failed.*" {
            puts "Error encountered: RegistrationDisabled or ❌ Failed. Restarting registration..."
            registration
        }
        -re ".*Registered.*" {
            puts "[timestamp] Registration completed successfully."
            run_after_successful_registration
        }
        -timeout 180 {
            puts "[timestamp] Timeout: Unexpected situation. Restarting registration..."
            registration
        }
        eof {
            puts "[timestamp] Unexpected end of file. Restarting registration..."
            registration
        }
    }
}

# Run the registration function
registration
puts "[timestamp] Script completed."
