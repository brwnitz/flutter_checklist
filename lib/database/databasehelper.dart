import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class Databasehelper{
  static final Databasehelper _instance = Databasehelper.internal();
  factory Databasehelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    _db ??= await setDb();
    return _db!;
  }
  Databasehelper.internal();

  setDb() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}Checklist.db';
    var dB = await openDatabase(path, version: 2, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Topic (idTopic INTEGER PRIMARY KEY, titleTopic TEXT, descTopic TEXT, colorTopic INTEGER)');
    await db.execute(
        'CREATE TABLE Checked (idChecked INTEGER PRIMARY KEY, nameChecked TEXT, descChecked TEXT, isChecked INTEGER, dateChecked, isFavorite INTEGER, idTopic INTEGER, FOREIGN KEY (idTopic) REFERENCES Topic(idTopic))');
  }
}