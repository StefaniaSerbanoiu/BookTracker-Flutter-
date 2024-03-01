import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createBooksTableInDatabase(sql.Database database) async{
    await database.execute(""
        "CREATE TABLE books"
        "("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "title TEXT,"
        "year INT,"
        "author TEXT,"
        "genres TEXT,"
        "rating DOUBLE"
        ")"
        "");
  }

  static Future<sql.Database> bookDB() async{
    return sql.openDatabase( // returns a database object
      'book_tracker.db', // checking if this database exists; if not, it will then be created
      version: 1,
      onCreate: (sql.Database database, int version) async{
        await createBooksTableInDatabase(database);
      },
    );
  }

  static Future<int> insertBookInDB(String title, int year, String author, String genres, double rating) async {
    final db = await SQLHelper.bookDB(); // the database with books

    final newBook = {'title': title,
        'year': year,
        'author' : author,
        'genres' : genres,
        'rating' : rating}; // the book will be inserted as a map
    final id = await db.insert('books',
        newBook,
        conflictAlgorithm: sql.ConflictAlgorithm.replace); // in case of duplicated rows, the new one will be added ( and the old one removed)

    return id; // returns the id of the created book
  }

  static Future<List<Map<String, dynamic>>> getAllBooks() async{
    final db = await SQLHelper.bookDB(); // the book database

    return db.query('books', orderBy: "id"); // returns all books from the database table
                // the books will be sorted in an ascending order by their id
                // (the order in which they were created)
  }

  static Future<List<Map<String, dynamic>>> getBookById(int id) async{
    final db = await SQLHelper.bookDB(); // the book database
    return db.query('books', where : "id = ?",
        whereArgs: [id],
        limit: 1); // returns the first book with a specific given id
  }

  static Future<int> updateBook(int id, String title, String author, int year, double rating, String genres) async{
    final db = await SQLHelper.bookDB(); // the book database

    final book = {
      'title' : title,
      'year' : year,
      'author' : author,
      'genres' : genres,
      'rating' : rating
    }; // creating a map with the updated book information

    final updateOperationChanges = await db.update('books', book,
        where : "id = ?",
        whereArgs : [id]); // perform a query in the db in which the book with the given id is updated with the new info from 'book'

    return updateOperationChanges; // returns the number of changes resulted in the database after the update operation
  }

  static Future<void> deleteBook(int id) async{
    final db = await SQLHelper.bookDB(); // book database
    try{
      await db.delete('books',
          where : "id = ?",
          whereArgs : [id]); // deletes from the database the book with the given id
    }
    catch(error){
      debugPrint("Error!!! Couldn't delete book from database!$error"); // print error
    }
  }
}