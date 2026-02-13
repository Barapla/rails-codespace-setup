# Rails API Codespace Template

Template listo para producción de Rails API con PostgreSQL y Redis configurado para GitHub Codespaces.

## 🚀 Quick Start

### 1. Usar Este Template

1. Click en **"Use this template"** en GitHub
2. Crea tu nuevo repositorio
3. Abre un **Codespace** (botón verde "Code" → "Codespaces" → "Create codespace")
4. Espera ~2-3 minutos mientras se instala todo automáticamente
5. Verás el mensaje de setup completado ✨

### 2. Crear Tu Proyecto Rails

Una vez que el Codespace esté listo:
```bash
# Opción A: Crear proyecto nuevo desde cero
rails new . --api --database=postgresql --force --skip-git
bundle install
rails db:create

# Opción B: Si ya tienes un proyecto, solo:
bundle install
rails db:create db:migrate
```

### 3. Iniciar el Servidor
```bash
rails server
```

Tu API estará disponible en el puerto 3000 (GitHub Codespaces lo detecta automáticamente).

---

## 📦 ¿Qué Incluye?

### Stack Completo Pre-instalado
- ✅ **Ruby 3.2.8**
- ✅ **Rails** (última versión estable)
- ✅ **PostgreSQL 15** (en contenedor separado)
- ✅ **Redis 7** (en contenedor separado)
- ✅ **Bundler**
- ✅ **PostgreSQL Client & Redis CLI**

### VS Code Extensions
- Ruby & RuboCop
- Solargraph (IntelliSense)
- GitHub Copilot
- GitLens

### Configuración Automática
- Variables de entorno pre-configuradas (`.env`)
- Base de datos lista para conectar
- Redis cache configurado
- Git configurado

---

## 🗄️ Configuración de Base de Datos

El template usa estas variables de entorno (ya configuradas en `.env`):
```bash
DB_HOST=db
DB_USERNAME=postgres
DB_PASSWORD=postgres
REDIS_URL=redis://redis:6379/0
```

Tu `config/database.yml` debería verse así:
```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch("DB_HOST") { "db" } %>
  username: <%= ENV.fetch("DB_USERNAME") { "postgres" } %>
  password: <%= ENV.fetch("DB_PASSWORD") { "postgres" } %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: mi_proyecto_development

test:
  <<: *default
  database: mi_proyecto_test
```

---

## 🛠️ Comandos Útiles
```bash
# Verificar que todo esté instalado
ruby -v
rails -v
psql --version
redis-cli --version

# Verificar conexiones
pg_isready -h db -U postgres
redis-cli -h redis ping

# Rails
rails db:create          # Crear base de datos
rails db:migrate         # Correr migraciones
rails db:seed            # Poblar con datos
rails console            # Consola interactiva
rails server             # Iniciar servidor
rails routes             # Ver todas las rutas

# Testing (cuando lo configures)
bundle exec rspec
bundle exec rubocop
```

---

## 🔧 Estructura del Template
```
rails-api-codespace-template/
├── .devcontainer/
│   ├── devcontainer.json    # Configuración del Codespace
│   ├── docker-compose.yml   # PostgreSQL y Redis
│   └── setup.sh             # Script de instalación automática
├── .env                     # Variables de entorno (auto-generado)
├── .gitignore
└── README.md
```

---

## 📚 Próximos Pasos Recomendados

Después de crear tu proyecto Rails:

1. **Configurar RuboCop**
```bash
   bundle add rubocop rubocop-rails rubocop-rspec --group development
```

2. **Configurar RSpec**
```bash
   bundle add rspec-rails --group development,test
   rails generate rspec:install
```

3. **Agregar gemas comunes**
```ruby
   # Gemfile
   gem 'rack-cors'           # CORS para frontend
   gem 'bcrypt'              # Autenticación
   gem 'jwt'                 # Tokens JWT
   gem 'redis'               # Cliente Redis
   gem 'sidekiq'             # Background jobs
```

---

## 🚨 Troubleshooting

### PostgreSQL no conecta
```bash
pg_isready -h db -U postgres
# Si falla, verifica que el contenedor esté corriendo
```

### Redis no conecta
```bash
redis-cli -h redis ping
# Debe responder: PONG
```

### El setup no se ejecutó automáticamente
```bash
# Ejecutar manualmente
bash .devcontainer/setup.sh
```

---

## 💡 Tips

- **Costos**: GitHub te da 120 horas gratis/mes de Codespaces (máquina de 2 cores)
- **Pausa automática**: El Codespace se pausa después de 30 minutos de inactividad
- **Persistencia**: Los datos de PostgreSQL y Redis persisten entre sesiones
- **Secrets**: Para variables sensibles, usa GitHub Codespaces Secrets

---

## 📖 Documentación

- [GitHub Codespaces](https://docs.github.com/en/codespaces)
- [Rails Guides](https://guides.rubyonrails.org/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Redis Docs](https://redis.io/docs/)

---

**Creado por**: Brainmachine  
**Última actualización**: Febrero 2026  
**Versión**: 1.0.0

---

## 🎯 Para Usar en Nuevos Proyectos

1. Clona este template
2. Abre Codespace
3. Espera el setup automático (2-3 min)
4. `rails new . --api --database=postgresql --force --skip-git`
5. `bundle install && rails db:create`
6. ¡A programar! 🚀