import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/inventario.dart';
import '../services/inventario_storage_service.dart';
import 'inventario_list_screen.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen>
    with TickerProviderStateMixin {
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
  bool _catalogValidado = false;
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  // Listas para autocomplete
  final List<String> _materiaisComuns = [
    'Aço Inoxidável',
    'Ferro Fundido',
    'Alumínio',
    'Bronze',
    'Latão',
    'Plástico PVC',
    'Borracha',
    'Cerâmica',
    'Vidro',
    'Madeira'
  ];

  final List<String> _tiposComuns = [
    'Parafuso',
    'Porca',
    'Arruela',
    'Vedação',
    'Rolamento',
    'Filtro',
    'Válvula',
    'Sensor',
    'Motor',
    'Bomba'
  ];

  @override
  void initState() {
    super.initState();
    _carregarContador();

    // Inicializar animação para o scanner
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanAnimationController,
      curve: Curves.easeInOut,
    ));

    // Validação em tempo real do catalog
    _catalogController.addListener(_validarCatalog);
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _catalogController.dispose();
    _quantidadeController.dispose();
    _materialController.dispose();
    _tipoController.dispose();
    _focController.dispose();
    _rfbController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _validarCatalog() {
    final text = _catalogController.text;
    setState(() {
      _catalogValidado = text.length == 17;
    });
  }

  Future<void> _carregarContador() async {
    int count = await InventarioStorageService.contarItens();
    setState(() {
      _itensColetados = count;
    });
  }

  void _escanearQR() {
    setState(() => _escaneando = true);
    _scanAnimationController.repeat();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Escanear Catalog'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null &&
                        barcode.rawValue!.length == 17) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _catalogController.text = barcode.rawValue!;
                        _escaneando = false;
                      });
                      _scanAnimationController.stop();
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Catalog: ${barcode.rawValue}'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                  }
                },
              ),
              // Overlay com instruções
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _scanAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 0.8 + (_scanAnimation.value * 0.4),
                                      child: Icon(
                                        Icons.qr_code_scanner,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Posicione o código QR no centro',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'O código deve ter 17 caracteres',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      setState(() => _escaneando = false);
      _scanAnimationController.stop();
    });
  }

  void _inserirManualmente() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Inserir Catalog Manualmente'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Catalog (17 dígitos)',
              hintText: '12345678901234567',
            ),
            maxLength: 17,
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.length == 17) {
                  setState(() {
                    _catalogController.text = controller.text;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('O catalog deve ter exatamente 17 dígitos'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required String label,
    required List<String> options,
    String? Function(String?)? validator,
    bool required = false,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        textEditingController.text = controller.text;
        textEditingController.addListener(() {
          controller.text = textEditingController.text;
        });
        
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
          ),
          validator: validator,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _salvarItem() async {
    if (_formKey.currentState!.validate()) {
      final inventario = Inventario(
        catalog: _catalogController.text,
        quantidadeUnrestrict: _quantidadeController.text,
        material: _materialController.text,
        tipo: _tipoController.text,
        foc: _focController.text,
        rfb: _rfbController.text,
        observacoes: _observacoesController.text,
      );

      await InventarioStorageService.salvarItem(inventario);
      await _carregarContador();
      _limparFormulario();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.save, color: Colors.white),
                SizedBox(width: 8),
                Text('Item salvo com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _limparFormulario() {
    _catalogController.clear();
    _quantidadeController.clear();
    _materialController.clear();
    _tipoController.clear();
    _focController.clear();
    _rfbController.clear();
    _observacoesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
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
      body: Column(
        children: [
          // Card de estatísticas
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Itens Coletados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$_itensColetados',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Formulário
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo Catalog com scanner
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _catalogController,
                            decoration: InputDecoration(
                              labelText: 'Catalog *',
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.qr_code,
                                color: _catalogValidado
                                    ? Colors.green
                                    : Theme.of(context).iconTheme.color,
                              ),
                              suffixIcon: _catalogValidado
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : null,
                            ),
                            maxLength: 17,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Catalog é obrigatório';
                              }
                              if (value!.length != 17) {
                                return 'Catalog deve ter 17 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: _escaneando ? null : _escanearQR,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(12),
                              ),
                              child: _escaneando
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Icons.qr_code_scanner),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _inserirManualmente,
                              child: const Text('Manual',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quantidade
                    TextFormField(
                      controller: _quantidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Quantidade é obrigatória';
                        }
                        if (int.tryParse(value!) == null) {
                          return 'Digite um número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Material com autocomplete
                    _buildAutocompleteField(
                      controller: _materialController,
                      label: 'Material',
                      options: _materiaisComuns,
                      required: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Material é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tipo com autocomplete
                    _buildAutocompleteField(
                      controller: _tipoController,
                      label: 'Tipo',
                      options: _tiposComuns,
                      required: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Tipo é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // FOC
                    TextFormField(
                      controller: _focController,
                      decoration: const InputDecoration(
                        labelText: 'FOC',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // RFB
                    TextFormField(
                      controller: _rfbController,
                      decoration: const InputDecoration(
                        labelText: 'RFB',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.receipt),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Observações
                    TextFormField(
                      controller: _observacoesController,
                      decoration: const InputDecoration(
                        labelText: 'Observações',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note_alt),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Botões
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _salvarItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save),
                                SizedBox(width: 8),
                                Text('Salvar Item'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _limparFormulario,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.clear),
                                SizedBox(width: 8),
                                Text('Limpar'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
