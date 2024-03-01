import 'package:flutter/material.dart';
import 'Repository.dart';

class UpdateBookScreen extends StatelessWidget {
  final Map<String, dynamic> book;
  final Function()? onUpdated;

  const UpdateBookScreen({Key? key, required this.book, this.onUpdated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController(text: book['title']);
    final _yearController = TextEditingController(text: book['year'].toString());
    final _authorController = TextEditingController(text: book['author']);
    final _genresController = TextEditingController(text: book['genres']);
    final _ratingController =
    TextEditingController(text: book['rating'].toString());

    return Scaffold(
      backgroundColor: Color(0xFF714B85),
      appBar: AppBar(
        title: Text('Update Book'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(hintText: 'Year of publication'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(hintText: 'Author'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _genresController,
              decoration: const InputDecoration(hintText: 'Genres'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _ratingController,
              decoration: const InputDecoration(hintText: 'Rating'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                int year = int.tryParse(_yearController.text) ?? 0;
                double rating = double.tryParse(_ratingController.text) ?? 0.0;

                // Validate year and rating
                if (year <= 0 || year > 2023 || rating < 1 || rating > 10) {
                  // Show a SnackBar with an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Invalid year or rating. Year must be positive and maximum 2023, and rating must be between 1 and 10.',
                      ),
                    ),
                  );
                  return;
                }

                await SQLHelper.updateBook(
                  book['id'],
                  _titleController.text,
                  _authorController.text,
                  year,
                  rating,
                  _genresController.text,
                );

                _titleController.clear();
                _yearController.clear();
                _authorController.clear();
                _genresController.clear();
                _ratingController.clear();

                Navigator.of(context).pop();
                onUpdated?.call();
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
