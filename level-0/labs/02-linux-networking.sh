#!/bin/bash
# labs/02-linux-networking.sh
# Lab interactivo: networking, SSH, systemd
# Ejecutar: bash labs/02-linux-networking.sh

echo "==================================="
echo "  Linux II — Laboratorio guiado"
echo "==================================="
echo ""

# --- 1. Información de red ---
echo "▶ 1. Informacion de red"
echo ""

echo "   Interfaces de red:"
ip addr show | grep -E "^[0-9]|inet " | head -20
echo ""

echo "   Tabla de rutas:"
ip route show
echo ""

echo "   Puertos en escucha:"
ss -tlnp 2>/dev/null | head -10
echo ""

echo "   Resolucion DNS (/etc/resolv.conf):"
cat /etc/resolv.conf 2>/dev/null || echo "   (no existe /etc/resolv.conf)"
echo ""

# --- 2. DNS lookup ---
echo "▶ 2. Resolucion de nombres"
echo ""

if command -v host &>/dev/null; then
    echo "   google.com -> $(host google.com | head -1)"
elif command -v nslookup &>/dev/null; then
    echo "   google.com -> $(nslookup google.com 2>/dev/null | grep Address | tail -1)"
else
    echo "   getent hosts google.com -> $(getent hosts google.com | head -1)"
fi
echo ""

# --- 3. Conectividad ---
echo "▶ 3. Conectividad"
echo ""

if command -v ping &>/dev/null; then
    echo "   Haciendo ping a google.com (1 paquete)..."
    ping -c 1 google.com 2>&1 | head -3
else
    echo "   ping no disponible. Probando con curl..."
    curl -sI https://google.com 2>&1 | head -3
fi
echo ""

# --- 4. SSH key demo ---
echo "▶ 4. SSH keygen (simulado)"
echo ""

SSH_DIR="$HOME/devops-engineering-student/level-0/labs/.run/lab-ssh-test"
mkdir -p "$SSH_DIR"
if [ ! -f "$SSH_DIR/id_ed25519" ]; then
    echo "   Generando par de llaves SSH (ed25519)..."
    ssh-keygen -t ed25519 -f "$SSH_DIR/id_ed25519" -N "" -q
    echo "   Llave privada: $SSH_DIR/id_ed25519"
    echo "   Llave publica: $SSH_DIR/id_ed25519.pub"
    echo "   Contenido de la llave publica:"
    cat "$SSH_DIR/id_ed25519.pub"
else
    echo "   Las llaves ya existen en $SSH_DIR"
fi
echo ""
rm -rf "$SSH_DIR"
echo "   Directorio temporal $SSH_DIR eliminado."
echo ""

# --- 5. systemd (demo informativo) ---
echo "▶ 5. systemd (demo informativa)"
echo ""

if command -v systemctl &>/dev/null; then
    echo "   Servicios activos:"
    systemctl list-units --type=service --state=running --no-pager 2>/dev/null | head -8
    echo ""
    echo "   Estado de SSH:"
    systemctl status ssh 2>/dev/null | head -5 || \
        systemctl status sshd 2>/dev/null | head -5 || \
        echo "   ssh.service no encontrado"
else
    echo "   systemd no disponible (normal en contenedor Docker)"
fi
echo ""

echo "==================================="
echo "  Lab completado."
echo "==================================="
