import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_assets.dart';

BoxDecoration headerDecoration() => const BoxDecoration(
      color: AppColors.guinda,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      boxShadow: [
        BoxShadow(color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 4))
      ],
    );

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.onBell});
  final VoidCallback? onBell;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: headerDecoration(),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          child: Row(children: [
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 3))
              ]),
              child: ClipOval(
                child: Container(
                  width: 58,
                  height: 58,
                  color: Colors.white,
                  padding: const EdgeInsets.all(3),
                  child: Image.asset(
                    AppAssets.logoProteccion,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROTECCIÓN CIVIL',
                    style: TextStyle(
                      color: AppColors.dorado,
                      fontSize: 11.5,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Benito Juárez',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.white.withValues(alpha: 0.12),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBell,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(alignment: Alignment.center, children: [
                    const Icon(Icons.notifications_rounded, color: Colors.white, size: 22),
                    Positioned(
                      top: 11,
                      right: 11,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF3B30),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Container(
        decoration: headerDecoration(),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 20, 18),
            child: Row(children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
          ),
        ),
      );
}
