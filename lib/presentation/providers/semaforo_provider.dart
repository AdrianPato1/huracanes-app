import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/alerta_clima.dart';
import '../../data/repositories/alertas_repository.dart';
import '../widgets/semaforo_card.dart';

class SemaforoProvider extends ChangeNotifier {
  SemaforoProvider() {
    _subscribeToAlerts();
    cargarAlerta();
  }

  final AlertasRepository _repository = AlertasRepository.instance;
  StreamSubscription<AlertaClima>? _subscription;

  AlertaClima _alerta = const AlertaClima(
    id: 'actual',
    level: AlertLevel.verde,
    titulo: 'Condiciones normales',
    mensaje: 'Sin alerta activa.',
  );

  AlertaClima get alerta => _alerta;
  AlertLevel get level => _alerta.level;
  String get titulo => _alerta.titulo;
  String get mensaje => _alerta.mensaje;

  void _subscribeToAlerts() {
    _subscription = _repository.alertaStream.listen((value) {
      _alerta = value;
      notifyListeners();
    });
  }

  Future<void> cargarAlerta() async {
    try {
      final data = await _repository.obtenerNivelAlerta();
      _alerta = data;
      notifyListeners();
    } catch (_) {
      final fallback = await _repository.cargarDesdeLocal();
      _alerta = fallback;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
