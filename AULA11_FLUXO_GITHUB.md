# Aula 11 — Fluxo de Trabalho Git & GitHub (Cloud Shell <-> Repositório <-> Sala de Aula)

Repositório oficial: [https://github.com/emersonsilva17-debug/dartpedia](https://github.com/emersonsilva17-debug/dartpedia)

## ETAPA 1 (Na nuvem / Cloud Shell): Subir os projetos para o GitHub
Todos os pacotes e módulos desenvolvidos (dartpedia, command_runner, wikipedia, birdle e exercícios das aulas 07 a 10) foram versionados e enviados para a branch main:
- cd ~/dartpedia
- git status
- git add .
- git commit -m "Atividade 011 - Aula 11: Consolidacao do fluxo GitHub (Nuvem e Sala)"
- git push origin main

## ETAPA 2 (Na Sala de Aula): Clonar os projetos no Servidor/PC Local
Para baixar todo o ambiente de trabalho no computador local da sala de aula:
- git clone [https://github.com/emersonsilva17-debug/dartpedia.git](https://github.com/emersonsilva17-debug/dartpedia.git)
- cd dartpedia
- dart pub get
- (cd command_runner && dart pub get)
- (cd wikipedia && dart pub get)
- (cd birdle && flutter pub get)

## ETAPA 3 (A partir de amanhã): Rotina de Trabalho na Sala de Aula
Ciclo diário de sincronização para evitar conflitos entre a bancada, o Cloud Shell e o PC local:
1. Ao iniciar a aula (baixar atualizações antes de editar): cd dartpedia && git pull origin main
2. Durante a aula (desenvolver e testar): dart run bin/dartpedia.dart ou flutter run
3. Ao finalizar a aula (salvar e enviar alterações ao GitHub): git add . && git commit -m "Descricao" && git push origin main
