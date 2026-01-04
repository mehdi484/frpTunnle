# frpTunnel

A production-ready **FRP TCP tunneling solution** for routing traffic through an intermediate server
without breaking SSL/TLS.

Designed for restricted or national networks where:
- The main service is hosted outside the country
- SSL must remain intact
- Reverse proxy or TLS termination is not acceptable

Tested with **Marzneshin panel**, but works with **any HTTPS service**.

---

## ✨ Features

- Raw TCP tunneling (no SSL termination)
- Preserves original TLS handshake
- No nginx / no Cloudflare
- Works under heavy network restrictions
- systemd based (auto-start & auto-restart)
- Production ready

---

## 🧠 Architecture

Client
│ HTTPS
▼
IR Server (FRPS)
│ TCP Tunnel
▼
Foreign Server (FRPC)
│
▼
HTTPS Service (e.g. Marzneshin :8000)

yaml
Copy code

---

## 📦 Requirements

- 1× IR server (inside restricted network)
- 1× Foreign server
- Ubuntu 20.04+
- Root access
- Domain pointing to IR server IP

---

## 🌐 DNS

e.example.com → IR_SERVER_IP




---

## 🚀 Installation

### 1️⃣ IR Server (FRPS)


curl -fsSL https://raw.githubusercontent.com/mehdi484/frpTunnel/main/server-ir.sh | bash
2️⃣ Foreign Server (FRPC)
Edit IR server IP:


nano server-foreign.sh
Run:

bash
Copy code
bash server-foreign.sh
🔐 Access
Admin panel example:


https://min.example.com:8000/dashboard/
SSL remains untouched and handled on the foreign server.

🔒 Security (Recommended)
Limit admin access:

iptables -A INPUT -p tcp --dport 8000 -s YOUR_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 8000 -j DROP
Limit FRP control port:


iptables -A INPUT -p tcp --dport 7000 -s FOREIGN_SERVER_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 7000 -j DROP
➕ Optional: Enable Port 443
Add to frpc.toml:


[[proxies]]
name = "public"
type = "tcp"
localIP = "127.0.0.1"
localPort = 8000
remotePort = 443
Restart:


systemctl restart frpc
❗ Notes
FRPS must NOT listen on 443 or 8000

FRP handles raw TCP only

SSL certificates are never modified

📜 License
MIT License

❤️ Credits
FRP Project: https://github.com/fatedier/frp



---
