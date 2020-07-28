// Open the database and store the reference.
import 'package:faithstream/model/dbpost.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDatabase() async {
  return openDatabase(
     // Set the path to the database. Note: Using the `join` function from the
     // `path` package is best practice to ensure the path is correctly
     // constructed for each platform.
     join(await getDatabasesPath() , 'doggie_database.db'),
     onCreate: (db,version) {
       // Run the CREATE TABLE statement on the database.
       return db.execute("CREATE TABLE posts(postId TEXT PRIMARY KEY, isLiked INTEGER, isFavourite INTEGER)");
     },
     // Set the version. This executes the onCreate function and provides a
     // path to perform database upgrades and downgrades.
     version: 1,
   );
 }

Future<void> insertDBPost(DBPost post) async {
  // Get a reference to the database.
  final Database db = await initDatabase();
  await db.insert("posts", post.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> updateDBPostLiked(String id,int value) async {
  // Get a reference to the database.
  final Database db = await initDatabase();
  await db.rawUpdate('UPDATE posts SET isLiked = ? WHERE postId = ?', [value,id]);
}

Future<void> updateDBPostFavourite(String id,int value) async {
  // Get a reference to the database.
  final Database db = await initDatabase();
  await db.rawUpdate('UPDATE posts SET isFavourite = ? WHERE postId = ?', [value,id]);
}

Future<List<DBPost>> posts() async {
  // Get a reference to the database.
  final Database db = await initDatabase();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('posts');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return DBPost(
      postId: maps[i]['postId'],
    );
  });
}


 findIsLiked(String id) async {
  final Database db = await initDatabase();
   var res  = await db.query("posts",where: "postId = ?",whereArgs: [id]);

   return res.isNotEmpty ? res.first['isLiked'] : null;
}

 findIsFavourited(String id) async {
  final Database db = await initDatabase();
  var res  = await db.query("posts",where: "postId = ?",whereArgs: [id]);

  return res.isNotEmpty ? res.first['isFavourite'] : null;
}

Future<void> deleteDatabase(String name) async {
  final Database db = await initDatabase();
  db.delete(name);
}