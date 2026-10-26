import '../../presentation/widgets/semaforo_card.dart';

class AlertaClima {
  final String id;
  final AlertLevel level;
  final String titulo;
  final String mensaje;
  final DateTime? fechaEmision;

  const AlertaClima({
    required this.id,
    required this.level,
    required this.titulo,
    required this.mensaje,
    this.fechaEmision,
  });

  factory AlertaClima.fromMap(Map<String, dynamic> map, {String id = 'actual'}) {
    final rawNivel = (map['nivel'] ?? 'verde').toString().toLowerCase().trim();
    AlertLevel level;
    if (rawNivel == 'rojo' || rawNivel == 'roja') {
      level = AlertLevel.roja;
    } else if (rawNivel == 'naranja') {
      level = AlertLevel.naranja;
    } else {
      level = AlertLevel.verde;
    }

    DateTime? fecha;
    if (map['fechaEmision'] != null) {
      if (map['fechaEmision'] is String) {
        fecha = DateTime.tryParse(map['fechaEmision']);
      } else {
        try {
          fecha = map['fechaEmision'].toDate();
        } catch (_) {}
      }
    }

    return AlertaClima(
      id: id,
      level: level,
      titulo: map['titulo']?.toString() ?? 'Aviso Oficial',
      mensaje: map['mensaje']?.toString() ?? 'Todo se encuentra en calma.',
      fechaEmision: fecha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nivel': level.name,
      'titulo': titulo,
      'mensaje': mensaje,
      'fechaEmision': fechaEmision?.toIso8601String(),
    };
  }
}

class NoticiaClima {
  final String tag;
  final String titulo;
  final String icono;

  const NoticiaClima({
    required this.tag,
    required this.titulo,
    this.icono = 'cloud',
  });
}
