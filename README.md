# Bittensor Auto Registration Bot

This repository provides resources for automating the registration process on different Bittensor subnets. The bot is designed to ensure a fair and competitive environment for miners and validators by handling multiple registration tasks efficiently and securely. The bot spawns up 4 processes at a difference of 10 seconds which run until the registration is completed.

## Overview

The bot automates the registration process for Bittensor subnets by managing multiple registration scripts simultaneously and providing error handling. It includes components for launching, cleaning up, and managing the registration processes, while ensuring sensitive information is protected and no unnecessary processes run after completion.

## Components of the Bot

### 1. **Launcher Script**
The `launcher.sh` script is responsible for launching the main registration script `sn-reg.sh` and its three clones. These clones run parallel registration processes, allowing multiple nodes to be registered at the same time.

#### Usage:
```
chmod +x launcher.sh
./launcher.sh
```

### 2. Cleaner Script
The cleaner.sh script hides sensitive information, such as passwords, from the logs by cloning changes from the sn-reg.sh script. This adds a layer of security, ensuring that sensitive data is not exposed in the logs.

#### Usage:
```
chmod +x cleaner.sh
./cleaner.sh
```

### 3. Kill_pid Script
The kill_pid.sh script ensures that any leftover processes (PIDs) that continue running after registration are terminated. These processes might remain active due to wrapper scripts, and kill_pid.sh cleans up the environment by terminating them.

#### Usage:
```
chmod +x kill_pid.sh
./kill_pid.sh
```

###  4. Wrapper Script
The wrapper.sh script ensures the registration process runs smoothly. If the main registration script (sn-reg.sh) is terminated unexpectedly (due to errors such as exceptions), the wrapper.sh script will restart the registration process. This guarantees that registration will continue until it completes successfully.

The wrapper is used internally by other components, such as the launcher and cleaner scripts, to manage and monitor the registration scripts.

###  5. sn-reg.sh Script
The sn-reg.sh script is the main registration script that interacts with the Bittensor subnets. It registers nodes on the network and is the core script around which the other components (launcher, cleaner, wrapper) are built. The launcher manages three clones of this script to enable parallel registrations.

### How It Works
1. Launcher starts the registration process by launching the sn-reg.sh script and its three clones.
2. Wrapper ensures that if any registration process gets killed unexpectedly, it restarts automatically.
3. Cleaner sanitizes logs by removing or masking sensitive information like passwords.
4. Kill_pid cleans up any lingering PIDs that may still be running after registration due to leftover wrapper scripts.
5. This combination of tools helps ensure that your registration process is handled smoothly, securely, and efficiently.
