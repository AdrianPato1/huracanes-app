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
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabla Mochila
    await db.execute('''
    CREATE TABLE mochila (
      id TEXT PRIMARY KEY,
      articulo TEXT NOT NULL,
      marcado INTEGER NOT NULL
    )
    ''');

    // Tabla Alerta / Semáforo offline
    await db.execute('''
    CREATE TABLE alerta_cache (
      id TEXT PRIMARY KEY,
      nivel TEXT NOT NULL,
      titulo TEXT NOT NULL,
      mensaje TEXT NOT NULL,
      fechaEmision TEXT
    )
    ''');

    // Artículos base por defecto
    List<String> articulosBase = [
      'Agua embotellada (3 días)',
      'Alimentos enlatados no perecederos',
      'Documentos importantes en bolsa hermética',
      'Botiquín de primeros auxilios',
      'Linterna con baterías extra',
      'Radio de pilas'
    ];

    for (int i = 0; i < articulosBase.length; i++) {
      await db.insert('mochila', {
        'id': 'item_$i',
        'articulo': articulosBase[i],
        'marcado': 0
      });
    }

    // Alerta inicial por defecto (Verde)
    await db.insert('alerta_cache', {
      'id': 'actual',
      'nivel': 'verde',
      'titulo': 'Condiciones Normales en el Municipio',
      'mensaje': 'Sin amenaza ciclónica activa en Benito Juárez.',
      'fechaEmision': DateTime.now().toIso8601String(),
    });
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS alerta_cache (
        id TEXT PRIMARY KEY,
        nivel TEXT NOT NULL,
        titulo TEXT NOT NULL,
        mensaje TEXT NOT NULL,
        fechaEmision TEXT
      )
      ''');
    }
  }

  // Guardar alerta en caché local
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

  // Obtener la alerta en caché local
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
}