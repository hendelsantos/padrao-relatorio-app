import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/inventario.dart';
import '../services/inventario_storage_service.dart';
import '../services/communication_service.dart';
import 'inventario_list_screen.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _catalogController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _materialController = TextEditingController();
  final _tipoController = TextEditingController();
  final _focController = TextEditingController();
  final _rfbController = TextEditingController();
  final _observacoesController = TextEditingController();
  
  bool _escaneando = false;
  int _itensColetados = 0;

  @override
  void initState() {
    super.initState();
    _carregarContador();
  }

  Future<void> _carregarContador() async {
    int count = await InventarioStorageService.contarItens();
    setState(() {
      _itensColetados = count;
    });
  }

  void _escanearQR() {
    setState(() => _escaneando = true);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Escanear Catalog'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? '';
                
                if (code.length == 17) {
                  setState(() {
                    _catalogController.text = code;
                    _escaneando = false;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Código deve ter exatamente 17 caracteres'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    ).then((_) {
      setState(() => _escaneando = false);
    });
  }

  Future<void> _salvarItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        final inventario = Inventario(
          catalog: _catalogController.text.trim(),
          quantidadeUnrestrict: _quantidadeController.text.trim(),
          material: _materialController.text.trim().isEmpty ? null : _materialController.text.trim(),
          tipo: _tipoController.text.trim().isEmpty ? null : _tipoController.text.trim(),
          foc: _focController.text.trim().isEmpty ? null : _focController.text.trim(),
          rfb: _rfbController.text.trim().isEmpty ? null : _rfbController.text.trim(),
          observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
        );

        await InventarioStorageService.salvarItem(inventario);
        
        // Limpar campos
        _catalogController.clear();
        _quantidadeController.clear();
        _materialController.clear();
        _tipoController.clear();
        _focController.clear();
        _rfbController.clear();
        _observacoesController.clear();
        
        // Atualizar contador
        await _carregarContador();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item salvo com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _enviarItemAtualPorWhatsApp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final inventario = Inventario(
          catalog: _catalogController.text.trim(),
          quantidadeUnrestrict: _quantidadeController.text.trim(),
          material: _materialController.text.trim().isEmpty ? null : _materialController.text.trim(),
          tipo: _tipoController.text.trim().isEmpty ? null : _tipoController.text.trim(),
          foc: _focController.text.trim().isEmpty ? null : _focController.text.trim(),
          rfb: _rfbController.text.trim().isEmpty ? null : _rfbController.text.trim(),
          observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
        );

        String mensagem = inventario.formatarParaWhatsApp();
        
        bool sucesso = await CommunicationService.enviarPorWhatsApp(mensagem);
        
        if (sucesso && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('WhatsApp aberto com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao abrir WhatsApp'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _enviarItemAtualPorEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        final inventario = Inventario(
          catalog: _catalogController.text.trim(),
          quantidadeUnrestrict: _quantidadeController.text.trim(),
          material: _materialController.text.trim().isEmpty ? null : _materialController.text.trim(),
          tipo: _tipoController.text.trim().isEmpty ? null : _tipoController.text.trim(),
          foc: _focController.text.trim().isEmpty ? null : _focController.text.trim(),
          rfb: _rfbController.text.trim().isEmpty ? null : _rfbController.text.trim(),
          observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
        );

        String mensagem = inventario.formatarParaWhatsApp(); // Reutiliza a mesma formatação
        String assunto = "Item de Inventário - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
        
        bool sucesso = await CommunicationService.enviarPorEmail(assunto, mensagem);
        
        if (sucesso && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App de email aberto com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro: Nenhum app de email encontrado. Instale Gmail, Outlook ou outro app de email.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário de Peças'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Contador de itens coletados
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_itensColetados itens',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Botão para ver lista
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InventarioListScreen(),
                ),
              ).then((_) => _carregarContador());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Catalog
              TextFormField(
                controller: _catalogController,
                maxLength: 17,
                decoration: InputDecoration(
                  labelText: 'Catalog *',
                  hintText: 'Digite ou escaneie 17 caracteres',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: _escaneando ? null : _escanearQR,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (value.trim().length != 17) {
                    return 'Deve ter exatamente 17 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Quantidade Unrestrict
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade Unrestrict *',
                  hintText: 'Digite a quantidade',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Material
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(
                  labelText: 'Material',
                  hintText: 'Tipo do material (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Tipo
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  hintText: 'Classificação da peça (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campos FOC e RFB lado a lado
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _focController,
                      decoration: const InputDecoration(
                        labelText: 'FOC',
                        hintText: 'Free of Charge',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rfbController,
                      decoration: const InputDecoration(
                        labelText: 'RFB',
                        hintText: 'Return for Billing',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campo Observações
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  hintText: 'Comentários adicionais (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Botões de ação
              Column(
                children: [
                  // Botão Salvar Item
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _salvarItem,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Item'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Botão Enviar Item Atual por WhatsApp
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _enviarItemAtualPorWhatsApp,
                      icon: const Icon(Icons.message),
                      label: const Text('Enviar Item por WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Botão Enviar Item Atual por Email
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _enviarItemAtualPorEmail,
                      icon: const Icon(Icons.email),
                      label: const Text('Enviar Item por Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Informações adicionais
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Informações',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('• Campos marcados com * são obrigatórios'),
                      const Text('• O catalog deve ter exatamente 17 caracteres'),
                      const Text('• Itens salvos podem ser enviados em lote'),
                      const Text('• Use o ícone de lista para ver itens coletados'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _catalogController.dispose();
    _quantidadeController.dispose();
    _materialController.dispose();
    _tipoController.dispose();
    _focController.dispose();
    _rfbController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
}
