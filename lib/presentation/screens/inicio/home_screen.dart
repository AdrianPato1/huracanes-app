import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/semaforo_provider.dart';
import '../../widgets/app_header.dart';
import '../../widgets/semaforo_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onBuscarRefugio;
  const HomeScreen({super.key, this.onBuscarRefugio});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SemaforoProvider _provider;
  AlertLevel _previewLevel = AlertLevel.verde;

  @override
  void initState() {
    super.initState();
    _provider = SemaforoProvider();
    _provider.cargarAlerta();
    _previewLevel = _provider.level;
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  // Permite alternar manualmente para previsualizar los 3 estados.
  void _cycle() {
    final nextIndex = (_previewLevel.index + 1) % AlertLevel.values.length;
    setState(() {
      _previewLevel = AlertLevel.values[nextIndex];
    });
  }

  void _openDetail() => AppRouter.goToAlertDetail(context);

  // Llamada telefónica nativa (911, Bomberos, etc.)
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo marcar al $phoneNumber')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _provider,
      builder: (context, _) {
        final level = _previewLevel;
        final titulo = _provider.titulo;
        final mensaje = _provider.mensaje;

        return Column(children: [
          const HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SemaforoCard(level: level, onTap: _cycle),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: KeyedSubtree(
                    key: ValueKey(level),
                    child: _content(level, titulo, mensaje),
                  ),
                ),
              ]),
            ),
          ),
        ]);
      },
    );
  }

  Widget _content(AlertLevel l, String titulo, String mensaje) {
    switch (l) {
      case AlertLevel.verde:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _SectionTitle('Últimas noticias'),
          const SizedBox(height: 14),
          _NewsTile(
            icon: Icons.wb_sunny_outlined,
            tag: 'CLIMA · HOY',
            text: titulo.isNotEmpty
                ? titulo
                : 'Cielo despejado y máxima de 33 °C en Cancún',
          ),
          const SizedBox(height: 14),
          _NewsTile(
            icon: Icons.menu_book_rounded,
            tag: 'CONSEJO OFICIAL',
            text: mensaje.isNotEmpty
                ? mensaje
                : 'Revisa tu mochila de emergencia antes de la temporada',
          ),
        ]);
      case AlertLevel.naranja:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _WideButton(
            label: 'Instrucciones de evacuación',
            background: AppColors.dorado,
            foreground: const Color(0xFF2A0F16),
            onTap: _openDetail,
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Noticias del clima'),
          const SizedBox(height: 14),
          SizedBox(
            height: 152,
            child: ListView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              children: [
                _WeatherCard(
                  tag: 'HOY · 8:00 h',
                  text: titulo.isNotEmpty
                      ? titulo
                      : 'Tormenta tropical se intensifica a huracán categoría 2',
                  onTap: _openDetail,
                ),
                const SizedBox(width: 14),
                _WeatherCard(
                  tag: 'HOY · 9:30 h',
                  text: mensaje.isNotEmpty
                      ? mensaje
                      : 'Se espera marejada ciclónica en la costa',
                  onTap: _openDetail,
                ),
              ],
            ),
          ),
        ]);
      case AlertLevel.roja:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _WideButton(
            label: 'Buscar mi Refugio Ahora',
            icon: Icons.shield_rounded,
            background: const Color(0xFFE60000),
            foreground: Colors.white,
            borderColor: const Color(0xFF7A0000),
            onTap: () {
              if (widget.onBuscarRefugio != null) {
                widget.onBuscarRefugio!();
                return;
              }

              AppRouter.goToMap(context);
            },
          ),
          const SizedBox(height: 22),
          const _SectionTitle('Llamadas de emergencia'),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: _CallButton(
                icon: Icons.call,
                label: '911',
                background: AppColors.guinda,
                foreground: Colors.white,
                big: true,
                onTap: () => _makePhoneCall('911'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _CallButton(
                icon: Icons.local_fire_department_rounded,
                label: 'Bomberos',
                background: AppColors.dorado,
                foreground: const Color(0xFF2A0F16),
                onTap: () => _makePhoneCall('9988841202'), // Bomberos Cancún
              ),
            ),
          ]),
        ]);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: AppColors.guinda,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      );
}

const _cardShadow = [
  BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 5))
];

class _NewsTile extends StatelessWidget {
  const _NewsTile({required this.icon, required this.tag, required this.text});
  final IconData icon;
  final String tag, text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: _cardShadow,
        ),
        child: Row(children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.blush,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppColors.guinda, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                tag,
                style: const TextStyle(
                  color: AppColors.guinda,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 16.5,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]),
          ),
        ]),
      );
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({required this.tag, required this.text, required this.onTap});
  final String tag, text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 270,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: _cardShadow,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.guinda,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                tag,
                style: const TextStyle(
                  color: AppColors.guinda,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]),
            const SizedBox(height: 14),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 16.5,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ]),
        ),
      );
}

class _WideButton extends StatelessWidget {
  const _WideButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.icon,
    this.borderColor,
  });
  final String label;
  final IconData? icon;
  final Color background, foreground;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: background,
        borderRadius: BorderRadius.circular(22),
        elevation: 6,
        shadowColor: Colors.black45,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            height: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: borderColor == null
                  ? null
                  : Border.all(color: borderColor!, width: 3),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (icon != null) ...[
                Icon(icon, color: foreground, size: 26),
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]),
          ),
        ),
      );
}

class _CallButton extends StatelessWidget {
  const _CallButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.big = false,
  });
  final IconData icon;
  final String label;
  final Color background, foreground;
  final VoidCallback onTap;
  final bool big;

  @override
  Widget build(BuildContext context) => Material(
        color: background,
        borderRadius: BorderRadius.circular(22),
        elevation: 5,
        shadowColor: Colors.black38,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: SizedBox(
            height: 84,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: foreground, size: 28),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: big ? 28 : 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]),
          ),
        ),
      );
}
