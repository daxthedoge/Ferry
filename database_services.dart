// ignore_for_file: prefer_is_empty

import '../models/ferryticket.dart';
import '../models/loginDetails.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'ferry.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE login(id INTEGER PRIMARY KEY, f_name TEXT, l_name TEXT, username TEXT, password TEXT, mobile TEXT)',
    );
    await db.execute(
      'CREATE TABLE ferryticket(book_id INTEGER PRIMARY KEY, depart_date DATE, journey TEXT, depart_route TEXT, dest_route TEXT, id INTEGER, FOREIGN KEY (id) REFERENCES user(id))',
    );
  }

/////////////////////////////////////////////////////////////////////////

  Future<void> insertFerryTicket(FerryTicket ferryticket) async {
    final db = await _databaseService.database;
    await db.insert(
      'ferryticket',
      ferryticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertLoginDetails(LoginDetails loginDetails) async {
    final db = await _databaseService.database;
    await db.insert(
      'login',
      loginDetails.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<bool> checkUser(String username, String password) async {
    final db = await _databaseService.database;
    try {
      List<Map> users = await db.query('login',
          where: 'username = ? and password = ?',
          whereArgs: [username, password]);
      if (users.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  //executes SELECT statement
  Future<List<FerryTicket>> ferryticket() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('ferryticket');
    return List.generate(
        maps.length, (index) => FerryTicket.fromMap(maps[index]));
  }

/////////////////////////////////////////////////////////////
  Future<List<LoginDetails>> loginDetails() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('login');
    return List.generate(
        maps.length, (index) => LoginDetails.fromMap(maps[index]));
  }

  Future<List<LoginDetails>> ferryDetails() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('ferryticket');
    return List.generate(
        maps.length, (index) => LoginDetails.fromMap(maps[index]));
  }

  Future<LoginDetails> loginDetail(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('login', where: 'id = ?', whereArgs: [id]);
    return LoginDetails.fromMap(maps[0]);
  }

////////////////////////////////////////////////////////////////
  Future<void> updateFerryTicket(FerryTicket ferryticket) async {
    final db = await _databaseService.database;
    await db.update('ferryticket', ferryticket.toMap(),
        where: 'book_id = ?', whereArgs: [ferryticket.book_id]);
  }

  Future<void> deleteFerryTicket(int id) async {
    final db = await _databaseService.database;
    await db.delete('ferryticket', where: 'book_id = ?', whereArgs: [id]);
  }
}
