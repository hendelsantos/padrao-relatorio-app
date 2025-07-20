# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [1.3.0] - 2025-01-20

### Adicionado
- Funcionalidade de envio por email individual no inventário
- Botão de email (laranja) na tela de inventário individual
- Sistema de fallback para aplicativos de email
- Integração com Gmail Web como alternativa
- Mensagens de erro melhoradas com orientações para o usuário

### Melhorado
- Tratamento de erros mais robusto para envio de emails
- Interface de usuário aprimorada com validações
- Sistema de comunicação com múltiplas opções de fallback
- Experiência do usuário em dispositivos sem email configurado

### Corrigido
- Erro de envio de email quando não há app padrão configurado
- Problemas de compatibilidade com diferentes versões do Android
- Mensagens de erro pouco informativas

## [1.2.0] - 2025-01-15

### Adicionado
- Funcionalidade de inventário em lote
- Envio de múltiplos itens via WhatsApp e Email
- Sistema de armazenamento local para coleta de dados
- Lista de itens coletados com opções de edição e exclusão

### Melhorado
- Interface de usuário redesenhada
- Navegação entre telas otimizada
- Validação de dados aprimorada

## [1.1.0] - 2025-01-10

### Adicionado
- Scanner de QR Code e código de barras
- Formulário de relatório de manutenção
- Integração com WhatsApp para envio de relatórios
- Validação de códigos de 17 caracteres

### Melhorado
- Performance do scanner
- Formatação de mensagens para WhatsApp

## [1.0.0] - 2025-01-05

### Adicionado
- Versão inicial do aplicativo
- Funcionalidades básicas de inventário
- Interface principal com Material Design
- Estrutura base do projeto Flutter

### Recursos Principais
- Formulário de inventário individual
- Validação básica de dados
- Interface responsiva
- Navegação entre telas

---

## Tipos de Mudanças
- `Adicionado` para novas funcionalidades
- `Melhorado` para mudanças em funcionalidades existentes
- `Depreciado` para funcionalidades que serão removidas em breve
- `Removido` para funcionalidades removidas
- `Corrigido` para correção de bugs
- `Segurança` para vulnerabilidades corrigidas
