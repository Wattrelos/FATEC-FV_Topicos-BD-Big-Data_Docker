Para apontar um repositório local para um repositório remoto no GitHub e baixar as atualizações, use os comandos git remote add e git pull no seu terminal. 
## Passos para vincular e atualizar o repositório

   1. Abra o terminal na pasta do seu projeto local.
   2. Inicialize o repositório Git (caso ainda não tenha feito):
   ```bash
   git init
   ```
   3. Adicione o endereço do repositório remoto (substitua pela sua URL do GitHub):
   ```bash
   git remote add origin https://github.com/Wattrelos/FATEC-FV_Topicos-BD-Big-Data_Docker
   ```
   ou substituri a url existente
   ```bash
   git remote set-url origin https://github.com/Wattrelos/FATEC-FV_Topicos-BD-Big-Data_Docker
   ```
   4. Verifique se o vínculo deu certo:
   ```bash
   git remote -v
   ```
   5. Faça o git pull para trazer os arquivos da branch principal (exemplo: main):
   ```bash
   git pull origin main
   ```


