# Relatório de Peças App

Aplicativo Flutter para técnicos criarem relatórios padronizados de peças e enviarem via WhatsApp.

👋 **Desenvolvido por Hendel Santos**  
Desenvolvedor especializado em Django, apaixonado por criar sistemas web robustos e inteligentes para diversos segmentos - de manutenção industrial a soluções comerciais. Me especializando em IA generativa e Engenharia de Prompt, focada em acelerar resultados com tecnologia prática e escalável.

## 🚀 Sobre este Projeto

💡 **"O Futuro é programável"**

Este aplicativo Flutter representa a evolução natural dos meus sistemas de manutenção industrial, agora em formato mobile para uso em campo. Desenvolvido com foco na praticidade e eficiência dos técnicos, oferece uma solução completa para documentação e comunicação de atividades de manutenção.

## ✨ Funcionalidades

- ✅ **Scanner QR Code**: Escaneia códigos QR ou códigos de barras de 17 caracteres
- ✅ **Formulário Padronizado**: Campos estruturados para relatórios de peças
- ✅ **Integração WhatsApp**: Envio automático do relatório formatado
- ✅ **Integração Email**: Envio por email usando app do dispositivo
- ✅ **Armazenamento Local**: Coleta dados para envio em lote
- ✅ **Envio em Massa**: Múltiplos itens organizados
- ✅ **Validação de Dados**: Verificação automática dos campos obrigatórios
- ✅ **Interface Amigável**: Design intuitivo para uso em campo

## 🛠️ Tecnologias Utilizadas

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

**Stack Principal:**
- **Flutter 3.32.5+** - Framework multiplataforma
- **Dart 3.8.1+** - Linguagem de programação
- **Material Design 3** - Interface moderna e responsiva
- **Mobile Scanner** - Scanner QR Code nativo
- **URL Launcher** - Integração com apps externos

## 🌟 Outros Projetos em Destaque

### 📋 Sistema de Demandas - Django (Controle V1)
Sistema completo de controle de demandas com Django, SQLite, Bootstrap e painel administrativo
👉 [Ver Projeto](https://github.com/hendelsantos)

### 📦 CRM de Estoque - Flask  
Sistema completo de estoque com cartões, planilhas, filtros e painel admin

### 🛠️ Rede Engrenagem
Rede social corporativa para técnicos de manutenção com feed e upload de fotos

### ☁️ PhotoCloud
Sistema de armazenamento de fotos com galeria web, upload rápido e exclusão automática por tempo configurado. Hospedado no Render, disponível para uso em produção.

## 🧠 Minha Visão Tecnológica

🔧 Desenvolvo CRMs, redes sociais técnicas, sistemas de estoque e ferramentas visuais voltadas para o setor industrial  
📚 Em constante evolução: Python, Django, Flutter - sempre com projetos práticos  
🤖 Estudando Engenharia de Prompt e IA Generativa - **o maior ativo de uma empresa é o tempo!**

## 📱 Campos do Inventário

1. **Catalog** *(obrigatório)*: Código do catálogo (17 caracteres)
2. **Quantidade Unrestrict** *(obrigatório)*: Quantidade da peça
3. **Material** *(opcional)*: Tipo do material
4. **Tipo** *(opcional)*: Classificação da peça
5. **FOC** *(opcional)*: Free of Charge
6. **RFB** *(opcional)*: Return for Billing
7. **Observações** *(opcional)*: Comentários adicionais

## 📋 Campos do Relatório

1. **Peça** *(obrigatório)*: Quantidade da peça utilizada
2. **Local** *(obrigatório)*: Local onde a peça foi utilizada  
3. **Ordem** *(opcional)*: Número da ordem de serviço
4. **Retorno ao estoque** *(obrigatório)*: Sim/Não
5. **Restou** *(obrigatório)*: Quantidade que restou da peça
6. **Código QR** *(obrigatório)*: 17 caracteres escaneados ou inseridos manualmente

## 📋 Requisitos

- Flutter 3.32.5 ou superior
- Dart 3.8.1 ou superior
- Android 5.0+ (API 21+) / iOS 11.0+
- Câmera no dispositivo
- WhatsApp instalado

## 🚀 Instalação

1. Clone o repositório:
```bash
git clone https://github.com/hendelsantos/padrao-relatorio-app.git
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

## 📦 Dependências Principais

- `mobile_scanner: ^5.2.1` - Scanner de QR Code 
- `url_launcher: ^6.3.0` - Integração WhatsApp e Email
- `permission_handler: ^11.3.1` - Permissões de câmera
- `shared_preferences: ^2.2.2` - Armazenamento local

## 🔒 Permissões

### Android
- `CAMERA` - Para escanear QR codes
- `INTERNET` - Para abrir WhatsApp

### iOS
- Câmera - Configurada automaticamente pelo Flutter

## 📖 Como Usar

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

## 🏗️ Estrutura do Projeto

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

## 🤝 Desenvolvimento

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

Leia o [CONTRIBUTING.md](CONTRIBUTING.md) para mais detalhes sobre como contribuir.

## 📈 Changelog

Veja o [CHANGELOG.md](CHANGELOG.md) para histórico de versões e mudanças.

## 💬 Suporte

- 📋 [Issues](https://github.com/hendelsantos/padrao-relatorio-app/issues) - Reporte bugs ou sugira melhorias
- 💬 [Discussions](https://github.com/hendelsantos/padrao-relatorio-app/discussions) - Faça perguntas ou compartilhe ideias
- 📖 [Wiki](https://github.com/hendelsantos/padrao-relatorio-app/wiki) - Documentação adicional

## 📞 Contato

**Hendel Santos**  
🌐 [GitHub](https://github.com/hendelsantos)  
💼 Especialista em Django, Flutter e IA Generativa  
🚀 Focado em soluções práticas para manutenção industrial

---

💡 *"O maior ativo de uma empresa é o tempo - vamos otimizá-lo com tecnologia!"*

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
