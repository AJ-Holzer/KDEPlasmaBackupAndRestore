#!/bin/bash
# KDE Neon Config + Package Backup Script
# Creates a single archive with configs + package list.

BACKUP_DIR="$HOME/kde-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/kde-backup-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "[*] Saving package list..."
dpkg --get-selections > "$BACKUP_DIR/packages.list"

echo "[*] Archiving configs and data..."
tar -czvf "$BACKUP_FILE" \
    "$BACKUP_DIR/packages.list" \
    ~/.config \
    ~/.local/share \
    ~/.kde* \
    ~/.themes \
    ~/.icons \
    ~/.bashrc \
    ~/.zshrc \
    ~/.profile \
    /etc/apt \
    /etc/network \
    /etc/hosts

echo "[✓] Backup complete: $BACKUP_FILE"
