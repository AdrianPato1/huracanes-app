import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/basedatos_local.dart';

class PantallaMochila extends StatefulWidget {
  const PantallaMochila({super.key});

  @override
  State<PantallaMochila> createState() => _PantallaMochilaState();
}

class _PantallaMochilaState extends State<PantallaMochila> {
  List<Map<String, dynamic>> _articulos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarArticulos();
  }

  // Leer los artículos desde SQLite
  Future<void> _cargarArticulos() async {
    final db = await BaseDatosLocal.instance.database;
    final datos = await db.query('mochila');
    setState(() {
      _articulos = datos;
      _cargando = false;
    });
  }

  // Actualizar el estado del checkbox en SQLite (0 a 1, o 1 a 0)
  Future<void> _toggleArticulo(String id, int estadoActual) async {
    final db = await BaseDatosLocal.instance.database;
    int nuevoEstado = estadoActual == 1 ? 0 : 1;
    
    await db.update(
      'mochila',
      {'marcado': nuevoEstado},
      where: 'id = ?',
      whereArgs: [id],
    );
    
    _cargarArticulos(); // Recargar la lista visualmente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Mochila de Emergencia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.guinda,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _articulos.length,
              itemBuilder: (context, index) {
                final item = _articulos[index];
                final bool estaMarcado = item['marcado'] == 1;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: estaMarcado ? Colors.green.withValues(alpha: 0.6) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      item['articulo'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: estaMarcado ? FontWeight.normal : FontWeight.w600,
                        decoration: estaMarcado ? TextDecoration.lineThrough : null,
                        color: estaMarcado ? Colors.grey : Colors.black87,
                      ),
                    ),
                    value: estaMarcado,
                    activeColor: AppColors.dorado,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (bool? valor) {
                      _toggleArticulo(item['id'], item['marcado']);
                    },
                  ),
                );
              },
            ),
    );
  }
}