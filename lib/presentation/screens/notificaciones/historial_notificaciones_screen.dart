import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/basedatos_local.dart';

class HistorialNotificacionesScreen extends StatefulWidget {
  const HistorialNotificacionesScreen({super.key});

  @override
  State<HistorialNotificacionesScreen> createState() =>
      _HistorialNotificacionesScreenState();
}

class _HistorialNotificacionesScreenState
    extends State<HistorialNotificacionesScreen> {
  Future<List<Map<String, dynamic>>> _cargarHistorial() async {
    final db = BaseDatosLocal.instance;
    return db.obtenerHistorialNotificaciones();
  }

  Color _colorPorNivel(String? nivel) {
    switch ((nivel ?? '').toLowerCase()) {
      case 'rojo':
      case 'roja':
        return Colors.red.shade700;
      case 'naranja':
        return Colors.orange.shade700;
      case 'verde':
        return Colors.green.shade700;
      default:
        return AppColors.guinda;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de alertas'),
        backgroundColor: AppColors.guinda,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cargarHistorial(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? const [];

          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Todavía no hay alertas guardadas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.body,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final titulo = item['titulo']?.toString() ?? 'Alerta';
              final mensaje = item['mensaje']?.toString() ?? 'Sin descripción';
              final nivel = item['nivel']?.toString() ?? 'verde';
              final fechaIso = item['fechaEmision']?.toString() ?? DateTime.now().toIso8601String();
              final fecha = DateTime.tryParse(fechaIso) ?? DateTime.now();

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _colorPorNivel(nivel).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            nivel.toUpperCase(),
                            style: TextStyle(
                              color: _colorPorNivel(nivel),
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${fecha.day}/${fecha.month}/${fecha.year} · ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: AppColors.body,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: AppColors.guinda,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      mensaje,
                      style: const TextStyle(
                        color: AppColors.ink,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
