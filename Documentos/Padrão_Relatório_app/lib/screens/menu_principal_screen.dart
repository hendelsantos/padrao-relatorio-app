import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/relatorio_manutencao.dart';
import 'qr_scanner_screen.dart';
import 'sobre_page.dart';
import 'inventario_screen.dart';

class MenuPrincipalScreen extends StatefulWidget {
  const MenuPrincipalScreen({super.key});

  @override
  State<MenuPrincipalScreen> createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const InventarioScreen(),
    const SobrePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Footer com desenvolvedor
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Desenvolvido por ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  '</>',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Text(
                  'Hendel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Navigation Bar
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: 'Relatório de Peças',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Inventário',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'Sobre',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Renomeando a HomeScreen original para HomePage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _pecaController = TextEditingController();
  final _localController = TextEditingController();
  final _ordemController = TextEditingController();
  final _restouController = TextEditingController();
  final _codigoQrController = TextEditingController();
  
  bool _retornoEstoque = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _pecaController.dispose();
    _localController.dispose();
    _ordemController.dispose();
    _restouController.dispose();
    _codigoQrController.dispose();
    super.dispose();
  }

  Future<void> _escanearQrCode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );
    
    if (result != null && result.isNotEmpty) {
      setState(() {
        _codigoQrController.text = result;
      });
    }
  }

  Future<void> _enviarParaWhatsApp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final relatorio = RelatorioManutencao(
        peca: _pecaController.text.trim(),
        local: _localController.text.trim(),
        ordem: _ordemController.text.trim(),
        retornoEstoque: _retornoEstoque,
        restou: _restouController.text.trim(),
        codigoQr: _codigoQrController.text.trim(),
      );

      final mensagem = relatorio.formatarParaWhatsApp();
      final url = 'whatsapp://send?text=${Uri.encodeComponent(mensagem)}';
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
        
        // Mostrar dialog de sucesso
        if (mounted) {
          _mostrarDialogSucesso();
        }
      } else {
        if (mounted) {
          _mostrarErro('WhatsApp não encontrado. Verifique se o aplicativo está instalado.');
        }
      }
    } catch (e) {
      if (mounted) {
        _mostrarErro('Erro ao enviar relatório: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarDialogSucesso() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('Sucesso!'),
          content: const Text('Relatório enviado para o WhatsApp com sucesso.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _limparFormulario();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    _pecaController.clear();
    _localController.clear();
    _ordemController.clear();
    _restouController.clear();
    _codigoQrController.clear();
    setState(() {
      _retornoEstoque = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relatório de Peças',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Código QR
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Código QR *',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _codigoQrController,
                              decoration: const InputDecoration(
                                labelText: 'Código QR (17 caracteres)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.qr_code),
                              ),
                              maxLength: 17,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Código QR é obrigatório';
                                }
                                if (value.trim().length != 17) {
                                  return 'Código deve ter exatamente 17 caracteres';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _escanearQrCode,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Escanear'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Peça
              TextFormField(
                controller: _pecaController,
                decoration: const InputDecoration(
                  labelText: 'Peça (quantidade) *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.build),
                  helperText: 'Digite somente a quantidade',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Peça é obrigatória';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Local
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(
                  labelText: 'Local *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                  helperText: 'Local onde a peça foi utilizada',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Local é obrigatório';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Ordem
              TextFormField(
                controller: _ordemController,
                decoration: const InputDecoration(
                  labelText: 'Ordem (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment),
                  helperText: 'Número da ordem de serviço, se houver',
                ),
              ),

              const SizedBox(height: 16),

              // Restou
              TextFormField(
                controller: _restouController,
                decoration: const InputDecoration(
                  labelText: 'Restou *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                  helperText: 'Quantidade que restou da peça',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Quantidade restante é obrigatória';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Retorno ao estoque
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.store),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Retorna ao estoque?',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Switch(
                        value: _retornoEstoque,
                        onChanged: (value) {
                          setState(() {
                            _retornoEstoque = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _limparFormulario,
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _enviarParaWhatsApp,
                      icon: _isLoading 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isLoading ? 'Enviando...' : 'Enviar WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
