#!/bin/bash

set -e

echo "============================================"
echo "🚀 SETUP AUTOMÁTICO - RAILS API TEMPLATE"
echo "============================================"
echo ""

# Remover repositorio problemático de Yarn
echo "🔧 Limpiando repositorios problemáticos..."
sudo rm -f /etc/apt/sources.list.d/yarn.list 2>/dev/null || true

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt-get update -qq

# Instalar clientes y dependencias
echo "📦 Instalando clientes PostgreSQL y Redis..."
sudo apt-get install -y -qq \
  postgresql-client \
  redis-tools \
  libpq-dev \
  build-essential \
  git \
  curl

# Configurar Ruby y Rails
echo "💎 Instalando Bundler y Rails..."
gem install bundler --no-document
gem install rails --no-document

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
    bundle exec rails db:create 2>/dev/null || echo "⚠️ No se pudo crear BD"
    bundle exec rails db:migrate 2>/dev/null || echo "⚠️ No hay migraciones aún"
  fi
fi

# Verificación final
echo ""
echo "============================================"
echo "✅ VERIFICACIÓN DE INSTALACIÓN"
echo "============================================"
echo "Ruby: $(ruby -v)"
echo "Bundler: $(bundle -v)"
echo "Rails: $(rails -v)"
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
if [ ! -f "/workspace/Gemfile" ] || [ ! -f "/workspace/config/application.rb" ]; then
  echo "👉 Para crear un nuevo proyecto Rails API:"
  echo "   rails new . --api --database=postgresql --force --skip-git"
  echo "   bundle install"
  echo "   rails db:create"
else
  echo "✅ Proyecto Rails ya inicializado"
  echo "👉 Comandos útiles:"
  echo "   rails db:migrate    # Correr migraciones"
  echo "   rails console       # Consola interactiva"
  echo "   rails server        # Iniciar servidor"
fi
echo ""