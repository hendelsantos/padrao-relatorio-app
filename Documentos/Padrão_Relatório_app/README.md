# Relatório de Peças App

Aplicativo Flutter para técnicos criarem relatórios padronizados de peças e enviarem via WhatsApp.

## Funcionalidades

- ✅ **Scanner QR Code**: Escaneia códigos QR ou códigos de barras de 17 caracteres
- ✅ **Formulário Padronizado**: Campos estruturados para relatórios de peças
- ✅ **Integração WhatsApp**: Envio automático do relatório formatado
- ✅ **Integração Email**: Envio por email usando app do dispositivo
- ✅ **Armazenamento Local**: Coleta dados para envio em lote
- ✅ **Envio em Massa**: Múltiplos itens organizados
- ✅ **Validação de Dados**: Verificação automática dos campos obrigatórios
- ✅ **Interface Amigável**: Design intuitivo para uso em campo

## Campos do Inventário

1. **Catalog** *(obrigatório)*: Código do catálogo (17 caracteres)
2. **Quantidade Unrestrict** *(obrigatório)*: Quantidade da peça
3. **Material** *(opcional)*: Tipo do material
4. **Tipo** *(opcional)*: Classificação da peça
5. **FOC** *(opcional)*: Free of Charge
6. **RFB** *(opcional)*: Return for Billing
7. **Observações** *(opcional)*: Comentários adicionais

## Campos do Relatório

1. **Peça** *(obrigatório)*: Quantidade da peça utilizada
2. **Local** *(obrigatório)*: Local onde a peça foi utilizada  
3. **Ordem** *(opcional)*: Número da ordem de serviço
4. **Retorno ao estoque** *(obrigatório)*: Sim/Não
5. **Restou** *(obrigatório)*: Quantidade que restou da peça
6. **Código QR** *(obrigatório)*: 17 caracteres escaneados ou inseridos manualmente

## Requisitos

- Flutter 3.32.5 ou superior
- Dart 3.8.1 ou superior
- Android 5.0+ (API 21+) / iOS 11.0+
- Câmera no dispositivo
- WhatsApp instalado

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/padrao-relatorio-app.git
cd padrao-relatorio-app
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## Dependências Principais

- `mobile_scanner: ^5.2.1` - Scanner de QR Code 
- `url_launcher: ^6.3.0` - Integração WhatsApp e Email
- `permission_handler: ^11.3.1` - Permissões de câmera
- `shared_preferences: ^2.2.2` - Armazenamento local

## Permissões

### Android
- `CAMERA` - Para escanear QR codes
- `INTERNET` - Para abrir WhatsApp

### iOS
- Câmera - Configurada automaticamente pelo Flutter

## Como Usar

### Inventário Individual
1. **Abra o aplicativo** → Selecione "Inventário"
2. **Escaneie o código** ou digite manualmente (17 caracteres)
3. **Preencha os campos** do inventário
4. **Salve o item** ou **envie direto por WhatsApp**

### Inventário em Lote
1. **Colete múltiplos itens** salvando cada um
2. **Acesse a lista** através do ícone de lista
3. **Configure destinatários** (WhatsApp/Email)
4. **Envie todos os itens** de uma vez

### Relatório de Manutenção
1. **Escaneie o código QR** ou digite manualmente (17 caracteres)  
2. **Preencha os campos** do relatório
3. **Toque em "Enviar WhatsApp"** para gerar e enviar o relatório

## Estrutura do Projeto

```
lib/
├── main.dart                    # Ponto de entrada
├── models/
│   ├── inventario.dart          # Modelo de inventário
│   └── relatorio_manutencao.dart # Modelo de relatório  
├── screens/
│   ├── home_screen.dart         # Tela principal
│   ├── menu_principal_screen.dart # Menu de navegação
│   ├── inventario_screen.dart   # Tela de inventário
│   ├── inventario_list_screen.dart # Lista de itens coletados
│   ├── qr_scanner_screen.dart   # Tela do scanner
│   └── sobre_page.dart          # Página sobre
├── services/
│   ├── inventario_storage_service.dart # Armazenamento local
│   └── communication_service.dart      # Envio WhatsApp/Email
└── widgets/                     # Widgets reutilizáveis
```

## Desenvolvimento

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

Leia o [CONTRIBUTING.md](CONTRIBUTING.md) para mais detalhes sobre como contribuir.

## Changelog

Veja o [CHANGELOG.md](CHANGELOG.md) para histórico de versões e mudanças.

## Suporte

- 📋 [Issues](https://github.com/seu-usuario/padrao-relatorio-app/issues) - Reporte bugs ou sugira melhorias
- 💬 [Discussions](https://github.com/seu-usuario/padrao-relatorio-app/discussions) - Faça perguntas ou compartilhe ideias
- 📖 [Wiki](https://github.com/seu-usuario/padrao-relatorio-app/wiki) - Documentação adicional

## Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
