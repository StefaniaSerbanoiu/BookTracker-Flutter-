import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyBookApp());
}

class MyBookApp extends StatelessWidget {
  const MyBookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookTracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}
