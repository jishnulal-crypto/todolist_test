import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/app/models/todo.dart';

class DbInitializer {
  DbInitializer();
  Future<DbInitializer> initDB() async {
    await initializeDb();
    return this;
  }

  late Future<Database> database;

  Future<void> initializeDb() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'selso.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, done INTEGER, name TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> insertTodo(Todo dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'todo',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Todo>> todos() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('todo');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Todo(
        done: maps[i]['done'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }

  Future<void> updateDog(Todo todo, String name) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'todo',
      todo.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'name = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }

  Future<void> deleteDog(String name) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'todo',
      // Use a `where` clause to delete a specific dog.
      where: 'name = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}

// void main() async {
//   // Avoid errors caused by flutter upgrade.
//   // Importing 'package:flutter/widgets.dart' is required.
//   WidgetsFlutterBinding.ensureInitialized();
//   // Open the database and store the reference.


//   // Create a Dog and add it to the dogs table
//   var fido = const Dog(
//     id: 0,
//     name: 'Fido',
//     age: 35,
//   );

//   await insertDog(fido);

//   // Now, use the method above to retrieve all the dogs.
//   print(await dogs()); // Prints a list that include Fido.

//   // Update Fido's age and save it to the database.
//   fido = Dog(
//     id: fido.id,
//     name: fido.name,
//     age: fido.age + 7,
//   );
//   await updateDog(fido);

//   // Print the updated results.
//   print(await dogs()); // Prints Fido with age 42.

//   // Delete Fido from the database.
//   await deleteDog(fido.id);

//   // Print the list of dogs (empty).
//   print(await dogs());
// }
