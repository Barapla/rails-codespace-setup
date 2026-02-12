#!/bin/bash

set -e

echo "🚀 Iniciando setup de Rails API Template..."

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt-get update -qq

# Instalar dependencias del sistema
echo "📦 Instalando dependencias..."
sudo apt-get install -y -qq \
  postgresql-client \
  redis-tools \
  libpq-dev \
  build-essential \
  git

# Configurar Ruby
echo "💎 Configurando Ruby..."
gem install bundler -v 2.5.5 --no-document

# Configurar Git
echo "🔧 Configurando Git..."
git config --global init.defaultBranch main
git config --global pull.rebase false

# Verificar versiones
echo ""
echo "✅ Verificando instalaciones:"
echo "Ruby: $(ruby -v)"
echo "Bundler: $(bundle -v)"
echo "PostgreSQL Client: $(psql --version)"
echo "Redis: $(redis-cli --version)"
echo ""

# Si existe Gemfile, instalar dependencias
if [ -f "Gemfile" ]; then
  echo "📦 Gemfile detectado, instalando gems..."
  bundle install
  
  # Crear base de datos si existe Rails
  if bundle show rails > /dev/null 2>&1; then
    echo "🗄️  Configurando base de datos..."
    bin/rails db:create || echo "⚠️  No se pudo crear la BD (es normal en setup inicial)"
    bin/rails db:migrate || echo "⚠️  No hay migraciones aún"
  fi
else
  echo "⚠️  No se encontró Gemfile. Ejecuta 'rails new' para crear tu proyecto."
fi

echo ""
echo "✨ Setup completado!"
echo "👉 Siguiente paso: rails new . --api --database=postgresql"