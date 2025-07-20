import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inventario.dart';

class InventarioStorageService {
  static const String _inventarioListKey = 'inventario_list';
  
  // Salvar um item de inventário
  static Future<void> salvarItem(Inventario item) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Buscar lista existente
    List<Inventario> itens = await buscarTodos();
    
    // Adicionar novo item
    itens.add(item);
    
    // Converter para JSON
    List<String> itensJson = itens.map((item) => jsonEncode(item.toJson())).toList();
    
    // Salvar
    await prefs.setStringList(_inventarioListKey, itensJson);
  }
  
  // Buscar todos os itens
  static Future<List<Inventario>> buscarTodos() async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String>? itensJson = prefs.getStringList(_inventarioListKey);
    
    if (itensJson == null || itensJson.isEmpty) return [];
    
    return itensJson.map((json) {
      Map<String, dynamic> map = jsonDecode(json);
      return Inventario.fromJson(map);
    }).toList();
  }
  
  // Limpar todos os itens
  static Future<void> limparTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inventarioListKey);
  }
  
  // Remover item específico por índice
  static Future<void> removerItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<Inventario> itens = await buscarTodos();
    
    if (index >= 0 && index < itens.length) {
      itens.removeAt(index);
      
      List<String> itensJson = itens.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList(_inventarioListKey, itensJson);
    }
  }
  
  // Contar itens salvos
  static Future<int> contarItens() async {
    List<Inventario> itens = await buscarTodos();
    return itens.length;
  }
  
  // Formatar todos os itens para envio
  static Future<String> formatarTodosParaEnvio() async {
    List<Inventario> itens = await buscarTodos();
    
    if (itens.isEmpty) {
      return "Nenhum item de inventário coletado.";
    }
    
    StringBuffer relatorio = StringBuffer();
    relatorio.writeln("📦 *RELATÓRIO DE INVENTÁRIO DE PEÇAS*");
    relatorio.writeln("=" * 40);
    relatorio.writeln("📅 Data: ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}");
    relatorio.writeln("📋 Total de itens: ${itens.length}");
    relatorio.writeln();
    
    for (int i = 0; i < itens.length; i++) {
      relatorio.writeln("*Item ${i + 1}:*");
      relatorio.write(itens[i].formatarParaWhatsApp());
      relatorio.writeln();
      relatorio.writeln("-" * 30);
    }
    
    relatorio.writeln();
    relatorio.writeln("🤖 *Relatório gerado automaticamente*");
    relatorio.writeln("📱 *App: Relatório de Peças v1.2.1*");
    
    return relatorio.toString();
  }
}
