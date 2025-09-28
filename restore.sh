#!/bin/bash
# KDE Neon Config + Package Restore Script
# Restores configs and packages from a backup archive.

if [ $# -ne 1 ]; then
    echo "Usage: $0 <backup-file.tar.gz>"
    exit 1
fi

BACKUP_FILE="$1"
RESTORE_DIR="$HOME/kde-restore-temp"

echo "[*] Extracting backup archive..."
mkdir -p "$RESTORE_DIR"
tar -xzvf "$BACKUP_FILE" -C "$RESTORE_DIR"

# Restore configs & dotfiles
echo "[*] Restoring user configs..."
cp -r "$RESTORE_DIR/home/$USER/.config" ~/
cp -r "$RESTORE_DIR/home/$USER/.local/share" ~/
[ -d "$RESTORE_DIR/home/$USER/.kde" ] && cp -r "$RESTORE_DIR/home/$USER/.kde" ~/
[ -d "$RESTORE_DIR/home/$USER/.themes" ] && cp -r "$RESTORE_DIR/home/$USER/.themes" ~/
[ -d "$RESTORE_DIR/home/$USER/.icons" ] && cp -r "$RESTORE_DIR/home/$USER/.icons" ~/

# Restore shell configs
for f in .bashrc .zshrc .profile; do
    [ -f "$RESTORE_DIR/home/$USER/$f" ] && cp "$RESTORE_DIR/home/$USER/$f" ~/
done

# Restore system configs
echo "[*] Restoring system configs (requires sudo)..."
sudo cp -r "$RESTORE_DIR/etc/apt" /etc/
sudo cp -r "$RESTORE_DIR/etc/network" /etc/
sudo cp "$RESTORE_DIR/etc/hosts" /etc/

# Restore packages
if [ -f "$RESTORE_DIR/home/$USER/kde-backup/packages.list" ]; then
    echo "[*] Restoring package list..."
    sudo dpkg --set-selections < "$RESTORE_DIR/home/$USER/kde-backup/packages.list"
    sudo apt-get -y dselect-upgrade
else
    echo "[!] No package list found in backup."
fi

echo "[*] Cleaning up..."
rm -rf "$RESTORE_DIR"

echo "[✓] Restore complete. Please log out and log back in (or reboot) for all settings to take effect."
