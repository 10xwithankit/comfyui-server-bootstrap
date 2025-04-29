#!/bin/bash

# 🛑 Exit if any command fails
set -e

echo ""
echo "========================================"
echo "🚀 Starting Caddy + ComfyUI Server"
echo "========================================"
echo ""

# 🧪 Validate Caddy config
echo "🧪 Validating Caddy configuration..."
if caddy validate --config /etc/caddy/Caddyfile; then
    echo "✅ Caddy config is valid. Launching Caddy manually..."
else
    echo "❌ Caddy config invalid! Please fix /etc/caddy/Caddyfile manually."
    exit 1
fi

# 🌐 Start Caddy manually
echo ""
echo "🚀 Starting Caddy server in background..."
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile > /workspace/caddy.log 2>&1 &

# 📂 Move to workspace
cd /workspace

# 🔒 Activate Python virtual environment
source comfyui-venv/bin/activate

# 📂 Move into ComfyUI directory
cd ComfyUI

# 🚀 Launch ComfyUI server detached
echo ""
echo "🚀 Launching ComfyUI on port 8188 (detached)..."
# 🚀 Launch ComfyUI server detached
echo ""
echo "🚀 Launching ComfyUI on port 8188 (detached)..."
nohup python main.py --listen --port 8188 > /workspace/comfyui.log 2>&1 &

# ⏳ Wait for ComfyUI to finish loading
echo "⏳ Waiting 30 seconds for ComfyUI to fully boot..."
sleep 20

# 🛠 Final Instructions
echo ""
echo "========================================"
echo "🎯 Final Steps:"
echo ""
echo "🖥️  Access your server:  http://<your-server-ip-or-cloudflare-proxy>"
echo ""
echo "🔑 You will need the BasicAuth username and password you set during setup."
echo ""
echo "📜 To see live ComfyUI logs:"
echo "   tail -f /workspace/comfyui.log"
echo ""
echo "📜 To see live Caddy logs:"
echo "   tail -f /workspace/caddy.log"
echo ""
echo "✅ Both Caddy and ComfyUI are now running detached in background!"
echo "Note: Sometimes Caddy takes time to load, so please wait for 1-2 minutes and then try to access the server."
echo "========================================"