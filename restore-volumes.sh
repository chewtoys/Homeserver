#!/usr/bin/env bash

source backup-config.sh
source utils.sh

mkdir ${backupFolder} > /dev/null 2>&1
chmod 755 ${backupFolder}
if [[ "$(ls -A ${backupFolder})" != "" ]]; then
    echo "Folder not empty... Stopping"
    notify "Restore failed" "Backup folder is not empty"
    exit 1
fi

# 2. Check that the encrypted folder exists. If not, log error, stop and exit
if [[ ! -d "${encryptedFolder}" ]]; then
    echo "Encrypted folder doesn't exist... Stopping"
    notify "Restore failed" "Encrypted folder doesn't exist"
    exit 1
else
    for f in $(ls "${encryptedFolder}"); do
        array_contains "${f}" "${gocryptfsconfigs[@]}"
        if [[ "$?" -eq 1 ]]; then
            echo "Missing init files. Encrypted folder is not initialized... Stopping"
            notify "Restore failed" "No init files found. Encrypted folder is not initialized"
            exit 1
        fi
    done
fi

# 4. If the folder exists, link it to the backup folder
gocryptfs -extpass "echo ${ENCRYPTED_FOLDER_PSW}" ${encryptedFolder} ${backupFolder}
gocrypt_return=$?
if [[ ${gocrypt_return} != "0" ]]; then
  echo "Gocrypt process failed - Error ${gocrypt_return}"
  notify "Restore failed" "Gocrypt process failed - Error ${gocrypt_return}"
  exit 1
fi

is_mounted=$(cat /proc/mounts | grep -q "${encryptedFolder}" ; echo "$?")
if [[ ${is_mounted} != "0" ]]; then
  echo "Mounting failed"
  notify "Backup failed" "Failed mounting encrypted folder"
  exit 1
fi

# Login to mega
# List files
# Download selected backup
# Unencrypt backup
# Unzip backup
# Stop containers
# Restore volumes
# Start containers
# Teardown procedure


