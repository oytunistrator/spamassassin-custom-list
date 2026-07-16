#!/usr/bin/env bash
# install.sh - install this ruleset into /etc/spamassassin
#
# Usage:
#   cd /etc/spamassassin
#   git clone https://github.com/oytunistrator/spamassassin-custom-list oytunistrator-custom-list
#   bash oytunistrator-custom-list/install.sh
#
# The script copies all .cf files, lists/ and tests/ into /etc/spamassassin
# so SpamAssassin can load them directly.

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="/etc/spamassassin"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR does not exist."
    exit 1
fi

if [ ! -w "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR is not writable. Run as root."
    exit 1
fi

# Backup existing configuration once
BACKUP_DIR="$TARGET_DIR.backup.$(date +%s)"
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating backup at $BACKUP_DIR"
    cp -a "$TARGET_DIR" "$BACKUP_DIR"
fi

echo "Installing ruleset from $REPO_DIR to $TARGET_DIR"

cp -a "$REPO_DIR"/*.cf "$TARGET_DIR/"

if [ -d "$REPO_DIR/lists" ]; then
    if [ -d "$TARGET_DIR/lists" ]; then
        rm -rf "$TARGET_DIR/lists"
    fi
    cp -a "$REPO_DIR/lists" "$TARGET_DIR/"
fi

if [ -d "$REPO_DIR/tests" ]; then
    if [ -d "$TARGET_DIR/tests" ]; then
        rm -rf "$TARGET_DIR/tests"
    fi
    cp -a "$REPO_DIR/tests" "$TARGET_DIR/"
fi

echo "Installation complete."
echo "Run: spamassassin --lint"
echo "Then restart spamassassin/postfix as needed."
