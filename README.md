# Projeto Dartpedia & Práticas Flutter (PPDM)

Repositório das atividades desenvolvidas na Unidade Curricular de **Programação para Dispositivos Móveis (PPDM)** — Prof. Irineu Moura Caldeira.

---

## Lição 14 - Prática de Fixação: Módulos 01 e 02 (Respostas Conceituais)

### 1. Diferença de Arquiteturas: Nativo (Android/iOS) vs. Cross-Platform/Híbrido (Flutter)
- **Desenvolvimento Nativo (Android/iOS):** Utiliza linguagens e SDKs específicos de cada sistema operacional (Kotlin/Java para Android; Swift/Objective-C para iOS). Garante integração direta com o hardware e sistema, porém exige duas equipes ou duas bases de código distintas para atender ambas as plataformas.
- **Desenvolvimento Cross-Platform (Flutter):** Permite escrever uma única base de código em **Dart** que é compilada diretamente para código de máquina nativo (ARM/x64) tanto para Android quanto para iOS (além de Web e Desktop). Ao contrário de abordagens híbridas baseadas em WebView ou pontes JavaScript, o Flutter utiliza seu próprio motor gráfico de renderização (Impeller/Skia), desenhando toda a interface diretamente na tela com fluidez e desempenho nativos.

### 2. Ciclo de Vida e Widgets: `StatelessWidget` vs. `StatefulWidget`
- **`StatelessWidget` (Widget Estático / Sem Estado):** É imutável depois de instanciado. Seus dados (`final`) não se alteram internamente durante a vida útil do widget; ele só é reconstruído se o widget pai fornecer novos valores.
  - *Quando usar:* Em telas ou componentes puramente visuais e estáticos, como um cabeçalho, um ícone decorativo, um texto fixo ou uma tela de "Sobre o Aplicativo".
- **`StatefulWidget` (Widget Dinâmico / Com Estado):** Possui um objeto `State` associado que mantém valores mutáveis capazes de mudar em tempo de execução conforme ações do usuário ou eventos externos.
  - *Quando usar:* Em componentes interativos que mudam na tela, como um botão de curtir/favoritar, um contador, um formulário de cadastro ou uma lista filtrável.

### 3. Gerenciamento de Estado: O que acontece na tela quando chamamos `setState()`?
Ao chamar `setState()` dentro de um `StatefulWidget`:
1. O estado interno das variáveis é atualizado dentro da função de callback passada ao `setState()`.
2. O Flutter marca o elemento correspondente na árvore de widgets como **sujo (*dirty*)**, indicando que sua interface precisa ser atualizada.
3. No próximo ciclo de frame, o método `build()` daquele `State` é executado novamente, reconstruindo apenas os widgets afetados e atualizando visualmente a tela com os novos valores de forma otimizada e sem recarregar todo o aplicativo.
