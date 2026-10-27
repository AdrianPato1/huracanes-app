import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_assets.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.guinda,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Header institucional
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 42,
                      height: 42,
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
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              // Ilustración central
              const _ShieldIllustration(),
              const Spacer(flex: 3),
              // Título
              const Text(
                'Tu seguridad es\nnuestra prioridad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              // Subtítulo
              Text(
                'Prepárate, infórmate y actúa a tiempo\nante huracanes y tormentas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 15.5,
                  height: 1.45,
                ),
              ),
              const Spacer(flex: 4),
              // Botón Comenzar
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/onboarding');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dorado,
                    foregroundColor: const Color(0xFF2A0F16),
                    elevation: 4,
                    shadowColor: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Comenzar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShieldIllustration extends StatelessWidget {
  const _ShieldIllustration();

  @override
  Widget build(BuildContext context) {
    Widget person(Color c) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.piel,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 42,
              height: 62,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(21),
              ),
            ),
          ],
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;
        final double size = maxW > 300 ? 300 : maxW * 0.85;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculo exterior tenue
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              // Círculo interior
              Container(
                width: size * 0.8,
                height: size * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.guindaLight.withValues(alpha: 0.7),
                ),
              ),
              // Nube
              Positioned(
                top: size * 0.17,
                right: size * 0.18,
                child: Icon(
                  Icons.cloud,
                  color: const Color(0xFFF5E9EC),
                  size: size * 0.22,
                ),
              ),
              // Casa blanca
              Positioned(
                top: size * 0.29,
                child: CustomPaint(
                  size: Size(size * 0.5, size * 0.5),
                  painter: _HousePainter(),
                ),
              ),
              // Persona izquierda (dorada)
              Positioned(
                left: size * 0.11,
                bottom: size * 0.26,
                child: person(AppColors.dorado),
              ),
              // Persona derecha (blanca)
              Positioned(
                right: size * 0.11,
                bottom: size * 0.26,
                child: person(Colors.white),
              ),
              // Escudo dorado con check en el centro
              Positioned(
                top: size * 0.52,
                child: CustomPaint(
                  size: Size(size * 0.26, size * 0.31),
                  painter: _ShieldPainter(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = Colors.white;
    canvas.drawPath(
      Path()
        ..moveTo(s.width / 2, 0)
        ..lineTo(s.width, s.height * 0.38)
        ..lineTo(s.width * 0.85, s.height * 0.38)
        ..lineTo(s.width * 0.85, s.height)
        ..lineTo(s.width * 0.15, s.height)
        ..lineTo(s.width * 0.15, s.height * 0.38)
        ..lineTo(0, s.height * 0.38)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final shield = Path()
      ..moveTo(0, h * 0.1)
      ..quadraticBezierTo(w * 0.5, -h * 0.02, w * 0.5, 0)
      ..quadraticBezierTo(w * 0.5, -h * 0.02, w, h * 0.1)
      ..lineTo(w, h * 0.5)
      ..quadraticBezierTo(w, h * 0.82, w * 0.5, h)
      ..quadraticBezierTo(0, h * 0.82, 0, h * 0.5)
      ..close();
    canvas.drawPath(shield, Paint()..color = AppColors.dorado);

    final check = Paint()
      ..color = AppColors.guinda
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.26, h * 0.46)
        ..lineTo(w * 0.44, h * 0.62)
        ..lineTo(w * 0.76, h * 0.3),
      check,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}