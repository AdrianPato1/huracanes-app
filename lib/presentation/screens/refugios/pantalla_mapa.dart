import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/basedatos_local.dart';
import 'refugio_detalle_screen.dart';

class PantallaMapa extends StatefulWidget {
  const PantallaMapa({super.key});

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa> {
  final TextEditingController _busquedaController = TextEditingController();

  Future<List<Map<String, dynamic>>> _cargarRefugios() async {
    final db = BaseDatosLocal.instance;
    await db.cargarRefugiosDemostracionSiHaceFalta();
    final refugios = await db.obtenerRefugiosLocales();
    final texto = _busquedaController.text.trim().toLowerCase();

    return refugios.where((refugio) {
      final nombre = (refugio['nombre'] ?? '').toString().toLowerCase();
      final direccion = (refugio['direccion'] ?? '').toString().toLowerCase();
      final coincideBusqueda = texto.isEmpty || nombre.contains(texto) || direccion.contains(texto);
      return coincideBusqueda;
    }).toList();
  }

  double _distanciaKm(double lat1, double lng1, double lat2, double lng2) {
    final distance = const Distance();
    return distance.as(LengthUnit.Kilometer, LatLng(lat1, lng1), LatLng(lat2, lng2));
  }

  void _abrirDetalle(Map<String, dynamic> refugio) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RefugioDetalleScreen(
          id: refugio['id']?.toString() ?? '',
          nombre: refugio['nombre']?.toString() ?? 'Refugio',
          direccion: refugio['direccion']?.toString(),
          capacidadActual: int.tryParse(refugio['capacidadActual']?.toString() ?? '0'),
          capacidad: int.tryParse(refugio['capacidad']?.toString() ?? '0'),
          aceptaMascotas: refugio['aceptaMascotas'] == 1 || refugio['aceptaMascotas'] == true,
          latitud: refugio['latitud'] is num ? (refugio['latitud'] as num).toDouble() : null,
          longitud: refugio['longitud'] is num ? (refugio['longitud'] as num).toDouble() : null,
          estaAbierto: refugio['estaAbierto'] == 1 || refugio['estaAbierto'] == true,
          photoUrl: null,
        ),
      ),
    );
  }

  Future<void> _trazarRuta(Map<String, dynamic> refugio) async {
    final lat = refugio['latitud'] is num ? (refugio['latitud'] as num).toDouble() : null;
    final lng = refugio['longitud'] is num ? (refugio['longitud'] as num).toDouble() : null;

    if (lat == null || lng == null) return;

    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la ruta.')),
      );
    }
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const centroCancun = LatLng(21.1619, -86.8252);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cargarRefugios(),
        builder: (context, snapshot) {
          final refugios = snapshot.data ?? const [];
          final refugioSeleccionado = refugios.isEmpty
              ? null
              : refugios.reduce((actual, siguiente) {
                  final actualLat = actual['latitud'] is num ? (actual['latitud'] as num).toDouble() : centroCancun.latitude;
                  final actualLng = actual['longitud'] is num ? (actual['longitud'] as num).toDouble() : centroCancun.longitude;
                  final sigLat = siguiente['latitud'] is num ? (siguiente['latitud'] as num).toDouble() : centroCancun.latitude;
                  final sigLng = siguiente['longitud'] is num ? (siguiente['longitud'] as num).toDouble() : centroCancun.longitude;

                  final distActual = _distanciaKm(centroCancun.latitude, centroCancun.longitude, actualLat, actualLng);
                  final distSiguiente = _distanciaKm(centroCancun.latitude, centroCancun.longitude, sigLat, sigLng);

                  return distActual <= distSiguiente ? actual : siguiente;
                });

          final markers = refugios.map((refugio) {
            final lat = refugio['latitud'] is num ? (refugio['latitud'] as num).toDouble() : centroCancun.latitude;
            final lng = refugio['longitud'] is num ? (refugio['longitud'] as num).toDouble() : centroCancun.longitude;
            final estaAbierto = refugio['estaAbierto'] == 1 || refugio['estaAbierto'] == true;
            final esSeleccionado = refugioSeleccionado != null && refugio['id'] == refugioSeleccionado['id'];

            return Marker(
              point: LatLng(lat, lng),
              width: esSeleccionado ? 52 : 42,
              height: esSeleccionado ? 52 : 42,
              child: GestureDetector(
                onTap: () => _abrirDetalle(refugio),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: esSeleccionado ? 52 : 42,
                  height: esSeleccionado ? 52 : 42,
                  decoration: BoxDecoration(
                    color: esSeleccionado ? AppColors.guinda : (estaAbierto ? const Color(0xFF3CB371) : Colors.grey),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }).toList();

          final distanciaSeleccionada = refugioSeleccionado == null
              ? 0.0
              : _distanciaKm(
                  centroCancun.latitude,
                  centroCancun.longitude,
                  (refugioSeleccionado['latitud'] is num ? (refugioSeleccionado['latitud'] as num).toDouble() : centroCancun.latitude),
                  (refugioSeleccionado['longitud'] is num ? (refugioSeleccionado['longitud'] as num).toDouble() : centroCancun.longitude),
                );

          final capacidadActual = refugioSeleccionado != null ? (refugioSeleccionado['capacidadActual'] is num ? (refugioSeleccionado['capacidadActual'] as num).toInt() : 0) : 0;
          final capacidadMaxima = refugioSeleccionado != null ? (refugioSeleccionado['capacidad'] is num ? (refugioSeleccionado['capacidad'] as num).toInt() : 0) : 0;
          final porcentaje = capacidadMaxima > 0 ? ((capacidadActual / capacidadMaxima) * 100).clamp(0, 100).toDouble() : 0.0;
          final aceptaMascotas = refugioSeleccionado != null && (refugioSeleccionado['aceptaMascotas'] == 1 || refugioSeleccionado['aceptaMascotas'] == true);
          final estaAbierto = refugioSeleccionado != null && (refugioSeleccionado['estaAbierto'] == 1 || refugioSeleccionado['estaAbierto'] == true);

          return Stack(
            children: [
              FlutterMap(
                options: const MapOptions(
                  initialCenter: centroCancun,
                  initialZoom: 12.5,
                  interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.alerta_cancun_app',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.guinda, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _busquedaController,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: 'Refugios cercanos',
                              hintStyle: TextStyle(
                                color: AppColors.body,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAE8E4),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '${refugios.length} activos',
                            style: const TextStyle(
                              color: AppColors.guinda,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: refugioSeleccionado == null
                      ? const SizedBox(
                          height: 140,
                          child: Center(
                            child: Text(
                              'No hay refugios disponibles',
                              style: TextStyle(
                                color: AppColors.body,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3E4E7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'REFUGIO MÁS CERCANO',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.7,
                                    color: AppColors.guinda,
                                  ),
                                ),
                                Text(
                                  '${distanciaSeleccionada.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.guinda,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (refugioSeleccionado['nombre'] ?? 'Refugio').toString(),
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColors.guinda,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$capacidadActual/$capacidadMaxima personas',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.guinda,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${porcentaje.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.guinda,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: (porcentaje / 100).clamp(0.0, 1.0),
                                minHeight: 10,
                                backgroundColor: const Color(0xFFE9E6E3),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.guinda),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (aceptaMascotas)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDAF2E2),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                                    child: const Row(
                                      children: [
                                        Icon(Icons.pets, size: 16, color: Color(0xFF1A7D4A)),
                                        SizedBox(width: 6),
                                        Text(
                                          'Acepta Mascotas',
                                          style: TextStyle(
                                            color: Color(0xFF1A7D4A),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _trazarRuta(refugioSeleccionado),
                                    icon: const Icon(Icons.route, size: 22),
                                    label: const Text(
                                      'Trazar Ruta',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.guinda,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: estaAbierto ? Colors.green : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      estaAbierto ? 'Disponible' : 'Lleno',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: AppColors.guinda,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () => _abrirDetalle(refugioSeleccionado),
                                  child: const Text(
                                    'Ver los 11 restantes',
                                    style: TextStyle(
                                      color: AppColors.guinda,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
