import 'dart:async';
import 'package:flutter/material.dart';
import 'Repository.dart';

class BookModel extends ChangeNotifier {
  List<Map<String, dynamic>> _books = [];
  StreamController<List<Map<String, dynamic>>> _booksController =
  StreamController<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get booksStream =>
      _booksController.stream;

  List<Map<String, dynamic>> get books => _books;

  void setBooks(List<Map<String, dynamic>> books) {
    _books = books;
    _booksController.add(_books); // Notify the stream listeners
    notifyListeners(); // Ensure that this is called
  }

  void dispose() {
    _booksController.close();
    super.dispose();
  }
}
