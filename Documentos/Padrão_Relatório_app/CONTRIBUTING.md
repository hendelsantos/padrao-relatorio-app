# Contribuindo para o Relatório de Peças App

Obrigado por considerar contribuir para o nosso projeto! Este documento contém diretrizes e informações sobre como contribuir.

## Como Contribuir

### Reportando Bugs

1. **Verifique se o bug já foi reportado** nas [Issues](../../issues)
2. **Crie uma nova issue** incluindo:
   - Descrição clara do problema
   - Passos para reproduzir
   - Comportamento esperado vs atual
   - Screenshots (se aplicável)
   - Versão do Flutter/Dart
   - Dispositivo e versão do OS

### Sugerindo Melhorias

1. **Verifique se a sugestão já existe** nas Issues
2. **Crie uma nova issue** marcada como "enhancement" incluindo:
   - Descrição clara da funcionalidade
   - Justificativa para a mudança
   - Possíveis implementações

### Pull Requests

1. **Fork o repositório**
2. **Crie uma branch** para sua feature:
   ```bash
   git checkout -b feature/nova-funcionalidade
   ```
3. **Faça suas mudanças** seguindo as diretrizes de código
4. **Teste suas mudanças** completamente
5. **Commit suas mudanças** com mensagens descritivas:
   ```bash
   git commit -m "feat: adiciona envio por email no inventário"
   ```
6. **Push para sua branch**:
   ```bash
   git push origin feature/nova-funcionalidade
   ```
7. **Abra um Pull Request**

## Diretrizes de Código

### Estilo de Código

- Use **camelCase** para variáveis e funções
- Use **PascalCase** para classes
- Use **snake_case** para arquivos
- Siga as convenções do [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

### Estrutura de Commits

Use mensagens de commit convencionais:

- `feat:` para novas funcionalidades
- `fix:` para correções de bugs
- `docs:` para documentação
- `style:` para formatação
- `refactor:` para refatoração
- `test:` para testes
- `chore:` para tarefas de manutenção

### Testes

- Escreva testes para novas funcionalidades
- Certifique-se de que todos os testes passam:
  ```bash
  flutter test
  ```

### Documentação

- Documente APIs públicas
- Atualize o README.md se necessário
- Adicione comentários para código complexo

## Configuração do Ambiente

### Pré-requisitos

- Flutter 3.32.5+
- Dart 3.8.1+
- Android Studio / VS Code
- Git

### Configuração

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/seu-usuario/padrao_relatorio_app.git
   cd padrao_relatorio_app
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Execute o app**:
   ```bash
   flutter run
   ```

4. **Execute os testes**:
   ```bash
   flutter test
   ```

## Estrutura do Projeto

```
lib/
├── main.dart                    # Ponto de entrada
├── models/                      # Modelos de dados
├── screens/                     # Telas da aplicação
├── services/                    # Serviços e APIs
└── widgets/                     # Widgets reutilizáveis
```

## Processo de Review

1. **Automated checks** rodam automaticamente
2. **Code review** por mantenedores
3. **Feedback** e mudanças solicitadas
4. **Merge** após aprovação

## Diretrizes de Issues

### Labels

- `bug` - Algo não está funcionando
- `enhancement` - Nova funcionalidade ou melhoria
- `documentation` - Melhorias na documentação
- `good first issue` - Bom para novos contribuidores
- `help wanted` - Precisa de ajuda extra

### Templates

Use os templates de issue disponíveis para:
- Bug reports
- Feature requests
- Questões de documentação

## Código de Conduta

Este projeto adere ao [Contributor Covenant](https://www.contributor-covenant.org/). Ao participar, você concorda em manter um ambiente respeitoso e inclusivo.

## Dúvidas?

Se você tem dúvidas sobre como contribuir:

1. Abra uma [Discussion](../../discussions)
2. Entre em contato com os mantenedores
3. Verifique a documentação existente

## Reconhecimento

Todos os contribuidores são reconhecidos no projeto. Obrigado por fazer este projeto melhor! 🙏
