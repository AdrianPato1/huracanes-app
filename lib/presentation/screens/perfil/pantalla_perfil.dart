import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../notificaciones/historial_notificaciones_screen.dart';

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.guinda,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // CABECERA DEL USUARIO
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.guinda,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ciudadano Cancún',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Usuario Registrado',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // SECCIÓN 1: AJUSTES Y NOTIFICACIONES
          const Text(
            'Configuración de Alertas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notificaciones Críticas'),
                  subtitle: const Text('Alertas sonoras en caso de peligro alto'),
                  value: true,
                  activeThumbColor: AppColors.guinda,
                  onChanged: (bool value) {},
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Ubicación en segundo plano'),
                  subtitle: const Text('Para avisarte si entras a una zona de riesgo'),
                  value: true,
                  activeThumbColor: AppColors.guinda,
                  onChanged: (bool value) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SECCIÓN 2: INFORMACIÓN INSTITUCIONAL
          const Text(
            'Institucional',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.guinda),
                  title: Text('Acerca de la Aplicación'),
                  subtitle: Text('Versión 1.0.0 - Protección Civil Cancún'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history_toggle_off_rounded, color: AppColors.guinda),
                  title: const Text('Historial de Alertas'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HistorialNotificacionesScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.policy_outlined, color: AppColors.guinda),
                  title: const Text('Aviso de Privacidad'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}