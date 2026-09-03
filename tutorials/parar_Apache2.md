# Parar o Apache2 para evitar conflitos com o Docker (Porta 80 e 443)
Para desativar o Apache2 e impedir que ele inicie junto com o sistema no Debian 13, use os seguintes comandos no terminal:
```bash
sudo systemctl stop apache2
sudo systemctl disable apache2
```
## O que cada comando faz:

* stop: Para o serviço imediatamente 🛑
* disable: Remove o serviço da inicialização automática 🛠️

(Nota: Se quiser garantir que nenhum outro processo consiga ativar o Apache de forma alguma, você também pode usar sudo systemctl mask apache2).

