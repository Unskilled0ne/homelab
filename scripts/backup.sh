#!/usr/bin/env bash
set -euo pipefail

RESTIC_REPO="/mnt/data/backups"
RESTIC_PASSWORD_FILE="/home/unskilledone/.config/restic/password"

if [ ! -f "$RESTIC_PASSWORD_FILE" ]; then
    echo "[-] Error: Password file $RESTIC_PASSWORD_FILE not found" >&2
    exit 1
fi

echo "[+] Starting homelab and project backup at $(date)..."

/usr/bin/restic -r "$RESTIC_REPO" \
    --password-file "$RESTIC_PASSWORD_FILE" \
    backup \
    /home/unskilledone/homelab \
    /home/unskilledone/Desktop/Herman \
    /home/unskilledone/.ssh \
    /home/unskilledone/.gitconfig \
    --exclude-caches \
    --exclude='**/venv/**' \
    --exclude='**/.venv/**' \
    --exclude='**/__pycache__/**' \
    --exclude='**/*.pyc' \
    --exclude='**/node_modules/**' \
    --exclude='**/.git/objects/**' \
    --tag "automated-daily"

echo "[+] Pruning snapshots older than 30 days..."
/usr/bin/restic -r "$RESTIC_REPO" \
    --password-file "$RESTIC_PASSWORD_FILE" \
    forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune || true

echo "[+] Backup successfully completed at $(date)"
