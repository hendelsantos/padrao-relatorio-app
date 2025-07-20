# Como Testar o Aplicativo

## 📱 Executar no Emulador/Dispositivo

### Pré-requisitos
- Flutter instalado e configurado
- Emulador Android ou dispositivo físico conectado

### Comandos para Executar

1. **Verificar dispositivos disponíveis:**
```bash
flutter devices
```

2. **Executar em modo debug:**
```bash
flutter run
```

3. **Executar com hot reload ativo:**
```bash
flutter run --hot
```

## 🧪 Como Testar as Funcionalidades

### 1. Tela Principal (Home Screen)
- ✅ **Formulário de Relatório**: Todos os campos devem estar visíveis
- ✅ **Validação**: Campos obrigatórios devem mostrar erro quando vazios
- ✅ **Switch**: "Retorna ao estoque?" deve alternar entre Sim/Não
- ✅ **Botão Limpar**: Deve limpar todos os campos
- ✅ **Botão Escanear**: Deve abrir a câmera

### 2. Scanner QR Code
- ✅ **Permissões**: Deve solicitar acesso à câmera
- ✅ **Scanner**: Deve detectar códigos QR/códigos de barras
- ✅ **Validação 17 caracteres**: Deve aceitar apenas códigos com 17 caracteres
- ✅ **Lanterna**: Botão deve ligar/desligar flash
- ✅ **Trocar câmera**: Deve alternar entre câmeras frontal/traseira

### 3. Integração WhatsApp
- ✅ **Formato**: Relatório deve ser formatado corretamente
- ✅ **Envio**: Deve abrir WhatsApp com mensagem preenchida
- ✅ **Validação**: Só deve enviar se todos os campos obrigatórios estiverem preenchidos

## 📝 Exemplo de Código QR para Teste

Para testar, você pode gerar um código QR com exatamente 17 caracteres. Exemplos:
- `12345678901234567`
- `ABCDE12345FGHIJ67`
- `MNT2024123456789A`

## 🔧 Comandos Úteis de Desenvolvimento

```bash
# Verificar problemas no código
flutter analyze

# Executar testes
flutter test

# Compilar para release
flutter build apk --release

# Limpar cache
flutter clean

# Atualizar dependências
flutter pub get
```

## 📱 Exemplo de Relatório Gerado

```
*RELATÓRIO DE MANUTENÇÃO*

*Peça:* Parafuso M8 - 2 unidades
*Local:* Máquina de Solda - Setor A
*Ordem:* OS-2024-001
*Retorno estoque:* Sim
*Restou:* 3 unidades
*Código do QR Code:* 12345678901234567

_Relatório gerado automaticamente_
```

## 🚨 Possíveis Problemas e Soluções

### Problema: "WhatsApp não encontrado"
**Solução**: Instalar o WhatsApp no dispositivo de teste

### Problema: "Permissão da câmera negada"
**Solução**: Ir em Configurações > Aplicativos > [Nome do App] > Permissões > Câmera > Permitir

### Problema: "Scanner não detecta código"
**Solução**: 
- Verificar se o código tem exatamente 17 caracteres
- Melhorar iluminação
- Aproximar/afastar câmera do código

### Problema: Aplicativo não compila
**Solução**:
```bash
flutter clean
flutter pub get
flutter run
```
