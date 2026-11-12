import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Resena {
  final int? id;
  final int fraseId;
  final String texto;
  final String fecha;

  Resena({this.id, required this.fraseId, required this.texto, required this.fecha});

  Map<String, dynamic> toMap() => {
        'id': id,
        'frase_id': fraseId,
        'texto': texto,
        'fecha': fecha,
      };

  factory Resena.fromMap(Map<String, dynamic> m) => Resena(
        id: m['id'],
        fraseId: m['frase_id'],
        texto: m['texto'],
        fecha: m['fecha'],
      );
}

class ResenaDb {
  static final ResenaDb instance = ResenaDb._();
  ResenaDb._();

  Database? _db;

  Future<Database> get db async => _db ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'resenas.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE resenas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            frase_id INTEGER NOT NULL,
            texto TEXT NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertar(Resena r) async {
    final database = await db;
    await database.insert('resenas', r.toMap());
  }

  Future<List<Resena>> obtenerPorFrase(int fraseId) async {
    final database = await db;
    final rows = await database.query(
      'resenas',
      where: 'frase_id = ?',
      whereArgs: [fraseId],
      orderBy: 'id DESC',
    );
    return rows.map(Resena.fromMap).toList();
  }
}