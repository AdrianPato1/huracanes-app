import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../presentation/widgets/semaforo_card.dart';
import '../datasources/basedatos_local.dart';
import '../models/alerta_clima.dart';

class AlertasRepository {
  static final AlertasRepository instance = AlertasRepository._internal();

  AlertasRepository._internal();

  final BaseDatosLocal _dbLocal = BaseDatosLocal.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StreamController<AlertaClima> _alertaController =
      StreamController<AlertaClima>.broadcast();

  Stream<AlertaClima> get alertaStream => _alertaController.stream;
  StreamSubscription? _firestoreSub;

  Future<AlertaClima> obtenerNivelAlerta() async {
    try {
      final snapshot = await _firestore
          .collection('alertas')
          .orderBy('fechaEmision', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return cargarDesdeLocal();
      }

      final doc = snapshot.docs.first;
      final alerta = AlertaClima.fromMap(doc.data(), id: doc.id);

      await _dbLocal.guardarAlertaCache(
        nivel: alerta.level.name,
        titulo: alerta.titulo,
        mensaje: alerta.mensaje,
        fechaEmision: alerta.fechaEmision?.toIso8601String(),
      );

      await _dbLocal.guardarNotificacionHistorial(
        id: '${alerta.id}_${(alerta.fechaEmision ?? DateTime.now()).millisecondsSinceEpoch}',
        titulo: alerta.titulo,
        mensaje: alerta.mensaje,
        nivel: alerta.level.name,
        fechaEmision: alerta.fechaEmision?.toIso8601String(),
      );

      _alertaController.add(alerta);
      return alerta;
    } catch (_) {
      return cargarDesdeLocal();
    }
  }

  Future<void> iniciarSincronizacion() async {
    await cargarDesdeLocal();

    try {
      _firestoreSub?.cancel();
      _firestoreSub = _firestore
          .collection('alertas')
          .orderBy('fechaEmision', descending: true)
          .limit(1)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.docs.isEmpty) {
          return;
        }

        final doc = snapshot.docs.first;
        final alerta = AlertaClima.fromMap(doc.data(), id: doc.id);

        await _dbLocal.guardarAlertaCache(
          nivel: alerta.level.name,
          titulo: alerta.titulo,
          mensaje: alerta.mensaje,
          fechaEmision: alerta.fechaEmision?.toIso8601String(),
        );

        await _dbLocal.guardarNotificacionHistorial(
          id: '${alerta.id}_${(alerta.fechaEmision ?? DateTime.now()).millisecondsSinceEpoch}',
          titulo: alerta.titulo,
          mensaje: alerta.mensaje,
          nivel: alerta.level.name,
          fechaEmision: alerta.fechaEmision?.toIso8601String(),
        );

        _alertaController.add(alerta);
      }, onError: (_) {
        cargarDesdeLocal();
      });
    } catch (_) {
      await cargarDesdeLocal();
    }
  }

  Future<AlertaClima> cargarDesdeLocal() async {
    final cached = await _dbLocal.obtenerAlertaCache();
    final alerta = cached != null
        ? AlertaClima.fromMap(cached)
        : const AlertaClima(
            id: 'actual',
            level: AlertLevel.verde,
            titulo: 'Condiciones Normales en el Municipio',
            mensaje: 'Sin amenaza ciclónica activa en Benito Juárez.',
          );

    _alertaController.add(alerta);
    return alerta;
  }

  void dispose() {
    _firestoreSub?.cancel();
    _alertaController.close();
  }
}
