# VM Preparation Script

This script (`vm-prep.sh`) is designed to prepare a virtual machine (VM) template for reuse with cloud-init, by performing a series of cleanup and reset tasks. It ensures that sensitive data, user accounts, and system-specific configurations are removed or reset.

## Features

The script performs the following actions:

1. **Confirmation Prompt**:
   - Displays a warning message to the user.
   - Requires the user to type `vmprep` to proceed, ensuring intentional execution.

2. **Root Privilege Check**:
   - Ensures the script is run with root privileges. If not, it exits with an error.

3. **User Account Cleanup**:
   - Deletes all user accounts with a UID greater than or equal to 1000, except for the `nobody` user.

4. **Hostname Reset**:
   - Clears the contents of `/etc/hostname`.
   - Resets the hostname to `localhost` using `hostnamectl`.

5. **Netplan Configuration Cleanup**:
   - Removes any netplan configs.

6. **Machine ID Reset**:
   - Clears the contents of `/etc/machine-id`.
   - Removes and recreates the symbolic link for `/var/lib/dbus/machine-id`.

7. **Cloud-Init Cleanup**:
   - Runs `cloud-init clean` to reset cloud-init state.

8. **Root Password Disable**:
   - Disables the root account password by running `passwd -dl root`.

9. **Shell History Cleanup**:
   - Clears the shell history for the current user.

10. **Log and Temporary File Cleanup**:
    - Deletes all files in `/var/log`, `/tmp`, and `/var/tmp`.

11. **Shutdown**:
    - Shuts down the system immediately after completing all tasks.

## Usage

1. Make the script executable:
   ```bash
   chmod +x vm-prep.sh
Here is the content you can add to the README.md file to explain what the script does:

```markdown
# VM Preparation Script

This script (`vm-prep.sh`) is designed to prepare a virtual machine (VM) for reuse or distribution by performing a series of cleanup and reset tasks. It ensures that sensitive data, user accounts, and system-specific configurations are removed or reset.

## Features

The script performs the following actions:

1. **Confirmation Prompt**:
   - Displays a warning message to the user.
   - Requires the user to type `vmprep` to proceed, ensuring intentional execution.

2. **Root Privilege Check**:
   - Ensures the script is run with root privileges. If not, it exits with an error.

3. **User Account Cleanup**:
   - Deletes all user accounts with a UID greater than or equal to 1000, except for the `nobody` user.
   - Allows additional user accounts to be deleted by passing their usernames as arguments to the script.

4. **Hostname Reset**:
   - Clears the contents of `/etc/hostname`.
   - Resets the hostname to `localhost` using `hostnamectl`.

5. **Netplan Configuration Cleanup**:
   - Removes the `/etc/netplan/50-cloud-init.yaml` file if it exists.

6. **Machine ID Reset**:
   - Clears the contents of `/etc/machine-id`.
   - Removes and recreates the symbolic link for `/var/lib/dbus/machine-id`.

7. **Cloud-Init Cleanup**:
   - Runs `cloud-init clean` to reset cloud-init state.

8. **Root Password Disable**:
   - Disables the root account password by running `passwd -dl root`.

9. **Shell History Cleanup**:
   - Clears the shell history for the current user.

10. **Log and Temporary File Cleanup**:
    - Deletes all files in `/var/log`, `/tmp`, and `/var/tmp`.

11. **Shutdown**:
    - Shuts down the system immediately after completing all tasks.

## Usage

1. Make the script executable:
   ```bash
   chmod +x vm-prep.sh
   ```

2. Run the script as root:
   ```bash
   sudo ./vm-prep.sh
   ```

3. Follow the on-screen instructions to confirm execution.

## Warnings

- **Irreversible Changes**: This script makes irreversible changes to the system. Use it with caution.
- **Root Privileges Required**: The script must be run as root.
- **Shutdown**: The system will shut down automatically after the script completes.

## Customization

- To exclude specific users from deletion, modify the `awk` command in the `users_to_delete` section.
- To add additional cleanup tasks, append them to the script before the shutdown command.

## Logs

- The script does not currently log its actions. If logging is required, you can redirect output to a log file by modifying the script.

## Disclaimer

Use this script at your own risk. Ensure you understand its functionality before running it on a production system.