import 'package:flutter/material.dart';

enum AlertLevel { verde, naranja, roja }

class _Spec {
  const _Spec(this.bg, this.border, this.fg, this.title, this.subtitle, this.pill,
      this.pillFg, this.active);
  final Color bg, border, fg, pillFg;
  final String title, subtitle, pill;
  final int active;
}

const _specs = {
  AlertLevel.verde: _Spec(
    Color(0xFF1E7A38),
    Color(0xFF1E7A38),
    Colors.white,
    'VERDE',
    'Peligro Mínimo',
    'Todo se encuentra en calma en el municipio',
    Color(0xFF14501F),
    0,
  ),
  AlertLevel.naranja: _Spec(
    Color(0xFFFF8A1F),
    Color(0xFFD35F00),
    Color(0xFF2A1205),
    'ALERTA NARANJA',
    'Peligro Alto',
    'Impacto estimado en 36 horas',
    Color(0xFF2A1205),
    2,
  ),
  AlertLevel.roja: _Spec(
    Color(0xFFB00000),
    Color(0xFF6E0000),
    Colors.white,
    'ALERTA ROJA',
    'Peligro Máximo',
    'Evacuación de zonas vulnerables',
    Color(0xFF8A0000),
    3,
  ),
};

const _lightsOn = [Color(0xFF2FA24A), Color(0xFFC9A21A), Color(0xFFFF8A1F), Color(0xFFD32F2F)];
const _lightsOff = [Color(0xFF2E5A2E), Color(0xFF7A6410), Color(0xFF7A4A1A), Color(0xFF7A1F1A)];

class SemaforoCard extends StatelessWidget {
  const SemaforoCard({super.key, required this.level, this.onTap});
  final AlertLevel level;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = _specs[level]!;
    final isRed = level == AlertLevel.roja;
    final hasBorder = level != AlertLevel.verde;

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(isRed ? 24 : 28),
        border: hasBorder ? Border.all(color: s.border, width: isRed ? 6 : 4) : null,
        boxShadow: [
          BoxShadow(
            color: s.bg.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          'SEMÁFORO METEOROLÓGICO',
          style: TextStyle(
            color: s.fg,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1F),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (var i = 0; i < 4; i++)
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == s.active ? _lightsOn[i] : _lightsOff[i],
                  border: i == s.active
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: i == s.active
                      ? [BoxShadow(color: _lightsOn[i].withValues(alpha: 0.6), blurRadius: 14)]
                      : null,
                ),
              ),
          ]),
        ),
        const SizedBox(height: 18),
        Text(
          s.title,
          style: TextStyle(
            color: s.fg,
            fontSize: level == AlertLevel.verde ? 32 : 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          s.subtitle,
          style: TextStyle(color: s.fg, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))
            ],
          ),
          child: Text(
            s.pill,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: s.pillFg,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ]),
    );

    if (isRed) {
      card = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3C4C4),
          borderRadius: BorderRadius.circular(32),
        ),
        child: card,
      );
    }
    return GestureDetector(onTap: onTap, child: card);
  }
}
