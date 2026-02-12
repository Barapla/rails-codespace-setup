#!/bin/bash

set -e

echo "============================================"
echo "🚀 SETUP AUTOMÁTICO - RAILS API TEMPLATE"
echo "============================================"
echo ""

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt-get update -qq

# Instalar SOLO los clientes
echo "📦 Instalando clientes PostgreSQL y Redis..."
sudo apt-get install -y -qq \
  postgresql-client \
  redis-tools \
  libpq-dev \
  build-essential \
  git \
  curl

# Configurar Ruby
echo "💎 Configurando Bundler..."
gem install bundler --no-document

# Configurar Git
echo "🔧 Configurando Git..."
git config --global init.defaultBranch main
git config --global pull.rebase false

# Crear archivo .env
echo "📝 Creando archivo .env..."
cat > /workspace/.env << 'EOF'
DB_HOST=db
DB_USERNAME=postgres
DB_PASSWORD=postgres
REDIS_URL=redis://redis:6379/0
RAILS_ENV=development
EOF

# Esperar a que PostgreSQL esté listo
echo "⏳ Esperando a que PostgreSQL esté listo..."
for i in {1..30}; do
  if pg_isready -h db -U postgres > /dev/null 2>&1; then
    echo "✅ PostgreSQL está listo"
    break
  fi
  if [ $i -eq 30 ]; then
    echo "❌ PostgreSQL no responde después de 60 segundos"
  fi
  sleep 2
done

# Esperar a que Redis esté listo
echo "⏳ Esperando a que Redis esté listo..."
for i in {1..30}; do
  if redis-cli -h redis ping > /dev/null 2>&1; then
    echo "✅ Redis está listo"
    break
  fi
  if [ $i -eq 30 ]; then
    echo "❌ Redis no responde después de 60 segundos"
  fi
  sleep 2
done

# Si existe Gemfile, instalar dependencias
if [ -f "/workspace/Gemfile" ]; then
  echo "📦 Gemfile detectado, instalando gems..."
  cd /workspace
  bundle install
  
  # Si existe Rails, configurar BD
  if bundle show rails > /dev/null 2>&1; then
    echo "🗄️ Configurando base de datos Rails..."
    bin/rails db:create 2>/dev/null || echo "⚠️ No se pudo crear BD"
    bin/rails db:migrate 2>/dev/null || echo "⚠️ No hay migraciones aún"
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
if pg_isready -h db -U postgres > /dev/null 2>&1; then
  echo "✅ PostgreSQL conectado (hostname: db)"
  psql -h db -U postgres -c "SELECT version();" 2>/dev/null | head -3 | tail -1
else
  echo "❌ PostgreSQL no conecta"
fi

if redis-cli -h redis ping > /dev/null 2>&1; then
  echo "✅ Redis conectado (hostname: redis) - $(redis-cli -h redis ping)"
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