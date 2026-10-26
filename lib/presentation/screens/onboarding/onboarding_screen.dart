import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../permissions/permissions_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _titles = [
    'Alertas en tiempo real',
    'Encuentra refugios',
  ];

  static const _texts = [
    'Recibe avisos inmediatos sobre huracanes, tormentas y cambios en el semáforo meteorológico',
    'Ubica los refugios temporales más cercanos a tu posición, su capacidad actual y si aceptan mascotas',
  ];

  void _next() {
    if (_page < 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PermissionsScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Header institucional con esquinas inferiores redondeadas
          Container(
            decoration: const BoxDecoration(
              color: AppColors.guinda,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.white,
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(
                          AppAssets.logoProteccion,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Alerta Cancún',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _finish,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Text(
                          'Omitir',
                          style: TextStyle(
                            color: AppColors.dorado,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Slides deslizables con PageView
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                _Slide(
                  art: const _AlertArt(),
                  title: _titles[0],
                  text: _texts[0],
                ),
                _Slide(
                  art: const _MapArt(),
                  title: _titles[1],
                  text: _texts[1],
                ),
              ],
            ),
          ),

          // Indicadores de puntos animados
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 2; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 28 : 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: i == _page ? AppColors.guinda : const Color(0xFFCFCFD6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
            ],
          ),

          // Botón inferior Siguiente / Comenzar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.guinda,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  _page < 1 ? 'Siguiente' : 'Comenzar',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),

          const SafeArea(
            top: false,
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.art,
    required this.title,
    required this.text,
  });

  final Widget art;
  final String title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(child: art)),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.guinda,
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(36, 12, 36, 16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.body,
              fontSize: 15.5,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

/// Ilustración del Teléfono con Notificaciones flotantes
class _AlertArt extends StatelessWidget {
  const _AlertArt();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxH = constraints.maxHeight;
        final double scale = (maxH / 380).clamp(0.75, 1.0);

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 350,
            height: 340,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Anillo dorado exterior
                Container(
                  width: 340,
                  height: 340,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.dorado.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                ),
                // Anillo dorado interior
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.dorado.withValues(alpha: 0.20),
                      width: 1.5,
                    ),
                  ),
                ),
                // Cuerpo del teléfono (mockup)
                Positioned(
                  top: 8,
                  child: Container(
                    width: 165,
                    height: 300,
                    padding: const EdgeInsets.only(top: 26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF1E1E1E), width: 6),
                      borderRadius: BorderRadius.circular(34),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text(
                          '9:41',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Domingo, 11 de octubre',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Notch dinámico
                Positioned(
                  top: 8,
                  child: Container(
                    width: 58,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                  ),
                ),
                // Tarjeta 1: Alerta Naranja (flotante)
                Positioned(
                  top: 124,
                  left: 6,
                  right: 6,
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        Container(width: 6, color: AppColors.orange),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ALERTA NARANJA',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Peligro alto · impacto en 36 h',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.body,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tarjeta 2: Actualización del semáforo
                Positioned(
                  top: 216,
                  left: 28,
                  right: 28,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.guinda,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cloud,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Actualización del semáforo',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Ilustración del Mapa con pines y refugio cercano
class _MapArt extends StatelessWidget {
  const _MapArt();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxH = constraints.maxHeight;
        final double scale = (maxH / 370).clamp(0.75, 1.0);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 320,
            height: 340,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEBE0),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Zona verde / parque
                Positioned(
                  left: 20,
                  top: 28,
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFE8C6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                // Zona de agua / laguna
                Positioned(
                  right: -55,
                  bottom: -45,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA9D3F0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Calles verticales
                for (final x in [65.0, 145.0, 255.0])
                  Positioned(
                    left: x,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 10, color: Colors.white),
                  ),
                // Calles horizontales
                for (final y in [120.0, 200.0])
                  Positioned(
                    top: y,
                    left: 0,
                    right: 0,
                    child: Container(height: 10, color: Colors.white),
                  ),
                // Pines de refugios
                const Positioned(left: 55, top: 22, child: _Pin()),
                const Positioned(left: 210, top: 40, child: _Pin()),
                const Positioned(left: 55, top: 136, child: _Pin()),
                const Positioned(left: 245, top: 148, child: _Pin()),
                // Punto de ubicación del usuario
                Positioned(
                  left: 128,
                  top: 98,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A73E8).withValues(alpha: 0.2),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A73E8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                ),
                // Tarjeta de información del refugio
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 14,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Escuela Vicente Guerrero',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            Text(
                              'A 1.2 km',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.guinda,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: const LinearProgressIndicator(
                            value: 0.7,
                            minHeight: 8,
                            backgroundColor: Color(0xFFE6E6EA),
                            valueColor: AlwaysStoppedAnimation(AppColors.guinda),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '350/500 personas',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pin de ubicación de refugio
class _Pin extends StatelessWidget {
  const _Pin();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 32,
        height: 42,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Icon(Icons.location_on, color: AppColors.guinda, size: 42),
            Positioned(
              top: 10,
              child: CircleAvatar(radius: 5, backgroundColor: Colors.white),
            ),
          ],
        ),
      );
}
