#!/bin/bash
# labs/01-linux-basics.sh
# Lab interactivo: filesystem, procesos, permisos
# Ejecutar: bash labs/01-linux-basics.sh

echo "==================================="
echo "  Linux I — Laboratorio guiado"
echo "==================================="
echo ""

# --- 1. Filesystem ---
echo "▶ 1. Filesystem"
echo "   Directorio actual: $(pwd)"
echo ""

echo "   Creando estructura de prueba..."
mkdir -p $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/{docs,logs,backup,scripts}
touch $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/docs/{README.md,notas.txt,manual.pdf}
touch $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/logs/{app.log,error.log,access.log}
echo "   Contenido de $HOME/devops-engineering-student/level-0/labs/.run/lab-linux:"
ls -la $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/
echo ""

echo "   Árbol completo:"
find $HOME/devops-engineering-student/level-0/labs/.run/lab-linux -type f | sort
echo ""

echo "   Head/tail de un archivo:"
head -3 $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/logs/app.log 2>/dev/null || echo "   (archivos vacios — creados para practicar)"
echo ""

# --- 2. Procesos ---
echo "▶ 2. Procesos"
echo "   Tu PID actual (shell): $$"
echo "   Procesos de este usuario:"
ps aux --forest | head -10
echo ""

echo "   Top 5 procesos por CPU:"
ps aux --sort=-%cpu | head -6
echo ""

echo "   Procesos en background (demo):"
sleep 30 &
BG_PID=$!
echo "   PID del sleep: $BG_PID"
kill $BG_PID 2>/dev/null
echo "   sleep terminado."
echo ""

# --- 3. Permisos ---
echo "▶ 3. Permisos"
echo "   Permisos de los archivos de prueba:"
ls -l $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/docs/README.md
echo ""

echo "   Modo actual (umask): $(umask)"
chmod 644 $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/docs/README.md
echo "   Cambiado a 644 (rw-r--r--):"
ls -l $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/docs/README.md
echo ""

echo "   Creando archivo sin permisos de lectura..."
touch $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/secreto.txt
chmod 000 $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/secreto.txt
ls -l $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/secreto.txt
echo "   Intentando leerlo (debe fallar):"
cat $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/secreto.txt 2>&1 || echo "   -> Error esperado: Permission denied"
chmod 644 $HOME/devops-engineering-student/level-0/labs/.run/lab-linux/secreto.txt
echo ""

# --- 4. Pipes y redirección ---
echo "▶ 4. Pipes y redireccion"
echo "   Contar archivos en $HOME/devops-engineering-student/level-0/labs/.run/lab-linux:"
find $HOME/devops-engineering-student/level-0/labs/.run/lab-linux -type f | wc -l
echo ""

echo "   Guardando lista de archivos en $HOME/devops-engineering-student/level-0/labs/.run/lab-linux.lista.txt..."
find $HOME/devops-engineering-student/level-0/labs/.run/lab-linux -type f > $HOME/devops-engineering-student/level-0/labs/.run/lab-linux.lista.txt
echo "   Archivos guardados:"
cat $HOME/devops-engineering-student/level-0/labs/.run/lab-linux.lista.txt
echo ""

echo "   Buscando archivos .log:"
find $HOME/devops-engineering-student/level-0/labs/.run/lab-linux -name "*.log" | sort
echo ""

# --- 5. Limpieza ---
echo "▶ 5. Limpieza"
rm -rf $HOME/devops-engineering-student/level-0/labs/.run/lab-linux $HOME/devops-engineering-student/level-0/labs/.run/lab-linux.lista.txt
echo "   $HOME/devops-engineering-student/level-0/labs/.run/lab-linux eliminado."
echo ""

echo "==================================="
echo "  Lab completado."
echo "==================================="
