#!/bin/bash
# Wibutunnel Quick Installer v4.0.3
# Usage:
#   curl -sL https://raw.githubusercontent.com/WBVPN/wibutunnel/main/install.sh | sudo bash
#
# Syarat: IP VPS terdaftar di /root/wibutunnel-izin/izin.txt
# Clone repo izin dulu: git clone https://github.com/WBVPN/wibutunnel-izin.git /root/wibutunnel-izin

echo "============================================"
echo "   Wibutunnel VPN Management System"
echo "   Quick Installer v4.0.3 Kurumi"
echo "============================================"
echo ""

# Check root
if [[ $EUID -ne 0 ]]; then
   echo "Error: Script harus dijalankan sebagai root"
   echo "Gunakan: sudo bash install.sh"
   exit 1
fi

# Check OS (konsisten dengan setup.sh: Ubuntu atau Debian)
source /etc/os-release 2>/dev/null || true
if [[ "${ID:-}" != "ubuntu" && "${ID:-}" != "debian" ]]; then
    echo "Error: Hanya mendukung Ubuntu / Debian (terdeteksi: ${ID:-unknown})"
    exit 1
fi

# Clone / update repo Wibu (license check)
echo "[1/3] Cek repo lisensi..."
if [[ ! -d /root/Wibu/.git ]]; then
    echo "Clone repo lisensi..."
    git clone https://github.com/Nizwarax/Wibu.git /root/Wibu || {
        echo "Error: Gagal clone repo Wibu. Cek koneksi/akses GitHub."
        exit 1
    }
else
    echo "Update repo lisensi..."
    cd /root/Wibu && git pull --ff-only 2>/dev/null || true
fi

# Cek file izin.txt di dalam subfolder izin
if [[ ! -f /root/Wibu/izin/izin.txt ]]; then
    echo "Error: /root/Wibu/izin/izin.txt tidak ditemukan setelah clone."
    exit 1
fi

# Clone / update repo utama
INSTALL_DIR="/root/wibutunnel"
echo "[2/3] ${INSTALL_DIR} - dapatkan source terbaru..."
cd /root || exit 1
if [[ -d "wibutunnel/.git" ]]; then
    cd wibutunnel && git pull --ff-only || { echo "Error: git pull gagal. Cek koneksi/repo state."; exit 1; }
else
    rm -rf wibutunnel
    git clone https://github.com/WBVPN/wibutunnel.git
    cd wibutunnel || exit 1
fi

# Run installer utama
echo "[3/3] Menjalankan installer utama..."
echo ""
chmod +x setup.sh
./setup.sh
