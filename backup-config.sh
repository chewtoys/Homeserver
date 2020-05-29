#!/usr/bin/env bash

ENCRYPTED_FOLDER_PSW="your_pass_goes_here"

MEGA_MAIL="MEGA email address"
MEGA_PSW="MEGA password"

GOTIFY_API_KEY="your_gotify_key_goes_here"
GOTIFY_URL="your_gotify_server_goes_here"

#Files and Folders here
backupFolder="/home/pi/backup"
encryptedFolder="/home/pi/encryptedVolumesOnMega"
gocryptfsconfigs=("gocryptfs.conf" "gocryptfs.diriv") 
