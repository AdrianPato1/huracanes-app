import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_rounded, 'Inicio'),
    (Icons.shield_rounded, 'Refugios'),
    (Icons.menu_book_rounded, 'Guías'),
    (Icons.person_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, -4))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 68,
                      height: 38,
                      decoration: BoxDecoration(
                        color: i == index ? AppColors.doradoSoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Icon(
                        _items[i].$1,
                        size: 24,
                        color: i == index ? AppColors.guinda : AppColors.body,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _items[i].$2,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: i == index ? AppColors.guinda : AppColors.body,
                      ),
                    ),
                  ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
