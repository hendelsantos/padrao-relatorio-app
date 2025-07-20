class Inventario {
  final String catalog;
  final String quantidadeUnrestrict;
  final String? material;
  final String? tipo;
  final String? foc;
  final String? rfb;
  final String? observacoes;

  Inventario({
    required this.catalog,
    required this.quantidadeUnrestrict,
    this.material,
    this.tipo,
    this.foc,
    this.rfb,
    this.observacoes,
  });

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'catalog': catalog,
      'quantidadeUnrestrict': quantidadeUnrestrict,
      'material': material,
      'tipo': tipo,
      'foc': foc,
      'rfb': rfb,
      'observacoes': observacoes,
    };
  }

  // Criar a partir de JSON
  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      catalog: json['catalog'] ?? '',
      quantidadeUnrestrict: json['quantidadeUnrestrict'] ?? '',
      material: json['material'],
      tipo: json['tipo'],
      foc: json['foc'],
      rfb: json['rfb'],
      observacoes: json['observacoes'],
    );
  }

  // Formatar para WhatsApp
  String formatarParaWhatsApp() {
    StringBuffer buffer = StringBuffer();
    
    buffer.writeln('📦 *ITEM DE INVENTÁRIO*');
    buffer.writeln('=' * 25);
    buffer.writeln('🏷️ *Catalog:* $catalog');
    buffer.writeln('📊 *Quantidade Unrestrict:* $quantidadeUnrestrict');
    
    if (material != null && material!.isNotEmpty) {
      buffer.writeln('🧱 *Material:* $material');
    }
    
    if (tipo != null && tipo!.isNotEmpty) {
      buffer.writeln('📋 *Tipo:* $tipo');
    }
    
    if (foc != null && foc!.isNotEmpty) {
      buffer.writeln('🆓 *FOC:* $foc');
    }
    
    if (rfb != null && rfb!.isNotEmpty) {
      buffer.writeln('↩️ *RFB:* $rfb');
    }
    
    if (observacoes != null && observacoes!.isNotEmpty) {
      buffer.writeln('📝 *Observações:* $observacoes');
    }
    
    buffer.writeln();
    buffer.writeln('📅 *Data:* ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}');
    buffer.writeln('🕒 *Hora:* ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}');
    buffer.writeln();
    buffer.writeln('🤖 *Relatório gerado automaticamente*');
    buffer.writeln('📱 *App: Relatório de Peças v1.3.0*');
    
    return buffer.toString();
  }
}
