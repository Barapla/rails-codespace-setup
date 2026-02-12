# Rails API Codespace Template

Template base para proyectos Rails API con PostgreSQL y Redis configurado para GitHub Codespaces.

## 🚀 Quick Start

### Opción 1: Usar como Template
1. Click en "Use this template" en GitHub
2. Crea tu nuevo repo
3. Abre un Codespace
4. Espera el setup automático
5. Ejecuta:

```bash
rails new . --api --database=postgresql --force --skip-git
bundle install
rails db:create db:migrate
rails server
```

### Opción 2: Clonar y Adaptar

```bash
git clone https://github.com/TU-USUARIO/rails-api-codespace-template.git mi-proyecto
cd mi-proyecto
rm -rf .git
git init
# Crear tu proyecto Rails...
```

## 📦 Incluye

- **Ruby 3.2** 
- **PostgreSQL 15** (usuario: `postgres`, password: `postgres`)
- **Redis 7**
- **VS Code Extensions**:
  - Ruby/RuboCop
  - Solargraph
  - GitHub Copilot
  - GitLens

## 🔧 Configuración

### Variables de Entorno Pre-configuradas

```bash
DB_HOST=localhost
DB_USERNAME=postgres
DB_PASSWORD=postgres
REDIS_URL=redis://localhost:6379/0
```

### Puertos Expuestos
- `3000` - Rails API
- `5432` - PostgreSQL
- `6379` - Redis

## 🗄️ Configuración de Database

El template usa esta configuración en `config/database.yml`:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch("DB_HOST", "localhost") %>
  username: <%= ENV.fetch("DB_USERNAME", "postgres") %>
  password: <%= ENV.fetch("DB_PASSWORD", "postgres") %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS", 5) %>

development:
  <<: *default
  database: mi_proyecto_development

test:
  <<: *default
  database: mi_proyecto_test
```

## 📝 Siguientes Pasos

1. Crear tu proyecto Rails
2. Configurar RuboCop Standard
3. Configurar RSpec
4. Crear tus modelos/migraciones
5. ¡Desarrollar! 🎉

## 🛠️ Comandos Útiles
```bash
# Verificar servicios
psql -h localhost -U postgres -c "SELECT version();"
redis-cli ping

# Rails
rails db:create
rails db:migrate
rails console
rails server

# Testing
bundle exec rspec
bundle exec rubocop
```

## 📚 Documentación

- [GitHub Codespaces](https://docs.github.com/en/codespaces)
- [Rails Guides](https://guides.rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/docs/)

---

**Creado por**: Brainmachine  
**Última actualización**: Febrero 2026