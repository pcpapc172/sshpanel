#!/usr/bin/env bash

set -e

INSTALL_DIR="/opt/sshpanel"

echo "[1/5] Installing dependencies..."

if ! command -v node >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs unzip curl
else
    apt-get install -y unzip curl
fi

echo "[2/5] Downloading SSH Panel..."

mkdir -p "$INSTALL_DIR"

curl -L \
  "https://raw.githubusercontent.com/pcpapc172/sshpanel/main/sshpanel.zip" \
  -o /tmp/sshpanel.zip

echo "[3/5] Extracting files..."

unzip -o /tmp/sshpanel.zip -d "$INSTALL_DIR"

echo "[4/5] Installing Node modules..."

cd "$INSTALL_DIR"

npm install express cors

echo "[5/5] Creating systemd service..."

cat >/etc/systemd/system/sshpanel.service <<EOF
[Unit]
Description=SSH Panel
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/node $INSTALL_DIR/index.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable sshpanel
systemctl restart sshpanel

echo
echo "Installation completed."
echo "Panel: http://$(curl -4 -s ifconfig.me):3000"
echo "Panel: http://[$(curl -6 -s ifconfig.me)]:3000"
