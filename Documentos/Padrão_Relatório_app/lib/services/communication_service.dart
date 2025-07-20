import 'package:url_launcher/url_launcher.dart';
import 'inventario_storage_service.dart';

class CommunicationService {
  
  // Enviar por WhatsApp
  static Future<bool> enviarPorWhatsApp(String mensagem, {String? numeroTelefone}) async {
    try {
      String url;
      
      if (numeroTelefone != null && numeroTelefone.isNotEmpty) {
        // Enviar para número específico
        url = 'https://wa.me/$numeroTelefone?text=${Uri.encodeComponent(mensagem)}';
      } else {
        // Abrir WhatsApp para escolher contato
        url = 'https://wa.me/?text=${Uri.encodeComponent(mensagem)}';
      }
      
      final Uri uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao enviar por WhatsApp: $e');
      return false;
    }
  }
  
  // Enviar por Email
  static Future<bool> enviarPorEmail(String assunto, String corpo, {String? emailDestinatario}) async {
    try {
      String url = 'mailto:';
      
      if (emailDestinatario != null && emailDestinatario.isNotEmpty) {
        url += emailDestinatario;
      }
      
      url += '?subject=${Uri.encodeComponent(assunto)}&body=${Uri.encodeComponent(corpo)}';
      
      final Uri uri = Uri.parse(url);
      print('Tentando abrir URL de email: $url');
      
      // Primeiro tenta verificar se pode lançar a URL
      bool canLaunch = await canLaunchUrl(uri);
      print('canLaunchUrl retornou: $canLaunch');
      
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        // Tenta diferentes modos de lançamento
        print('Tentando diferentes modos de lançamento...');
        
        // Modo 1: Tenta PlatformDefault
        try {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
          return true;
        } catch (e1) {
          print('Erro no modo platformDefault: $e1');
        }
        
        // Modo 2: Tenta InAppWebView
        try {
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
          return true;
        } catch (e2) {
          print('Erro no modo inAppWebView: $e2');
        }
        
        // Modo 3: Tenta URL específica do Gmail (fallback)
        try {
          String gmailUrl = 'https://mail.google.com/mail/?view=cm&fs=1&to=';
          if (emailDestinatario != null && emailDestinatario.isNotEmpty) {
            gmailUrl += emailDestinatario;
          }
          gmailUrl += '&su=${Uri.encodeComponent(assunto)}&body=${Uri.encodeComponent(corpo)}';
          
          final gmailUri = Uri.parse(gmailUrl);
          await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
          return true;
        } catch (e3) {
          print('Erro ao tentar Gmail web: $e3');
        }
        
        return false;
      }
    } catch (e) {
      print('Erro ao enviar por Email: $e');
      return false;
    }
  }
  
  // Enviar relatório completo por WhatsApp
  static Future<bool> enviarRelatorioCompleto({String? numeroTelefone}) async {
    try {
      String relatorio = await InventarioStorageService.formatarTodosParaEnvio();
      return await enviarPorWhatsApp(relatorio, numeroTelefone: numeroTelefone);
    } catch (e) {
      print('Erro ao enviar relatório completo: $e');
      return false;
    }
  }
  
  // Enviar relatório completo por Email
  static Future<bool> enviarRelatorioCompletoPorEmail({String? emailDestinatario}) async {
    try {
      String relatorio = await InventarioStorageService.formatarTodosParaEnvio();
      
      String assunto = "Relatório de Inventário de Peças - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      
      return await enviarPorEmail(assunto, relatorio, emailDestinatario: emailDestinatario);
    } catch (e) {
      print('Erro ao enviar relatório por email: $e');
      return false;
    }
  }
  
  // Verificar se WhatsApp está instalado
  static Future<bool> whatsappInstalado() async {
    try {
      final Uri uri = Uri.parse('https://wa.me/');
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }
  
  // Verificar se app de email está disponível
  static Future<bool> emailDisponivel() async {
    try {
      final Uri uri = Uri.parse('mailto:');
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }
}
