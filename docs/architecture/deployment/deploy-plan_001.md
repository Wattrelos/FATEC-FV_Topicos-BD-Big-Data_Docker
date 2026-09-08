# Migração de Credenciais para o arquivo .env

Transferir todas as credenciais e configurações sensíveis (senhas, usuários e nomes de banco) do `docker-compose.yml` e do código PHP (`Beta_engine_SaaS/index.php`) para o arquivo `.env`, garantindo segurança e boas práticas de desenvolvimento (Twelve-Factor App).

## Contexto e Motivação

Atualmente:
- As senhas do MariaDB (`rootpassword`, `saas_password`) e do RabbitMQ (`guest`) estão expostas em texto puro no [docker-compose.yml](file:///home/wattrelos/Docker/docker-compose.yml).
- O script [index.php](file:///home/wattrelos/Docker/Beta_engine_SaaS/index.php) possui as credenciais gravadas diretamente no código-fonte.
- O arquivo [.env](file:///home/wattrelos/Docker/.env) já foi criado vazio e já está protegido no [.gitignore](file:///home/wattrelos/Docker/.gitignore).

Com esta mudança:
1. O [.env](file:///home/wattrelos/Docker/.env) guardará os valores reais das credenciais.
2. Criaremos um [.env.example](file:///home/wattrelos/Docker/.env.example) como modelo para controle de versão.
3. O [docker-compose.yml](file:///home/wattrelos/Docker/docker-compose.yml) consumirá as variáveis via `${VARIAVEL}` e as repassará ao container PHP.
4. O [index.php](file:///home/wattrelos/Docker/Beta_engine_SaaS/index.php) lerá os dados dinamicamente via `getenv()` com fallbacks seguros.

---

## User Review Required

> [!IMPORTANT]
> O container `mariadb` já inicializou o volume `db_data` com a senha e usuário atuais (`rootpassword`, `saas_user` / `saas_password`). Manteremos exatamente os mesmos valores no `.env` para que o banco existente continue funcionando sem necessidade de apagar volumes ou redefinir senhas.

---

## Proposed Changes

### Configuração de Ambiente

#### [MODIFY] [.env](file:///home/wattrelos/Docker/.env)
Preencher com as credenciais do ambiente e portas:
- `MYSQL_ROOT_PASSWORD=rootpassword`
- `MYSQL_DATABASE=saas_db`
- `MYSQL_USER=saas_user`
- `MYSQL_PASSWORD=saas_password`
- `RABBITMQ_DEFAULT_USER=guest`
- `RABBITMQ_DEFAULT_PASS=guest`
- Portas dos serviços (`NGINX_PORT=80`, `PHPMYADMIN_PORT=8080`, `MARIADB_PORT=3306`, etc.)

#### [NEW] [.env.example](file:///home/wattrelos/Docker/.env.example)
Criar arquivo de exemplo com valores padrão ou fictícios para servir de referência para outros desenvolvedores ou novos deploys.

---

### Orquestração Docker

#### [MODIFY] [docker-compose.yml](file:///home/wattrelos/Docker/docker-compose.yml)
- Atualizar a seção `mariadb` para usar `${MYSQL_ROOT_PASSWORD}`, `${MYSQL_DATABASE}`, `${MYSQL_USER}`, `${MYSQL_PASSWORD}` e porta configurável.
- Atualizar a seção `rabbitmq` para usar `${RABBITMQ_DEFAULT_USER}` e `${RABBITMQ_DEFAULT_PASS}`.
- Adicionar variáveis de ambiente na seção `php` (`DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`, `RABBITMQ_HOST`, `RABBITMQ_PORT`, `RABBITMQ_USER`, `RABBITMQ_PASSWORD`, `REDIS_HOST`, `REDIS_PORT`).
- Usar variáveis para mapeamento de portas externas (`${NGINX_PORT:-80}`, `${PHPMYADMIN_PORT:-8080}`).

---

### Aplicação PHP

#### [MODIFY] [Beta_engine_SaaS/index.php](file:///home/wattrelos/Docker/Beta_engine_SaaS/index.php)
- Atualizar conexão MariaDB (PDO) para obter host, porta, dbname, user e pass via `getenv()`.
- Atualizar conexão Redis para obter host e porta via `getenv()`.
- Atualizar conexão RabbitMQ (AMQP) para obter host, porta, login e password via `getenv()`.

---

## Verification Plan

### Verificação Automatizada e Comandos
1. Aplicar a nova configuração no Docker Compose:
   ```bash
   docker compose up -d
   ```
2. Testar resposta da aplicação PHP via HTTP:
   ```bash
   curl -I http://localhost
   ```
3. Testar conexão interna do PHP com todos os serviços:
   ```bash
   curl -s http://localhost | grep -E "Conectado a saas_db|redis:6379|Broker AMQP"
   ```
4. Confirmar que não há variáveis não resolvidas no Compose:
   ```bash
   docker compose config
   ```
