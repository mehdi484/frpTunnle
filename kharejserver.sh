#!/bin/bash
set -e

IR_SERVER_IP="CHANGE_ME"

echo "Installing FRP Client (Foreign)..."

cd /opt
wget -q https://github.com/fatedier/frp/releases/download/v0.52.3/frp_0.52.3_linux_amd64.tar.gz
tar -xzf frp_0.52.3_linux_amd64.tar.gz
mv frp_0.52.3_linux_amd64 frp

cat > /opt/frp/frpc.toml <<EOF
serverAddr = "$IR_SERVER_IP"
serverPort = 7000

[[proxies]]
name = "admin"
type = "tcp"
localIP = "127.0.0.1"
localPort = 8000
remotePort = 8000
EOF

cat > /etc/systemd/system/frpc.service <<EOF
[Unit]
Description=FRP Client
After=network.target

[Service]
ExecStart=/opt/frp/frpc -c /opt/frp/frpc.toml
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable frpc
systemctl restart frpc

echo "FRP Client installed successfully."
