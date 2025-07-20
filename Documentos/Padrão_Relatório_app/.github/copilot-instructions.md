<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Relatório de Manutenção App - Instruções do Copilot

Este é um aplicativo Flutter para técnicos de manutenção criarem relatórios padronizados.

## Estrutura do Projeto

- **Linguagem**: Dart/Flutter
- **Arquitetura**: Simples com separação por pastas (screens, models, widgets)
- **Funcionalidades principais**:
  - Scanner de QR Code/Código de Barras (17 caracteres)
  - Formulário de relatório de manutenção
  - Integração com WhatsApp para envio de relatórios

## Campos do Relatório

1. **Peça** (obrigatório): Quantidade da peça utilizada
2. **Local** (obrigatório): Local onde a peça foi utilizada
3. **Ordem** (opcional): Número da ordem de serviço
4. **Retorno ao estoque** (obrigatório): Sim/Não
5. **Restou** (obrigatório): Quantidade que restou da peça
6. **Código QR** (obrigatório): 17 caracteres escaneados ou inseridos manualmente

## Dependências Principais

- `qr_code_scanner`: Para scanner de QR Code
- `url_launcher`: Para integração com WhatsApp
- `permission_handler`: Para permissões de câmera

## Padrões de Código

- Use Material Design 3
- Implemente validação de formulários
- Mantenha responsividade para diferentes tamanhos de tela
- Use cores consistentes (tema azul/verde)
- Implemente tratamento de erros adequado

## Formatação do Relatório para WhatsApp

O relatório deve ser formatado em Markdown para melhor visualização no WhatsApp, incluindo todos os campos preenchidos e uma assinatura automática.
