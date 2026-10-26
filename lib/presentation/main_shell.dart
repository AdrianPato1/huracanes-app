import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'widgets/app_bottom_nav.dart';
import 'screens/inicio/home_screen.dart';
import 'screens/refugios/pantalla_mapa.dart';
import 'screens/guias/pantalla_guias.dart';
import 'screens/perfil/pantalla_perfil.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _irARefugios() {
    setState(() {
      _index = 1; // Pestaña del Mapa de Refugios
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onBuscarRefugio: _irARefugios),
      const PantallaMapa(),
      const PantallaGuias(),
      const PantallaPerfil(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _index,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
