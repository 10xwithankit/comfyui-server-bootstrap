#!/bin/bash

# 🛑 Exit if any command fails
set -e

echo ""
echo "========================================"
echo "🛑 Stopping Caddy + ComfyUI Server"
echo "========================================"
echo ""

# 🔍 Find and kill Caddy
CADDY_PID=$(pgrep -f "caddy run")
if [ -n "$CADDY_PID" ]; then
  echo "🛑 Stopping Caddy (PID: $CADDY_PID)..."
  kill "$CADDY_PID"
else
  echo "✅ Caddy is not running."
fi

# 🔍 Find and kill ComfyUI
COMFYUI_PID=$(pgrep -f "python main.py")
if [ -n "$COMFYUI_PID" ]; then
  echo "🛑 Stopping ComfyUI (PID: $COMFYUI_PID)..."
  kill "$COMFYUI_PID"
else
  echo "✅ ComfyUI is not running."
fi

echo ""
echo "✅ Both Caddy and ComfyUI have been stopped."
echo "========================================"