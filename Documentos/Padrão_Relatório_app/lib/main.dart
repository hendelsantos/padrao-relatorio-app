import 'package:flutter/material.dart';
import 'screens/menu_principal_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relatório de Manutenção',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MenuPrincipalScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
