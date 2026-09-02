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