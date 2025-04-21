#!/usr/bin/env bash

set -euo pipefail

# Define file paths
HOSTNAME_FILE="/etc/hostname"
MACHINE_ID_FILE="/etc/machine-id"
DBUS_MACHINE_ID="/var/lib/dbus/machine-id"

# Confirmation check
echo "WARNING: Running this script will cause irreversible changes to the system."
echo "Type 'vmprep' to continue or anything else to abort:"
read -r confirmation
if [ "$confirmation" != "vmprep" ]; then
    echo "Aborted."
    exit 1
fi

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

delete_user() {
    local user=$1
    if id "$user" &>/dev/null; then
        userdel -r "$user" || echo "Failed to delete user $user" >&2
    else
        echo "User $user does not exist"
    fi
}

# Delete all users with UID >= 1000 except "nobody"
users_to_delete=$(awk -F: '($3 >= 1000) && ($1 != "nobody") {print $1}' /etc/passwd)
if [ -z "$users_to_delete" ]; then
    echo "No users to delete"
else
    for user in $users_to_delete; do
        delete_user "$user"
    done
fi

# Clear the hostname
if [ -f "$HOSTNAME_FILE" ]; then
    truncate -s0 "$HOSTNAME_FILE"
    hostnamectl set-hostname localhost
else
    echo "$HOSTNAME_FILE not found, skipping"
fi

# Remove netplan file(s)
rm -rf /etc/netplan/* || echo "No netplan files to remove"

# Clear the machine-id
truncate -s0 "$MACHINE_ID_FILE"
rm -f "$DBUS_MACHINE_ID"
ln -s "$MACHINE_ID_FILE" "$DBUS_MACHINE_ID"

# Run cloud-init clean
cloud-init clean

# Disable the Password for root
passwd -dl root

# Clear Shell History
truncate -s0 ~/.bash_history
history -c

# Clear logs and temporary files
rm -rf /var/log/*
rm -rf /tmp/*
rm -rf /var/tmp/*

# Shutdown
shutdown -h now