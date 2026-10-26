import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../mochila/pantalla_mochila.dart';
import 'package:url_launcher/url_launcher.dart';

class PantallaGuias extends StatelessWidget {
  const PantallaGuias({super.key});

  // Función para abrir el marcador del teléfono
  Future<void> _llamarNumero(String numero) async {
    final Uri url = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Guías y Emergencias', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // SECCIÓN 1: CONTACTOS DE EMERGENCIA
          const Text(
            'Teléfonos de Emergencia',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _llamarNumero('911'),
                  icon: const Icon(Icons.emergency, color: Colors.white),
                  label: const Text('911 Emergencias', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _llamarNumero('9988816500'), // Número ficticio o real de PC Cancún
                  icon: const Icon(Icons.shield, color: Colors.white),
                  label: const Text('Protección Civil', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.guinda,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // SECCIÓN 2: ACCESO A LA MOCHILA DE EMERGENCIA
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.backpack, color: AppColors.guinda, size: 40),
              title: const Text('Mochila de Emergencia', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Revisa los artículos esenciales para tu familia'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaMochila()),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // SECCIÓN 3: GUÍA ANTES, DURANTE Y DESPUÉS (ACORDEÓN)
          const Text(
            'Protocolo en Huracanes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ExpansionTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.blue),
              title: Text('Antes del Huracán (Prevención)', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '• Limpia azoteas, desagües y coladeras.\n'
                    '• Protege ventanas con cinta en forma de X o tablones.\n'
                    '• Ten lista tu Mochila de Emergencia.\n'
                    '• Ubica el refugio temporal más cercano a tu domicilio.',
                    style: TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ExpansionTile(
              leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
              title: Text('Durante el Huracán (Acción)', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '• Conserva la calma y mantén informada a la familia.\n'
                    '• Desconecta aparatos eléctricos y corta el suministro de gas.\n'
                    '• Aléjate de puertas y ventanas de cristal.\n'
                    '• Si el ojo del huracán pasa por tu zona, no salgas; la calma es temporal.',
                    style: TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ExpansionTile(
              leading: Icon(Icons.health_and_safety_outlined, color: Colors.green),
              title: Text('Después del Huracán (Recuperación)', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '• Sigue las instrucciones de las autoridades en medios oficiales.\n'
                    '• Revisa las instalaciones de luz y gas antes de encender algo.\n'
                    '• Evita pisar cables caídos o zonas inundadas.\n'
                    '• Consume solo agua potable y alimentos enlatados limpios.',
                    style: TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}