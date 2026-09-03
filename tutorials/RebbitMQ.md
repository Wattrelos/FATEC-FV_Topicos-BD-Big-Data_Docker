# Configuração do RabbitMQ

### 1. Acesse o painel do RabbitMQ

```bash
http://localhost:15672/
```

### 2. Login no painel do RabbitMQ (primeira instalação)

A credencial padrão do RabbitMQ na primeira vez após a instalação é:

* Usuário: guest
* Senha: guest 

## ⚠️ Informações importantes sobre segurança:

* Restrição de Localhost: Por padrão, esse usuário guest só pode se conectar via localhost (loopback interface). Se você tentar acessar a interface de gerenciamento ou conectar uma aplicação a partir de outra máquina na rede usando essas credenciais, o acesso será recusado por motivos de segurança. 
* Ambientes de Produção: Nunca utilize o usuário guest em produção. A recomendação oficial é criar um novo usuário com privilégios de administrador e excluir ou desativar o usuário padrão.

## 🛠️ Como criar um novo usuário administrador:
Se você precisar acessar o RabbitMQ remotamente ou quiser seguir as boas práticas de segurança, abra o terminal do seu servidor e execute os seguintes comandos:

   1. Criar o usuário e a senha:
```bash
   rabbitmqctl add_user seu_usuario sua_senha_forte
```
   
   2. Definir a tag de administrador:
```bash
   rabbitmqctl set_user_tags seu_usuario administrator
```
   
   3. Conceder permissões totais nos hosts virtuais:
```bash
   rabbitmqctl set_permissions -p / seu_usuario ".*" ".*" ".*"
```
   
