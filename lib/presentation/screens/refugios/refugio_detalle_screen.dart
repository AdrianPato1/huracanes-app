import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

Uri buildRefugioMapUri({
  required double latitude,
  required double longitude,
}) {
  final latText = latitude.toString();
  final lonText = longitude.toString();

  return Uri.parse(
    'https://www.openstreetmap.org/?mlat=$latText&mlon=$lonText#map=16/$latText/$lonText',
  );
}

class RefugioDetalleScreen extends StatelessWidget {
  const RefugioDetalleScreen({
    super.key,
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.capacidadActual,
    required this.capacidad,
    required this.aceptaMascotas,
    required this.latitud,
    required this.longitud,
    required this.estaAbierto,
    this.photoUrl,
  });

  final String id;
  final String nombre;
  final String? direccion;
  final int? capacidadActual;
  final int? capacidad;
  final bool aceptaMascotas;
  final double? latitud;
  final double? longitud;
  final bool estaAbierto;
  final String? photoUrl;

  Future<void> _openMap(BuildContext context) async {
    final latitude = latitud ?? 21.1619;
    final longitude = longitud ?? -86.8252;

    final candidates = <Uri>[
      buildRefugioMapUri(latitude: latitude, longitude: longitude),
      Uri.parse('https://maps.apple.com/?daddr=$latitude,$longitude'),
      Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude'),
    ];

    for (final uri in candidates) {
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (launched) {
          return;
        }
      } catch (_) {
        // continúa con la siguiente opción de apertura
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la ubicación del refugio.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = photoUrl?.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del refugio'),
        backgroundColor: AppColors.guinda,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: SizedBox(
                width: double.infinity,
                height: 210,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFFE8E3E1),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (_, _, _) => _FotoRefugioFallback(nombre: nombre),
                      )
                    : _FotoRefugioFallback(nombre: nombre),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
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
                          color: estaAbierto ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          estaAbierto ? 'Abierto' : 'Cerrado',
                          style: TextStyle(
                            color: estaAbierto ? Colors.green.shade800 : Colors.red.shade800,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        aceptaMascotas ? Icons.pets : Icons.pets_outlined,
                        color: aceptaMascotas ? AppColors.guinda : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nombre,
                    style: const TextStyle(
                      color: AppColors.guinda,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.guinda),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          direccion ?? 'Dirección no disponible',
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _InfoRow(
                    icon: Icons.people_alt_rounded,
                    label: 'Capacidad actual',
                    value: '${capacidadActual ?? 0} / ${capacidad ?? 0} personas',
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.pets,
                    label: 'Mascotas',
                    value: aceptaMascotas ? 'Sí aceptan mascotas' : 'No aceptan mascotas',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _openMap(context),
                icon: const Icon(Icons.directions),
                label: const Text('Abrir en mapa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.guinda,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al mapa'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.guinda,
                  side: const BorderSide(color: AppColors.guinda),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FotoRefugioFallback extends StatelessWidget {
  const _FotoRefugioFallback({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD9B8B9), Color(0xFF7E3C46)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Foto del refugio',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 94,
                  height: 94,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
                  ),
                  child: const Icon(Icons.house_rounded, size: 52, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.guinda),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.body,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
