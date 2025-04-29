# ComfyUI Server Bootstrap 🚀

This repository provides scripts to quickly **start, stop, and manage** a ComfyUI server secured with Caddy password protection, specifically optimized for **RunPod ephemeral machines**.

---

## 📦 Environment Assumptions

- **Platform:** [RunPod.io](https://www.runpod.io/)
- **Container Image Used:** `runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04`
- **Ports Exposed:**
  - `8888` → (for Jupyter, if needed)
  - `80` → (Caddy HTTP server for proxying ComfyUI)
  - `443` → (reserved for HTTPS, but currently HTTP only)
- **Environment Variables:**
  - `PYTHONUNBUFFERED=1` → (ensures real-time output logs)

---

## 🧠 Important Notes

- You must have **your own persistent volume** mounted on `/workspace`.
- You should have **installed ComfyUI once manually** already on that volume **OR** use the provided `setup.sh`.
- **This setup is intended for fast termination and recreation** of pods — where your models and data persist but machine/container is refreshed.
- **No domain required.** Caddy runs on HTTP with password protection only.
- **No systemd available.** Processes are manually managed (`nohup` backgrounded).

---

## 📜 Provided Scripts

| Script | Purpose |
|:---|:---|
| `setup.sh` | Install ComfyUI, Caddy, create Caddyfile, install dependencies |
| `start.sh` | Start Caddy + ComfyUI detached, with readiness checks |
| `stop.sh` | Cleanly stop both Caddy and ComfyUI processes |

---

## 🚀 How to Use

1. **Clone this repo inside `/workspace`:**

```bash
git clone https://github.com/10xwithankit/comfyui-server-bootstrap.git
cd comfyui-server-bootstrap