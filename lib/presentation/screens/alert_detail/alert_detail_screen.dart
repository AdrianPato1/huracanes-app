import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/app_header.dart';

class AlertDetailScreen extends StatelessWidget {
  const AlertDetailScreen({super.key});

  static const _sections = [
    (
      Icons.shield_rounded,
      'Medidas preventivas',
      'Asegura puertas y ventanas, almacena agua y alimentos para 3 días y mantén tu teléfono cargado.'
    ),
    (
      Icons.warning_rounded,
      'Suspensión de labores',
      'Se suspenden clases y actividades no esenciales a partir de las 18:00 h del lunes.'
    ),
    (
      Icons.directions_bus_rounded,
      'Transporte',
      'El transporte público operará con horario reducido hasta nuevo aviso.'
    ),
    (
      Icons.location_on_rounded,
      'Zonas que deben evacuar',
      'Zona costera, Isla Blanca y Puerto Juárez. Acude al refugio más cercano.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(children: [
        const DetailHeader(title: 'Detalle de alerta'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33FF8A1F),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.warning_rounded, size: 18, color: Color(0xFF2A1205)),
                  SizedBox(width: 8),
                  Text(
                    'ALERTA NARANJA',
                    style: TextStyle(
                      color: Color(0xFF2A1205),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 14),
              const Text(
                'Huracán categoría 2 se aproxima a Quintana Roo',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Emitido hoy · 9:30 h · Protección Civil Benito Juárez',
                style: TextStyle(color: AppColors.body, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 14,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(children: [
                  for (var i = 0; i < _sections.length; i++) ...[
                    _Section(
                      icon: _sections[i].$1,
                      title: _sections[i].$2,
                      text: _sections[i].$3,
                    ),
                    if (i < _sections.length - 1)
                      const Divider(height: 1, color: AppColors.border),
                  ],
                ]),
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: SizedBox(
            width: double.infinity,
            height: 62,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compartiendo alerta oficial...')),
                );
              },
              icon: const Icon(Icons.share, size: 22),
              label: const Text(
                'Compartir alerta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.guinda,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: Colors.black38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
          ),
        ),
        const SafeArea(top: false, child: SizedBox(height: 16)),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title, text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.guinda,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 19),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.guinda,
                fontSize: 17.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
        ]),
      );
}
