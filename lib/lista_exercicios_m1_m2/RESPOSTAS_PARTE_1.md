# PARTE 1: Fundamentos (01 - Dispositivos Móveis)

## 1. Diferença de Arquiteturas: Nativo vs. Cross-Platform/Híbrido (Flutter)
- **Desenvolvimento Nativo (Android/iOS):** O aplicativo é desenvolvido especificamente para uma única plataforma usando suas linguagens e SDKs oficiais (Kotlin/Java com Android SDK para Android; Swift/Objective-C com UIKit/SwiftUI para iOS). Oferece acesso direto às APIs do sistema, mas exige manter duas bases de código separadas.
- **Desenvolvimento Cross-Platform (Flutter):** Utiliza uma única base de código em Dart para compilar aplicativos nativamente (código de máquina ARM/x64) para múltiplas plataformas (Android, iOS, Web e Desktop). Diferente de frameworks híbridos baseados em WebView ou pontes JavaScript, o Flutter possui seu próprio motor gráfico de renderização (Impeller/Skia), desenhando cada pixel da interface diretamente na tela com desempenho próximo ao nativo.

## 2. Ciclo de Vida e Widgets: StatelessWidget vs. StatefulWidget
- **StatelessWidget (Sem Estado):** É um widget imutável após ser construído. Suas propriedades (`final`) não mudam durante a execução; ele só é redesenhado se o widget pai passar novos parâmetros.
  - *Exemplo de uso:* Uma tela institucional "Sobre o App", um cartão de apresentação estático ou um ícone/cabeçalho fixo.
- **StatefulWidget (Com Estado):** É um widget dinâmico que possui um objeto `State` associado capaz de armazenar dados mutáveis que mudam ao longo do tempo (interações do usuário, requisições de rede, contadores, formulários).
  - *Exemplo de uso:* Uma tela de login/cadastro com campos de texto e mensagens dinâmicas, um carrinho de compras ou um cronômetro.

## 3. Árvore de Widgets (Widget Tree): O que acontece quando chamamos `setState()`?
Quando chamamos `setState()` dentro de um `StatefulWidget`:
1. O callback passado para `setState(() { ... })` atualiza as variáveis internas do objeto `State`.
2. O Flutter marca aquele objeto `Element` específico na Árvore de Elementos como **"sujo" (*dirty*)**, sinalizando que sua configuração visual mudou.
3. No próximo frame de renderização, o framework executa novamente o método `build(BuildContext context)` apenas daquele `State` marcado como *dirty* (e de seus filhos afetados), gerando uma nova subárvore de Widgets imutáveis.
4. O Flutter compara a nova árvore com a anterior (*reconciliation/diffing*) e atualiza na Árvore de Renderização (*RenderObject Tree*) apenas o que realmente mudou na tela, garantindo alta performance.
