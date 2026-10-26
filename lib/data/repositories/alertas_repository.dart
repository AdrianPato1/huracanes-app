import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/basedatos_local.dart';
import '../models/alerta_clima.dart';
import '../../presentation/widgets/semaforo_card.dart';

class AlertasRepository {
  static final AlertasRepository instance = AlertasRepository._internal();
  AlertasRepository._internal();

  final BaseDatosLocal _dbLocal = BaseDatosLocal.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream local de la alerta activa
  final StreamController<AlertaClima> _alertaController =
      StreamController<AlertaClima>.broadcast();

  Stream<AlertaClima> get alertaStream => _alertaController.stream;

  StreamSubscription? _firestoreSub;

  // Iniciar sincronización híbrida (Offline-first)
  Future<void> iniciarSincronizacion() async {
    // 1. Cargar inmediatamente desde SQLite para que nunca esté vacío
    await cargarDesdeLocal();

    // 2. Escuchar Firestore en segundo plano y actualizar SQLite automáticamente
    try {
      _firestoreSub?.cancel();
      _firestoreSub = _firestore
          .collection('alertas')
          .orderBy('fechaEmision', descending: true)
          .limit(1)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          final data = doc.data();

          final alerta = AlertaClima.fromMap(data, id: doc.id);

          // Guardar en SQLite local
          await _dbLocal.guardarAlertaCache(
            nivel: alerta.level.name,
            titulo: alerta.titulo,
            mensaje: alerta.mensaje,
            fechaEmision: alerta.fechaEmision?.toIso8601String(),
          );

          // Emitir a la UI
          _alertaController.add(alerta);
        }
      }, onError: (err) {
        // En caso de corte de red o error de Firestore, leer desde SQLite
        cargarDesdeLocal();
      });
    } catch (_) {
      await cargarDesdeLocal();
    }
  }

  // Leer estado de alerta desde SQLite
  Future<AlertaClima> cargarDesdeLocal() async {
    final cached = await _dbLocal.obtenerAlertaCache();
    AlertaClima alerta;
    if (cached != null) {
      alerta = AlertaClima.fromMap(cached);
    } else {
      alerta = const AlertaClima(
        id: 'actual',
        level: AlertLevel.verde,
        titulo: 'Condiciones Normales en el Municipio',
        mensaje: 'Sin amenaza ciclónica activa en Benito Juárez.',
      );
    }
    _alertaController.add(alerta);
    return alerta;
  }

  void dispose() {
    _firestoreSub?.cancel();
    _alertaController.close();
  }
}
