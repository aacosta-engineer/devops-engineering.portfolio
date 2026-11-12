#!/bin/bash
# Este script prepara y ejecuta el lab de backup

LAB_DIR="/workspaces/devops-engineering-student/level-0/labs/.run/lab-bash"
mkdir -p "$LAB_DIR"/{source,backup,logs}

# Crear cinco archivos de prueba
for i in {1..5}; do
    echo "Contenido del archivo $i - $(date)" > "$LAB_DIR/source/file_$i.txt"
done

# Escribir el script que realizará el backup
cat > "$LAB_DIR/backup.sh" <<'SCRIPT'
#!/bin/bash
# Script que realiza el backup

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Debes indicar origen y destino"
    exit 1
fi

ORIGEN=$1
DESTINO=$2
RETENER=${3:-7}

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${DESTINO}/backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_FILE" "$ORIGEN"

if [ -f "$BACKUP_FILE" ]; then
    TAMANO=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "[$(date)] Backup creado: ${BACKUP_FILE} (${TAMANO})"
else
    echo "[$(date)] ERROR: No se pudo crear el backup"
    exit 1
fi

find "$DESTINO" -name "backup_*.tar.gz" -type f -mtime +${RETENER} -delete

TOTAL=$(find "$DESTINO" -name "backup_*.tar.gz" -type f | wc -l)
echo "[$(date)] Backups retenidos: ${TOTAL}"
SCRIPT

chmod +x "$LAB_DIR/backup.sh"
bash "$LAB_DIR/backup.sh" "$LAB_DIR/source" "$LAB_DIR/backup" 30

# Verificar el backup generado
echo "Archivos en $LAB_DIR/backup/:"
ls -lh "$LAB_DIR/backup/"
echo ""

# Demostraciones de Bash
echo "a) Variable:"
NOMBRE="Mundo"
echo "Hola, ${NOMBRE}!"
echo ""

echo "b) Bucle for:"
for i in 1 2 3; do
    echo "Iteración $i"
done
echo ""

echo "c) Condicional if:"
if [ -f "$LAB_DIR/backup.sh" ]; then
    echo "El archivo backup.sh existe"
else
    echo "El archivo backup.sh no existe"
fi
echo ""

echo "d) Función:"
saludar() {
    echo "Hola, $1! (Función Bash)"
}
saludar "Ingeniero DevOps"

rm -rf "$LAB_DIR"
echo "Limpieza terminada: $LAB_DIR eliminado."
