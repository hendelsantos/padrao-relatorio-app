import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Aplicativo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com ícone
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.engineering,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Relatório de Peças',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versão 1.2.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Seção: Objetivo Principal
            _buildSection(
              icon: Icons.flag,
              title: 'Objetivo Principal',
              content: 'Este aplicativo foi desenvolvido para padronizar o relatório de peças no WhatsApp, '
                      'para o bot sumarizar e fazer a mágica. '
                      'Com o formato padronizado, facilita o processamento automático das informações.',
            ),

            const SizedBox(height: 24),

            // Seção: Desenvolvedor
            _buildSection(
              icon: Icons.person,
              title: 'Desenvolvido por',
              content: 'Hendel\n\nDesenvolvimento focado em facilitar o trabalho dos técnicos de manutenção '
                      'e automatizar o processamento de relatórios.',
            ),

            const SizedBox(height: 24),

            // Seção: Funcionalidades
            _buildSection(
              icon: Icons.featured_play_list,
              title: 'Principais Funcionalidades',
              content: '• Scanner de QR Code/Código de Barras (17 caracteres)\n'
                      '• Formulário padronizado de relatório\n'
                      '• Validação automática de dados\n'
                      '• Integração direta com WhatsApp\n'
                      '• Funcionamento 100% offline\n'
                      '• Interface intuitiva e responsiva',
            ),

            const SizedBox(height: 24),

            // Seção: Contato
            _buildSection(
              icon: Icons.contact_support,
              title: 'Dúvidas ou Sugestões?',
              content: 'Entre em contato conosco:\n\n'
                      '• Hendel - Desenvolvedor\n'
                      '• Ederson - Suporte\n\n'
                      'Estamos sempre disponíveis para melhorar sua experiência!',
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Desenvolvido com dedicação para facilitar\no trabalho dos técnicos de manutenção',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
