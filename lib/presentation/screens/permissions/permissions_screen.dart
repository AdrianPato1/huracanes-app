import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../main_shell.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _gps = false;
  bool _notif = false;

  void _goHome() => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.guinda,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 20, 14),
              child: Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.dorado, width: 2),
                  ),
                  child: const Text(
                    'PC',
                    style: TextStyle(
                      color: AppColors.guinda,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
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
              ]),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(children: [
              const _PinArt(),
              const SizedBox(height: 14),
              const Text(
                'Permisos necesarios',
                style: TextStyle(
                  color: AppColors.guinda,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Actívalos para que la app pueda\nprotegerte',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.body, fontSize: 15.5, height: 1.4),
              ),
              const SizedBox(height: 18),
              _PermissionTile(
                icon: Icons.my_location,
                title: 'Ubicación GPS',
                subtitle: '(Para encontrar refugios)',
                value: _gps,
                onChanged: (v) => setState(() => _gps = v),
              ),
              const SizedBox(height: 14),
              _PermissionTile(
                icon: Icons.notifications,
                title: 'Notificaciones',
                subtitle: '(Para recibir alertas)',
                value: _notif,
                onChanged: (v) => setState(() => _notif = v),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _gps = true;
                      _notif = true;
                    });
                    _goHome();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.guinda,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Activar permisos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _goHome,
                child: const Text(
                  'Configurar más tarde',
                  style: TextStyle(
                    color: AppColors.guinda,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _PinArt extends StatelessWidget {
  const _PinArt();

  Widget _bell() => Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.dorado,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 4))
          ],
        ),
        child: const Icon(Icons.notifications, size: 20, color: Color(0xFF2A0F16)),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 240,
        height: 170,
        child: Stack(alignment: Alignment.center, children: [
          Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              color: AppColors.doradoSoft,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 112,
            height: 112,
            decoration: const BoxDecoration(
              color: Color(0xFFEDD6A0),
              shape: BoxShape.circle,
            ),
          ),
          Stack(alignment: Alignment.topCenter, children: [
            const Icon(Icons.location_on, color: AppColors.guinda, size: 84),
            Positioned(
              top: 22,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ]),
          Positioned(left: 14, top: 12, child: _bell()),
          Positioned(right: 14, bottom: 22, child: _bell()),
        ]),
      );
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 5))
          ],
        ),
        child: Row(children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: AppColors.guinda,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: AppColors.body, height: 1.3),
              ),
            ]),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.guinda,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFC5C7D0),
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ]),
      );
}
