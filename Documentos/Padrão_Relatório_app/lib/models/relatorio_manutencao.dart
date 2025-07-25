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
    String mensagem = 'Peça\n';
    mensagem += '$peca\n';
    mensagem += '$local\n';
    mensagem += '$ordem\n';
    mensagem += '${retornoEstoque ? 'Sim' : 'Não'}\n';
    mensagem += '$restou\n';
    mensagem += '$codigoQr';

    return mensagem;
  }
}
