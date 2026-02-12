#!/bin/bash

set -e

echo "============================================"
echo "🚀 SETUP AUTOMÁTICO - RAILS API TEMPLATE"
echo "============================================"
echo ""

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt-get update -qq

# Instalar SOLO los clientes (no los servidores)
echo "📦 Instalando clientes de PostgreSQL y Redis..."
sudo apt-get install -y -qq \
  postgresql-client \
  redis-tools \
  libpq-dev \
  build-essential \
  git \
  curl

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

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que PostgreSQL esté listo..."
for i in {1..30}; do
  if pg_isready -h localhost -U postgres > /dev/null 2>&1; then
    echo "✅ PostgreSQL está listo"
    break
  fi
  echo "   Intento $i/30..."
  sleep 2
done

echo "⏳ Esperando a que Redis esté listo..."
for i in {1..30}; do
  if redis-cli -h localhost ping > /dev/null 2>&1; then
    echo "✅ Redis está listo"
    break
  fi
  echo "   Intento $i/30..."
  sleep 2
done

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
echo "PostgreSQL Client: $(psql --version)"
echo "Redis Client: $(redis-cli --version)"
echo ""

# Verificar servicios
if pg_isready -h localhost -U postgres > /dev/null 2>&1; then
  echo "✅ PostgreSQL conectado"
  psql -h localhost -U postgres -c "SELECT version();" 2>/dev/null | head -3
else
  echo "❌ PostgreSQL no conecta"
fi

if redis-cli -h localhost ping > /dev/null 2>&1; then
  echo "✅ Redis conectado ($(redis-cli -h localhost ping))"
else
  echo "❌ Redis no conecta"
fi

echo ""
echo "============================================"
echo "✨ SETUP COMPLETADO"
echo "============================================"
echo ""
echo "👉 Siguiente paso:"
echo "   rails new . --api --database=postgresql --force --skip-git"
echo ""