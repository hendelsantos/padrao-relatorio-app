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
Peça
$peca
Local
$local''';
    
    // Adiciona ordem apenas se não estiver vazia
    if (ordem.isNotEmpty) {
      relatorio += '\n$ordem';
    }
    
    relatorio += '''

${retornoEstoque ? 'Sim' : 'Não'}
$restou
$codigoQr''';

    return relatorio;
  }
}
