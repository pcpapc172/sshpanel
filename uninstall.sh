#!/usr/bin/env bash

set -e

echo "Stopping service..."

systemctl stop sshpanel 2>/dev/null || true
systemctl disable sshpanel 2>/dev/null || true

echo "Removing service..."

rm -f /etc/systemd/system/sshpanel.service
systemctl daemon-reload

echo "Removing files..."

rm -rf /opt/sshpanel

echo "SSH Panel has been removed."
