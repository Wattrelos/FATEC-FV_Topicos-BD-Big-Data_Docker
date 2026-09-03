# Implantando o SaaS no servidor NGINX

### 1. O que alterar no [nginx.conf](file:///home/wattrelos/Docker/nginx.conf)

Na linha 7 do seu `nginx.conf`, mude o `root`:

```nginx
    # Antes:
    root /var/www/html;

    # Altere para:
    root /var/www/html/public_html;
```

---

### 2. Por que NÃO mexer no [docker-compose.yml](file:///home/wattrelos/Docker/docker-compose.yml)?

Mantenha o volume montando a pasta inteira do projeto (`./Beta_engine_SaaS:/var/www/html`) tanto no NGINX quanto no PHP. Isso é o padrão da indústria e a melhor prática de segurança por dois motivos:

1. **Segurança (Isolamento do Backend)**:
   - Apenas os arquivos de `public_html/` (como `index.php`, CSS, JS e imagens) ficam expostos à internet e acessíveis pelo navegador.
   - Os arquivos de `backend/` (configurações de banco, `.env`, models, controladores) ficam um nível acima, **completamente blindados** contra downloads acidentais pelo navegador.
2. **Acesso pelo PHP**:
   - Quando o `index.php` rodar, ele ainda conseguirá importar o backend normalmente usando caminhos relativos como:
     ```php
     require_once __DIR__ . '/../backend/autoload.php';
     ```

---

### 3. Dica Extra: Regras do seu `.htaccess` no NGINX

Analisando o arquivo [.htaccess](file:///home/wattrelos/Docker/Beta_engine_SaaS/public_html/.htaccess), você possui um bloqueio de `/admin`:
```apache
Redirect 403 /admin
```
O NGINX não lê arquivos `.htaccess` do Apache. Se desejar manter esse mesmo bloqueio ativo no NGINX, você pode adicionar este bloco dentro do `server { ... }` no `nginx.conf`:

```nginx
    # Bloqueia acesso à rota /admin (equivalente ao Redirect 403 /admin)
    location ^~ /admin {
        return 403;
    }
```

---

### 4. Como aplicar a alteração

Após editar o arquivo, aplique a nova configuração sem precisar derrubar os contêineres:

```bash
docker compose exec nginx nginx -s reload
```
*(ou se preferir reiniciar o serviço: `docker compose restart nginx`)*

---

Deseja que eu faça essa alteração no [nginx.conf](file:///home/wattrelos/Docker/nginx.conf) e recarregue o NGINX agora mesmo para você?