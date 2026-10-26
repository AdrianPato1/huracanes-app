import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PantallaMapa extends StatelessWidget {
  const PantallaMapa({super.key});

  @override
  Widget build(BuildContext context) {
    const centroCancun = LatLng(21.1619, -86.8252);
    final refugios = [
      const LatLng(21.1619, -86.8252),
      const LatLng(21.1708, -86.8134),
      const LatLng(21.1526, -86.8393),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refugios Activos'),
        backgroundColor: const Color(0xFF7A0000),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: centroCancun,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.alerta_cancun_app',
          ),
          MarkerLayer(
            markers: refugios
                .map(
                  (point) => Marker(
                    point: point,
                    width: 42,
                    height: 42,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}