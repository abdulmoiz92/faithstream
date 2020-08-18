import 'dart:typed_data';

import 'package:faithstream/model/image_memory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> database() async {
  return openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'image_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
       db.execute(
        "CREATE TABLE images(id TEXT PRIMARY KEY, image BLOB)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 2,
  );
}

Future<void> insertImage(ImageMemory imageMemory) async {
  final Database db = await database();

  await db.insert('images', imageMemory.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<String> getImage(String id) async {
  final db = await database();

  var res = await  db.query("images");

  return res.first['image'];
}
