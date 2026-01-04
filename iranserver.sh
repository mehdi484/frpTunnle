
---

# 🖥️ server-ir.sh (سرور ایران)

```bash
#!/bin/bash
set -e

echo "Installing FRP Server (IR)..."

cd /opt
wget -q https://github.com/fatedier/frp/releases/download/v0.52.3/frp_0.52.3_linux_amd64.tar.gz
tar -xzf frp_0.52.3_linux_amd64.tar.gz
mv frp_0.52.3_linux_amd64 frp

cat > /opt/frp/frps.ini <<EOF
[common]
bind_addr = 0.0.0.0
bind_port = 7000
EOF

cat > /etc/systemd/system/frps.service <<EOF
[Unit]
Description=FRP Server
After=network.target

[Service]
ExecStart=/opt/frp/frps -c /opt/frp/frps.ini
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable frps
systemctl restart frps

echo "FRP Server installed successfully."
