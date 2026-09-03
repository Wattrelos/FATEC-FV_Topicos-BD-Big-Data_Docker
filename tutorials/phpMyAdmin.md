# Configuração e Uso do PHPMyAdmin

O PHPMyAdmin é uma interface web gráfica para gerenciar bancos de dados MySQL/MariaDB de forma simples e intuitiva.

---

### 1. Como acessar o PHPMyAdmin

Após subir o ambiente com o Docker Compose, acesse no navegador:

```bash
http://localhost:8080
```

---

### 2. Credenciais de Acesso

O contêiner está pré-configurado para se conectar diretamente ao serviço `mariadb`. No formulário de login do PHPMyAdmin:

| Campo | Acesso Administrador (Root) | Acesso da Aplicação (SaaS) |
| :--- | :--- | :--- |
| **Servidor** | `mariadb` (já pré-configurado) | `mariadb` (já pré-configurado) |
| **Utilizador** | `root` | `saas_user` |
| **Palavra-passe** | `rootpassword` | `saas_password` |
| **Base de dados** | Acesso total a todas as bases | `saas_db` |

---

### 3. Comandos Úteis no Docker

* **Subir apenas o PHPMyAdmin**:
  ```bash
  docker compose up -d phpmyadmin
  ```

* **Visualizar logs do PHPMyAdmin**:
  ```bash
  docker compose logs -f phpmyadmin
  ```

* **Parar o PHPMyAdmin**:
  ```bash
  docker compose stop phpmyadmin
  ```

---

### 4. Dicas e Boas Práticas

* **Importação de Arquivos Grandes**: O parâmetro `UPLOAD_LIMIT: 64M` foi configurado no `docker-compose.yml` para permitir o upload e importação de dumps SQL de até 64MB via interface web.
* **Segurança em Produção**:
  - Em ambientes de produção, **não exponha o PHPMyAdmin publicamente na internet** sem autenticação adicional (ex: HTTP Basic Auth, VPN ou túnel SSH).
  - Nunca utilize a senha padrão de `root` fora do ambiente de desenvolvimento local.


  O erro ERROR 1045 (28000): Access denied... (using password: NO) aconteceu porque o MariaDB dentro do seu container Docker exige uma senha para o usuário root, e você tentou entrar deixando a senha em branco (apenas apertando Enter).
Em containers Docker, a senha do root quase nunca fica vazia por padrão. Ela é obrigatoriamente definida no momento em que o container é criado.
Para resolver e conseguir acessar o terminal, tente as seguintes alternativas:
## 1. Descobrir a senha pelas Variáveis de Ambiente
Quando criamos um container do MariaDB, passamos a senha através de uma variável chamada MARIADB_ROOT_PASSWORD ou MYSQL_ROOT_PASSWORD. Você pode inspecionar o container para ver qual senha foi definida:
Execute no terminal do seu computador:

docker inspect docker-mariadb-1 | grep -i PASSWORD

Procure na saída por algo como "MARIADB_ROOT_PASSWORD=sua_senha_aqui". Se encontrar, use essa senha quando o comando pedir Enter password:.
------------------------------
## 2. Se você estiver usando Docker Compose
Se você subiu o projeto usando um arquivo docker-compose.yml, abra esse arquivo em um editor de texto e procure pela seção do serviço do MariaDB. A senha estará escrita explicitamente abaixo de environment::

environment:
  - MARIADB_ROOT_PASSWORD=senha_secreta  # <--- Esta é a sua senha

------------------------------
## 3. Forçar o acesso ignorando a senha (Modo de Recuperação)
Se você não encontrou a senha e não quer apagar o container, você pode entrar diretamente no terminal do Linux do container e resetar a senha manualmente:

   1. Acesse o terminal interno (Bash) do container:
   
   docker exec -it docker-mariadb-1 bash
   
   2. Caso o container seja muito minimalista e não tenha bash, use sh:
   
   docker exec -it docker-mariadb-1 sh
   
   3. Dentro do container, mude para o usuário administrativo do banco sem precisar de senha externa:
   
   mariadb -u root --skip-password
   
   4. Se o comando acima funcionar, você estará dentro do monitor do MariaDB. Altere a senha para uma de sua preferência:
   
   ALTER USER 'root'@'localhost' IDENTIFIED BY 'nova_senha_facil';
   FLUSH PRIVILEGES;
   EXIT;
   
   5. Digite exit novamente para sair do container. Agora você conseguirá logar usando o comando original e digitando nova_senha_facil.




