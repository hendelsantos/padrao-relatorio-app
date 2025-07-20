class RelatorioManutencao {
  String peca;
  String local;
  String ordem;
  bool retornoEstoque;
  String restou;
  String codigoQr;

  RelatorioManutencao({
    required this.peca,
    required this.local,
    this.ordem = '',
    required this.retornoEstoque,
    required this.restou,
    required this.codigoQr,
  });

  String formatarParaWhatsApp() {
    String relatorio = '''
🔧 *RELATÓRIO DE PEÇAS*
═══════════════════════

📦 *Peça:* $peca
📍 *Local:* $local
📋 *Ordem:* ${ordem.isEmpty ? 'Não informado' : ordem}
🔄 *Retorno estoque:* ${retornoEstoque ? 'Sim' : 'Não'}
📊 *Restou:* $restou
🔍 *Código do QR Code:* $codigoQr

═══════════════════════
📅 *Data:* ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}
🕐 *Hora:* ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}

✅ *Relatório gerado automaticamente*
*App Padrão Relatório - Hendel*''';

    return relatorio;
  }
}
