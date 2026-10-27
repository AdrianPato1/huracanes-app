import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDatosLocal {
  static final BaseDatosLocal instance = BaseDatosLocal._init();
  static Database? _database;

  BaseDatosLocal._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('alerta_cancun.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mochila (
        id TEXT PRIMARY KEY,
        articulo TEXT NOT NULL,
        marcado INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE alerta_cache (
        id TEXT PRIMARY KEY,
        nivel TEXT NOT NULL,
        titulo TEXT NOT NULL,
        mensaje TEXT NOT NULL,
        fechaEmision TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE configuracion (
        clave TEXT PRIMARY KEY,
        valor TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE refugios (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        direccion TEXT,
        capacidad INTEGER,
        capacidadActual INTEGER,
        aceptaMascotas INTEGER NOT NULL DEFAULT 0,
        latitud REAL,
        longitud REAL,
        estaAbierto INTEGER NOT NULL DEFAULT 1,
        ultimoUpdate TEXT,
        fuente TEXT DEFAULT 'firestore'
      )
    ''');

    await db.execute('''
      CREATE TABLE historial_notificaciones (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        mensaje TEXT NOT NULL,
        nivel TEXT NOT NULL,
        fechaEmision TEXT NOT NULL
      )
    ''');

    final articulosBase = [
      'Agua embotellada (3 días)',
      'Alimentos enlatados no perecederos',
      'Documentos importantes en bolsa hermética',
      'Botiquín de primeros auxilios',
      'Linterna con baterías extra',
      'Radio de pilas',
    ];

    for (int i = 0; i < articulosBase.length; i++) {
      await db.insert('mochila', {
        'id': 'item_$i',
        'articulo': articulosBase[i],
        'marcado': 0,
      });
    }

    await db.insert('alerta_cache', {
      'id': 'actual',
      'nivel': 'verde',
      'titulo': 'Condiciones Normales en el Municipio',
      'mensaje': 'Sin amenaza ciclónica activa en Benito Juárez.',
      'fechaEmision': DateTime.now().toIso8601String(),
    });

    await db.insert('configuracion', {
      'clave': 'onboarding_completado',
      'valor': '0',
    });

    await db.insert('configuracion', {
      'clave': 'permisos_otorgados',
      'valor': '0',
    });
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS alerta_cache (
          id TEXT PRIMARY KEY,
          nivel TEXT NOT NULL,
          titulo TEXT NOT NULL,
          mensaje TEXT NOT NULL,
          fechaEmision TEXT NOT NULL
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS configuracion (
          clave TEXT PRIMARY KEY,
          valor TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS refugios (
          id TEXT PRIMARY KEY,
          nombre TEXT NOT NULL,
          direccion TEXT,
          capacidad INTEGER,
          capacidadActual INTEGER,
          aceptaMascotas INTEGER NOT NULL DEFAULT 0,
          latitud REAL,
          longitud REAL,
          estaAbierto INTEGER NOT NULL DEFAULT 1,
          ultimoUpdate TEXT,
          fuente TEXT DEFAULT 'firestore'
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS historial_notificaciones (
          id TEXT PRIMARY KEY,
          titulo TEXT NOT NULL,
          mensaje TEXT NOT NULL,
          nivel TEXT NOT NULL,
          fechaEmision TEXT NOT NULL
        )
      ''');

      final configRows = await db.query('configuracion');
      final hasOnboarding = configRows.any((row) => row['clave'] == 'onboarding_completado');
      final hasPermisos = configRows.any((row) => row['clave'] == 'permisos_otorgados');

      if (!hasOnboarding) {
        await db.insert('configuracion', {
          'clave': 'onboarding_completado',
          'valor': '0',
        });
      }

      if (!hasPermisos) {
        await db.insert('configuracion', {
          'clave': 'permisos_otorgados',
          'valor': '0',
        });
      }
    }
  }

  Future<void> guardarAlertaCache({
    required String nivel,
    required String titulo,
    required String mensaje,
    String? fechaEmision,
  }) async {
    final db = await database;
    await db.insert(
      'alerta_cache',
      {
        'id': 'actual',
        'nivel': nivel,
        'titulo': titulo,
        'mensaje': mensaje,
        'fechaEmision': fechaEmision ?? DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> obtenerAlertaCache() async {
    final db = await database;
    final res = await db.query(
      'alerta_cache',
      where: 'id = ?',
      whereArgs: ['actual'],
      limit: 1,
    );
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<void> guardarConfiguracion({
    required String clave,
    required bool valor,
  }) async {
    final db = await database;
    await db.insert(
      'configuracion',
      {
        'clave': clave,
        'valor': valor ? '1' : '0',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool?> obtenerConfiguracion(String clave) async {
    final db = await database;
    final res = await db.query(
      'configuracion',
      where: 'clave = ?',
      whereArgs: [clave],
      limit: 1,
    );

    if (res.isEmpty) return null;
    final valor = res.first['valor'];
    if (valor is String) {
      return valor == '1' || valor.toLowerCase() == 'true';
    }
    return valor == 1;
  }

  Future<void> guardarRefugioLocal(Map<String, dynamic> refugio) async {
    final db = await database;
    await db.insert(
      'refugios',
      {
        'id': refugio['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'nombre': refugio['nombre'] ?? 'Refugio',
        'direccion': refugio['direccion'],
        'capacidad': refugio['capacidad'],
        'capacidadActual': refugio['capacidadActual'],
        'aceptaMascotas': (refugio['aceptaMascotas'] == true || refugio['aceptaMascotas'] == 1) ? 1 : 0,
        'latitud': refugio['latitud'],
        'longitud': refugio['longitud'],
        'estaAbierto': (refugio['estaAbierto'] == true || refugio['estaAbierto'] == 1) ? 1 : 0,
        'ultimoUpdate': (refugio['ultimoUpdate'] is DateTime)
            ? refugio['ultimoUpdate'].toIso8601String()
            : (refugio['ultimoUpdate'] ?? DateTime.now().toIso8601String()),
        'fuente': refugio['fuente'] ?? 'firestore',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> cargarRefugiosDemostracionSiHaceFalta() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM refugios')) ?? 0;

    if (count > 0) {
      return;
    }

    final refugiosDemo = [
      {
        'id': 'refugio_1',
        'nombre': 'Cruz Roja Cancún',
        'direccion': 'Avenida Tulum 234, Centro',
        'capacidad': 180,
        'capacidadActual': 96,
        'aceptaMascotas': 1,
        'latitud': 21.1619,
        'longitud': -86.8252,
        'estaAbierto': 1,
        'ultimoUpdate': DateTime.now().toIso8601String(),
        'fuente': 'demo',
      },
      {
        'id': 'refugio_2',
        'nombre': 'Escuela Primaria Benito Juárez',
        'direccion': 'Calle 20 de Noviembre 118',
        'capacidad': 140,
        'capacidadActual': 88,
        'aceptaMascotas': 0,
        'latitud': 21.1708,
        'longitud': -86.8134,
        'estaAbierto': 1,
        'ultimoUpdate': DateTime.now().toIso8601String(),
        'fuente': 'demo',
      },
      {
        'id': 'refugio_3',
        'nombre': 'Centro Cultural Puerto Juárez',
        'direccion': 'Carretera Puerto Juárez 55',
        'capacidad': 120,
        'capacidadActual': 72,
        'aceptaMascotas': 1,
        'latitud': 21.1526,
        'longitud': -86.8393,
        'estaAbierto': 1,
        'ultimoUpdate': DateTime.now().toIso8601String(),
        'fuente': 'demo',
      },
      {
        'id': 'refugio_4',
        'nombre': 'Unidad Deportiva Bonfil',
        'direccion': 'Av. Bonfil esquina Yaxchilán',
        'capacidad': 220,
        'capacidadActual': 150,
        'aceptaMascotas': 0,
        'latitud': 21.1465,
        'longitud': -86.7934,
        'estaAbierto': 0,
        'ultimoUpdate': DateTime.now().toIso8601String(),
        'fuente': 'demo',
      },
    ];

    for (final refugio in refugiosDemo) {
      await guardarRefugioLocal(refugio);
    }
  }

  Future<List<Map<String, dynamic>>> obtenerRefugiosLocales() async {
    final db = await database;
    return db.query('refugios', orderBy: 'nombre ASC');
  }

  Future<void> guardarNotificacionHistorial({
    required String id,
    required String titulo,
    required String mensaje,
    required String nivel,
    String? fechaEmision,
  }) async {
    final db = await database;
    await db.insert(
      'historial_notificaciones',
      {
        'id': id,
        'titulo': titulo,
        'mensaje': mensaje,
        'nivel': nivel,
        'fechaEmision': fechaEmision ?? DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> obtenerHistorialNotificaciones() async {
    final db = await database;
    return db.query(
      'historial_notificaciones',
      orderBy: 'fechaEmision DESC',
    );
  }
}