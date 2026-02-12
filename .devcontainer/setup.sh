#!/bin/bash

set -e

echo "============================================"
echo "🚀 SETUP AUTOMÁTICO - RAILS API TEMPLATE"
echo "============================================"
echo ""

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt-get update -qq

# Instalar PostgreSQL
echo "📦 Instalando PostgreSQL..."
sudo apt-get install -y -qq \
  postgresql \
  postgresql-contrib \
  libpq-dev

# Instalar Redis
echo "📦 Instalando Redis..."
sudo apt-get install -y -qq \
  redis-server \
  redis-tools

# Instalar dependencias adicionales
echo "📦 Instalando dependencias adicionales..."
sudo apt-get install -y -qq \
  build-essential \
  git \
  curl

# Iniciar PostgreSQL
echo "🚀 Iniciando PostgreSQL..."
sudo service postgresql start

# Configurar PostgreSQL
echo "🔧 Configurando PostgreSQL..."
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';" 2>/dev/null || true
sudo -u postgres psql -c "CREATE USER vscode WITH SUPERUSER PASSWORD 'postgres';" 2>/dev/null || true

# Iniciar Redis
echo "🚀 Iniciando Redis..."
sudo service redis-server start

# Configurar Ruby
echo "💎 Configurando Ruby..."
gem install bundler --no-document

# Configurar Git
echo "🔧 Configurando Git..."
git config --global init.defaultBranch main
git config --global pull.rebase false

# Crear archivo .env
echo "📝 Creando archivo .env..."
cat > .env << 'EOF'
DB_HOST=localhost
DB_USERNAME=postgres
DB_PASSWORD=postgres
REDIS_URL=redis://localhost:6379/0
RAILS_ENV=development
EOF

# Si existe Gemfile, instalar dependencias
if [ -f "Gemfile" ]; then
  echo "📦 Gemfile detectado, instalando gems..."
  bundle install
  
  # Si existe Rails, configurar BD
  if bundle show rails > /dev/null 2>&1; then
    echo "🗄️  Configurando base de datos Rails..."
    bin/rails db:create 2>/dev/null || echo "⚠️  No se pudo crear BD (ejecuta 'rails db:create' manualmente)"
    bin/rails db:migrate 2>/dev/null || echo "⚠️  No hay migraciones aún"
  fi
fi

# Verificación final
echo ""
echo "============================================"
echo "✅ VERIFICACIÓN DE INSTALACIÓN"
echo "============================================"
echo "Ruby: $(ruby -v)"
echo "Bundler: $(bundle -v)"
echo "PostgreSQL: $(psql --version)"
echo "Redis: $(redis-cli --version)"
echo ""

# Verificar servicios
if pg_isready -h localhost > /dev/null 2>&1; then
  echo "✅ PostgreSQL corriendo"
else
  echo "❌ PostgreSQL detenido (ejecuta: sudo service postgresql start)"
fi

if redis-cli ping > /dev/null 2>&1; then
  echo "✅ Redis corriendo ($(redis-cli ping))"
else
  echo "❌ Redis detenido (ejecuta: sudo service redis-server start)"
fi

echo ""
echo "============================================"
echo "✨ SETUP COMPLETADO"
echo "============================================"
echo ""
echo "👉 Siguiente paso:"
echo "   rails new . --api --database=postgresql --force --skip-git"
echo ""