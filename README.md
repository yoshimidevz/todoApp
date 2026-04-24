# ToDo App

Aplicativo de gerenciamento de tarefas desenvolvido em Flutter como projeto de aprendizado. O objetivo foi praticar os principais conceitos do ecossistema Flutter, aplicando Clean Architecture, gerenciamento de estado com Cubit e boas práticas de desenvolvimento mobile.

---

## Funcionalidades

- **Criar e gerenciar tarefas** — adicione tarefas com título, data de vencimento e categoria
- **Favoritos e "Para hoje"** — marque tarefas como importantes ou para fazer no dia
- **Busca e filtros** — filtre por todas as tarefas, importantes ou do dia; busca por título
- **Categorias** — 4 categorias padrão (Pessoal, Trabalho, Estudos, Compras) + categorias customizadas
- **Anotações** — adicione, edite e remova notas dentro de cada tarefa
- **Anexos** — selecione, visualize, baixe e delete arquivos attachados à tarefa
- **Lembretes** — configure data e hora para receber notificações locais
- **Repetição** — defina intervalos de repetição (diário, semanal, mensal)
- **Deletar por swipe** — remova tarefas deslizando o card com confirmação

---

## Arquitetura

O projeto segue **Clean Architecture** organizada por feature, com separação clara entre as camadas:

```
lib/
├── core/                  # Utilitários compartilhados
│   ├── di/                # Injeção de dependência (GetIt)
│   ├── theme/             # Cores, tipografia e tema Material
│   ├── routes/            # Navegação declarativa (GoRouter)
│   ├── services/          # Serviço de notificações locais
│   ├── validators/        # Validação de formulários
│   ├── masks/             # Formatação de inputs
│   ├── messages/          # Strings de UI e categorias padrão
│   └── patterns/          # Componentes reutilizáveis (botão, card, input, dialog)
└── features/
    └── todo/
        ├── domain/        # Entidades e contratos de repositório
        ├── data/          # Implementações dos repositórios
        └── presentation/  # Pages, widgets e Cubits
```

### Camadas

| Camada | Responsabilidade |
|---|---|
| **Domain** | Entidades de negócio e interfaces dos repositórios |
| **Data** | Implementação dos repositórios e armazenamento |
| **Presentation** | UI (Pages e Widgets) + estado (Cubit) |

---

## Stack e Dependências

| Categoria | Pacote | Versão |
|---|---|---|
| State Management | `flutter_bloc` | ^8.1.3 |
| Injeção de Dependência | `get_it` | ^7.6.4 |
| Navegação | `go_router` | ^17.1.0 |
| Persistência de Categorias | `shared_preferences` | ^2.2.2 |
| Notificações Locais | `flutter_local_notifications` | ^18.0.0 |
| Timezone | `timezone` | ^0.9.4 |
| Seleção de Arquivos | `file_picker` | ^8.0.0 |
| Formatação de Input | `mask_text_input_formatter` | ^2.9.0 |
| Seções expansíveis | `expandable_section` | ^0.0.4 |
| Web interop | `web` | ^1.1.1 |

---

## Como rodar

### Pré-requisitos

- Flutter SDK `^3.11.0`
- Dart SDK (incluso no Flutter)
- Android SDK (para Android) ou Xcode (para iOS)

### Instalação

```bash
# Clone o repositório
git clone https://github.com/yoshimidevz/flutter-teste.git
cd flutter-teste/toDo

# Instale as dependências
flutter pub get

# Rode o aplicativo
flutter run
```

### Build

```bash
flutter build apk      # Android
flutter build ios      # iOS (requer macOS + Xcode)
flutter build web      # Web
```

---

## Estrutura de Dados

As tarefas são armazenadas **em memória** durante a sessão (sem persistência em banco de dados). As categorias customizadas são salvas via `SharedPreferences`. Os anexos são mantidos como `Uint8List` em memória, com suporte a preview e download via Blob URL no ambiente web.

---

## Padrões Utilizados

- **Repository Pattern** — abstração da camada de dados via interfaces no domínio
- **Cubit (BLoC)** — gerenciamento de estado reativo com estados imutáveis
- **Service Locator (GetIt)** — resolução de dependências sem context do Flutter
- **GoRouter** — roteamento declarativo com tipagem de parâmetros
- **Widget Composition** — componentes reutilizáveis no `core/patterns`

---

## Screenshots

> _Em breve_

---

## Licença

Este projeto é de uso educacional e não possui licença definida.
