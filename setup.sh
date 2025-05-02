#!/bin/bash

# 🛑 Exit if any command fails
set -e

echo ""
echo "========================================"
echo "🚀 Starting ComfyUI Setup Script"
echo "========================================"
echo ""

# ⚡ Check GPU status
echo "🔍 Checking for NVIDIA GPU..."
nvidia-smi || echo "⚠️ No GPU found or driver not loaded (continuing anyway)"

# 🧰 System update & essential packages
echo ""
echo "📦 Updating system & installing base tools..."
apt-get update -y && apt-get upgrade -y
apt-get install -y git python3-venv curl unzip aria2 nano
apt-get install -y debian-keyring debian-archive-keyring apt-transport-https gnupg lsb-release
# 🧹 Remove old Caddy GPG key if exists
if [ -f "/usr/share/keyrings/caddy-stable-archive-keyring.gpg" ]; then
    echo "🧹 Removing existing Caddy GPG key..."
    rm /usr/share/keyrings/caddy-stable-archive-keyring.gpg
fi

# 🌐 Fetch fresh Caddy GPG key
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt-get update -y
apt-get install -y caddy

# 📁 Move to working directory
cd /workspace

# 📥 Clone ComfyUI if not already cloned
if [ ! -d "ComfyUI" ]; then
  echo ""
  echo "📥 Cloning ComfyUI repository..."
  git clone https://github.com/comfyanonymous/ComfyUI.git
else
  echo "✅ ComfyUI already exists. Skipping clone."
fi

# 🐍 Create virtual environment if not exists
if [ ! -d "comfyui-venv" ]; then
  echo ""
  echo "🐍 Creating Python virtual environment..."
  python3 -m venv comfyui-venv
else
  echo "✅ Python venv already exists. Skipping creation."
fi

# 🔒 Activate venv
echo ""
echo "📂 Activating Python venv..."
source comfyui-venv/bin/activate

# 📦 Ensure pip is installed and updated
echo ""
echo "⬆️  Installing pip..."
python -m ensurepip --upgrade
pip install --upgrade pip
pip install matplotlib opencv-python mediapipe scipy

# 📂 Move into ComfyUI directory
cd ComfyUI

# 📦 Install Python dependencies
echo ""
echo "📦 Installing ComfyUI dependencies..."
pip install -r requirements.txt

# 📁 Make sure custom_nodes folder exists
mkdir -p custom_nodes

# ⚙️  Install ComfyUI Manager if missing
echo ""
if [ ! -d "custom_nodes/ComfyUI-Manager" ]; then
  echo "📥 Installing ComfyUI Manager..."
  cd custom_nodes
  git clone https://github.com/Comfy-Org/ComfyUI-Manager.git
  cd ..
else
  echo "✅ ComfyUI Manager already exists. Skipping clone."
fi

echo ""
echo "✅ Setup complete! You can now run ComfyUI by going inside or or running start.sh"
echo "========================================"
echo "🚀 ComfyUI Setup Script Completed"

cd /workspace

# 🔒 Generate password hash for BasicAuth
BASIC_AUTH_PASSWORD_HASH=$(caddy hash-password --plaintext "YOURPASSWORD")

# 📜 Create or replace Caddyfile for BasicAuth protection

# Delete old Caddyfile if it exists
if [ -f "/etc/caddy/Caddyfile" ]; then
    echo "🧹 Removing existing Caddyfile..."
    rm /etc/caddy/Caddyfile
fi

# Now create a fresh new Caddyfile
echo "
:80 {

    route {
        basicauth /* {
            YOURUSERNAME ${BASIC_AUTH_PASSWORD_HASH}
        }

        reverse_proxy localhost:8188
    }
}
" > /etc/caddy/Caddyfile
echo "========================================"
echo "🔒 makesure you have updated YOURUSERNAME and YOURPASSWORD in setup.sh"
echo "🔒 BasicAuth protection has been set up with the username: YOURUSERNAME and password: YOURPASSWORD"
echo "🔒 You can change these in the setup.sh file if you want to change them"
echo "========================================"
