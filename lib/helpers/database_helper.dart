import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';
import '../models/menu_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('warmindo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // 1. Skema Tabel User
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // 2. Skema Tabel Menu
    await db.execute('''
      CREATE TABLE menu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        deskripsi TEXT NOT NULL,
        harga INTEGER NOT NULL,
        tipe TEXT NOT NULL
      )
    ''');

    // 3. Seed Data User (Login Default)
    await db.insert('users', {'username': 'admin', 'password': '123456'});

    // 4. Seed Data Menu Warmindo
    await db.insert('menu', {
      'nama': 'Indomie Goreng Rendang',
      'deskripsi': 'Indomie goreng rasa rendang plus telur stengah matang',
      'harga': 10000,
      'tipe': 'Makanan',
    });

    await db.insert('menu', {
      'nama': 'Es Teh Manis',
      'deskripsi': 'Es teh manis pake es, teh, esteh manis',
      'harga': 2000,
      'tipe': 'Minuman',
    });

    await db.insert('menu', {
      'nama': 'Tahu',
      'deskripsi': 'Topping Tahu',
      'harga': 2000,
      'tipe': 'Tambahan',
    });
  }

  // --- READ ---
  Future<List<MenuModel>> getAllMenu() async {
    final db = await instance.database;
    final result = await db.query('menu', orderBy: 'id DESC');
    return result.map((json) => MenuModel.fromMap(json)).toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((json) => UserModel.fromMap(json)).toList();
  }

  // --- CREATE ---
  Future<int> insertMenu(MenuModel menu) async {
    final db = await instance.database;
    return await db.insert('menu', menu.toMap());
  }

  // --- UPDATE ---
  Future<int> updateMenu(MenuModel menu) async {
    final db = await instance.database;
    return await db.update(
      'menu',
      menu.toMap(),
      where: 'id = ?',
      whereArgs: [menu.id],
    );
  }

  // --- DELETE ---
  Future<int> deleteMenu(int id) async {
    final db = await instance.database;
    return await db.delete('menu', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi Check Login
  Future<UserModel?> login(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null; // Login gagal (username/password salah)
    }
  }
}
