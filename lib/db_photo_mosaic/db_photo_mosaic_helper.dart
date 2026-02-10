import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_photo_mosaic_entity.dart';
import '../utils/logger.dart';

class DbPhotoMosaicHelper {
  static Database? _database;
  static const String _databaseName = 'photo_mosaic.db';
  static const int _databaseVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE works (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL,
        image_path TEXT NOT NULL,
        template_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE templates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        layout_data TEXT NOT NULL,
        thumbnail_path TEXT,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE filters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        intensity REAL NOT NULL DEFAULT 1.0,
        thumbnail_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE stickers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        image_path TEXT NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE backgrounds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        value TEXT NOT NULL,
        thumbnail_path TEXT
      )
    ''');

    Logger.i('Database created successfully');
  }

  Future<List<WorkEntity>> getAllWorks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('works', orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => WorkEntity.fromMap(maps[i]));
  }

  Future<int> insertWork(WorkEntity work) async {
    final db = await database;
    return await db.insert('works', work.toMap());
  }

  Future<int> updateWork(WorkEntity work) async {
    final db = await database;
    return await db.update(
      'works',
      work.toMap(),
      where: 'id = ?',
      whereArgs: [work.id],
    );
  }

  Future<int> deleteWork(int id) async {
    final db = await database;
    return await db.delete(
      'works',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TemplateEntity>> getAllTemplates({String? type}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (type != null) {
      maps = await db.query(
        'templates',
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'sort_order ASC',
      );
    } else {
      maps = await db.query('templates', orderBy: 'sort_order ASC');
    }
    return List.generate(maps.length, (i) => TemplateEntity.fromMap(maps[i]));
  }

  Future<int> insertTemplate(TemplateEntity template) async {
    final db = await database;
    return await db.insert('templates', template.toMap());
  }

  Future<List<FilterEntity>> getAllFilters() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('filters');
    return List.generate(maps.length, (i) => FilterEntity.fromMap(maps[i]));
  }

  Future<int> insertFilter(FilterEntity filter) async {
    final db = await database;
    return await db.insert('filters', filter.toMap());
  }

  Future<List<StickerEntity>> getStickersByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stickers',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'sort_order ASC',
    );
    return List.generate(maps.length, (i) => StickerEntity.fromMap(maps[i]));
  }

  Future<List<String>> getStickerCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stickers',
      columns: ['category'],
      distinct: true,
    );
    return maps.map((map) => map['category'] as String).toList();
  }

  Future<int> insertSticker(StickerEntity sticker) async {
    final db = await database;
    return await db.insert('stickers', sticker.toMap());
  }

  Future<List<BackgroundEntity>> getBackgroundsByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'backgrounds',
      where: 'type = ?',
      whereArgs: [type],
    );
    return List.generate(maps.length, (i) => BackgroundEntity.fromMap(maps[i]));
  }

  Future<int> insertBackground(BackgroundEntity background) async {
    final db = await database;
    return await db.insert('backgrounds', background.toMap());
  }
}
