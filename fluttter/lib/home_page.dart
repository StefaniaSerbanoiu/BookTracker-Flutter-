import 'package:flutter/material.dart';
import 'add_book_screen.dart';
import 'update_book_screen.dart';
import 'Repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = true;

  void _refresh() async {
    final books = await SQLHelper.getAllBooks();
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF714B85),
      appBar: AppBar(
        title: const Text('Book Tracker'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_books.isEmpty
          ? const Center(child: Text('No books available'))
          : _buildBookList()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  Widget _buildBookList() {
    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return Card(
          color: Colors.purple[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(book['title']),
            subtitle: Text(
              "Published in : ${book['year']}\n"
                  "by ${book['author']}\n"
                  "Genres : ${book['genres']}\n"
                  "Rating : ${book['rating']}/10",
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateBookScreen(book: book, onUpdated: _refresh),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _deleteBook(book['id']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteBook(int id) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss the dialog and return false
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Dismiss the dialog and return true
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await SQLHelper.deleteBook(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book deleted.'),
        ),
      );
      _refresh();
    }
  }

  void _showForm(int? id) async {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => AddBookScreen(onAdded: _refresh),
    );
  }
}