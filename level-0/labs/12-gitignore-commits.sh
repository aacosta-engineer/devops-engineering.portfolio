#!/bin/bash
# labs/12-gitignore-commits.sh
# Lab interactivo: .gitignore + Conventional Commits
# Ejecutar: bash labs/12-gitignore-commits.sh

echo "==================================="
echo "  .gitignore + Conventional Commits"
echo "==================================="
echo ""

LAB_DIR="/tmp/lab-gitignore"
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# --- 1. Inicializar repo ---
echo "▶ 1. Inicializar repositorio"
git init --quiet
git config user.name "DevOps Student"
git config user.email "student@devops.local"
echo ""

# --- 2. Crear el .gitignore con el contenido de section 12 ---
echo "▶ 2. Creando .gitignore con el template de section 12..."
cat > .gitignore << 'GITIGNORE'
# ===================
# Dependencias
# ===================
node_modules/
venv/
.venv/

# ===================
# Secrets — NUNCA subir a GitHub
# ===================
.env
.env.local
*.pem
*.key
credentials.json
*.secret
secrets/
id_rsa*
id_ed25519*

# ===================
# Terraform (importante en DevOps)
# ===================
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# ===================
# OS / Editor
# ===================
.DS_Store
.vscode/
.idea/
*.swp
*~

# ===================
# Build + Logs
# ===================
dist/
build/
*.log
*.tmp
*.tar.gz
*.zip

# ===================
# Scratch de labs (NO versionar el espacio de trabajo de los labs)
# ===================
**/labs/.run/
GITIGNORE

echo "   ✓ .gitignore creado"
echo ""

# --- 3. Crear archivos que DEBEN ser ignorados ---
echo "▶ 3. Creando archivos que deberían ser ignorados..."
echo "password=12345" > .env
echo "private-key-content" > server.pem
echo "secret-data" > credentials.json
mkdir -p node_modules
echo "fake-module" > node_modules/lib.js
echo ""

# --- 4. Verificar que .gitignore funciona ---
echo "▶ 4. Verificando que .gitignore funciona (git status NO debe mostrar .env, *.pem, etc.)"
git status --short
echo ""

# Verificar explícitamente
ENV_TRACKED=$(git ls-files | grep -E "^\.env$" || true)
PEM_TRACKED=$(git ls-files | grep -E "\.pem$" || true)
NODE_TRACKED=$(git ls-files | grep -E "node_modules" || true)

if [ -z "$ENV_TRACKED" ] && [ -z "$PEM_TRACKED" ] && [ -z "$NODE_TRACKED" ]; then
    echo "   ✓ .env NO está siendo trackeado"
    echo "   ✓ *.pem NO está siendo trackeado"
    echo "   ✓ node_modules/ NO está siendo trackeado"
else
    echo "   ✗ ERROR: hay archivos que deberían estar ignorados pero están trackeados"
    exit 1
fi
echo ""

# --- 5. Crear archivos válidos ---
echo "▶ 5. Creando archivos válidos del proyecto..."
echo "# Mi Proyecto" > README.md
echo "console.log('hello')" > app.js
echo "print('hello')" > app.py
echo ""

# --- 6. Commit con formato Conventional Commits ---
echo "▶ 6. Commits con formato Conventional Commits (section 12)..."

# chore: init
git add .gitignore README.md
git commit -m "chore: init proyecto" --quiet
echo "   ✓ chore: init proyecto"

# feat: agregar funcionalidad
git add app.js
git commit -m "feat: agregar app.js" --quiet
echo "   ✓ feat: agregar app.js"

# fix: corregir bug
echo "console.log('hello v2')" > app.js
git add app.js
git commit -m "fix: corregir saludo en app.js" --quiet
echo "   ✓ fix: corregir saludo en app.js"

# docs: actualizar documentacion
echo "## Setup" >> README.md
git add README.md
git commit -m "docs: agregar seccion de setup" --quiet
echo "   ✓ docs: agregar seccion de setup"

echo ""

# --- 7. Verificar formato ---
echo "▶ 7. Verificando formato de los commits..."
git log --oneline
echo ""

# Mostrar tipos usados
echo "   Tipos de commit usados:"
git log --pretty=format:"%s" | grep -oE "^[a-z]+" | sort -u
echo ""
echo ""

# --- 8. Limpieza ---
echo "▶ 8. Limpieza"
cd /tmp
rm -rf "$LAB_DIR"
echo "   $LAB_DIR eliminado."
echo ""

echo "==================================="
echo "  Lab completado."
echo "==================================="
