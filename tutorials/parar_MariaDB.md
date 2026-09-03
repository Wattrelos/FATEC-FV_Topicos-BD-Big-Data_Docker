
# Como parar o MariaDB



## Gerenciamento do Serviço
Como o Debian 13 utiliza o systemd como gerenciador de serviços, você também pode utilizar as seguintes variações para administrar o banco de dados: 


* Parar o serviço: 

```bash
sudo systemctl stop mariadb
```
* Iniciar o serviço: 

```bash
sudo systemctl start mariadb
```

* Reiniciar o serviço: 

```bash
sudo systemctl restart mariadb
```

* Verificar o status atual: 

```bash
sudo systemctl status mariadb
```
* 

Se o serviço apresentar dificuldades para interromper a execução, você gostaria de ajuda para analisar os logs de erro ou forçar o encerramento do processo?



## Comandos de Inicialização

Para impedir que o MariaDB seja iniciado automaticamente junto com o sistema (inicialização), use o comando sudo systemctl disable mariadb.

* Desativar inicialização automática: 

```bash
sudo systemctl disable mariadb
```

* Ativar inicialização automática: 

```bash
sudo systemctl enable mariadb
```

* Verificar se está ativado: 

```bash
sudo systemctl is-enabled mariadb
```

(Nota: O comando disable apenas impede que ele ligue sozinho no próximo boot, mas não desliga o banco de dados se ele já estiver rodando agora).

