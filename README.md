# Docker para iniciantes: SaaS  

Para quem está começando no Docker, o ponto mais importante a entender sobre uma aplicação SaaS é: **no Docker, a boa prática é separar cada serviço em seu próprio contêiner**.

Analisando os requisitos do seu projeto em [ambiente.md](file:///var/www/html/Docker/ambiente.md), a sua arquitetura é composta por:
- **PHP (Backend)**: Precisa de um [Dockerfile](file:///var/www/html/Docker/Dockerfile) customizado para instalar extensões e o Composer.
- **NGINX (Web Server)**, **MariaDB (Banco)**, **Redis (Cache)** e **RabbitMQ (Filas)**: Usam imagens oficiais prontas diretamente no [docker-compose.yml](file:///var/www/html/Docker/docker-compose.yml).

---

### 1. Como funciona o [Dockerfile](file:///var/www/html/Docker/Dockerfile)?

O `Dockerfile` é a **receita de bolo** para criar a imagem do seu **PHP**. Nele definimos a versão do PHP, as extensões necessárias para o SaaS e ferramentas como o Composer.

Aqui está um modelo recomendado e moderno para o seu backend PHP:

```dockerfile
# 1. Imagem base: PHP 8.3 FPM (rápido e preparado para produção/desenvolvimento)
FROM php:8.3-fpm-alpine

# 2. Instala utilitários do sistema operacional necessários
RUN apk add --no-cache \
    bash \
    curl \
    git \
    unzip \
    libpng-dev \
    libzip-dev \
    icu-dev \
    rabbitmq-c-dev \
    linux-headers

# 3. Facilita a instalação de extensões do PHP (ferramenta oficial recomendada)
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions \
        pdo_mysql \
        mysqli \
        redis \
        amqp \
        bcmath \
        gd \
        intl \
        opcache \
        zip \
        sockets

# 4. Instala o Composer (gerenciador de dependências do PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Define o diretório de trabalho onde o código do SaaS ficará dentro do contêiner
WORKDIR /var/www/html

# 6. Porta interna de comunicação do PHP-FPM com o NGINX
EXPOSE 9000

# 7. Comando inicial que mantém o PHP rodando
CMD ["php-fpm"]
```

---

### 2. O que cada linha faz? (Entendendo o Dockerfile)

| Comando | O que significa na prática? |
| :--- | :--- |
| `FROM php:8.3-fpm-alpine` | Escolhe o "sistema base" (Linux Alpine super leve com PHP 8.3). |
| `RUN apk add ...` | Instala programas do sistema operacional (como `git`, `unzip`, etc.). |
| `install-php-extensions` | Instala e ativa as extensões essenciais para SaaS (`pdo_mysql` para MariaDB, `redis` para cache, `amqp` para RabbitMQ). |
| `COPY --from=composer` | Copia o executável do Composer direto da imagem oficial dele. |
| `WORKDIR /var/www/html` | Pasta padrão onde os comandos serão executados. |
| `EXPOSE 9000` | Avisa que o PHP-FPM vai receber conexões na porta 9000. |
| `CMD ["php-fpm"]` | O processo principal que o contêiner deve manter vivo. |

---

### 3. Como o Dockerfile se junta ao resto do SaaS?

O [docker-compose.yml](file:///var/www/html/Docker/docker-compose.yml) é o **maestro** que une o PHP ao NGINX, MariaDB, Redis e RabbitMQ. 

Em vez de usar uma imagem genérica do PHP, você diz ao Compose para **construir (`build`)** o seu `Dockerfile`:

```yaml
version: '3.8'

services:
  # Servidor Web NGINX
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./Beta_engine_SaaS:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php

  # Backend PHP (Construído a partir do seu Dockerfile)
  php:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./Beta_engine_SaaS:/var/www/html
    depends_on:
      - mariadb
      - redis
      - rabbitmq

  # Banco de Dados
  mariadb:
    image: mariadb:11
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: saas_db
      MYSQL_USER: saas_user
      MYSQL_PASSWORD: saas_password
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql

  # Cache em Memória
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

  # Gerenciador de Filas
  rabbitmq:
    image: rabbitmq:3-management-alpine
    ports:
      - "5672:5672"   # Porta de comunicação da aplicação
      - "15672:15672" # Painel Web do RabbitMQ
    environment:
      RABBITMQ_DEFAULT_USER: guest
      RABBITMQ_DEFAULT_PASS: guest

volumes:
  db_data:
```

---

### 4. Como a aplicação se comunica com os serviços?

No Docker, você não usa `localhost` ou `127.0.0.1` dentro do código PHP para conectar no banco ou cache. Você usa **o nome do serviço**:
- Host do Banco: `mariadb` (porta `3306`)
- Host do Redis: `redis` (porta `6379`)
- Host do RabbitMQ: `rabbitmq` (porta `5672`)

---

### 5. Comandos básicos para o dia a dia

Para testar e subir todo o ambiente:

1. **Construir e iniciar tudo em segundo plano**:
   ```bash
   docker compose up -d --build
   ```
2. **Ver o status dos contêineres**:
   ```bash
   docker compose ps
   ```
3. **Ver logs de erros ou saídas**:
   ```bash
   docker compose logs -f php
   ```
4. **Rodar comandos dentro do PHP (ex: Composer ou migrações)**:
   ```bash
   docker compose exec php composer install
   ```
5. **Parar o ambiente**:
   ```bash
   docker compose down
   ```
