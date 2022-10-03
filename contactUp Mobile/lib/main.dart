import 'dart:async';

import 'package:flutter/material.dart';
import "./add_contact.dart";
import "./contact_list.dart";
import './view_contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact up', // the name of the material page
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Scaffold(
              appBar: AppBar(
                title: Text("Contact Up"),
                backgroundColor: Color(0XFF1F1F30),
                actions: [
                  Builder(builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.add, size: 28),
                      color: Colors.white,
                      onPressed: () {
                        // Respond to icon toggle
                        Navigator.pushNamed(context, '/addContact');
                      },
                    );
                  })
                ],
              ),
              body: ContactList(),
            ),
        // When navigating to the "/addContact" route, build the  AddContact widget.
        '/addContact': (context) => const AddContact(),
        '/viewContact': (context) => const ViewContact(),
      },
      // When navigating to the "/addContact" route, build the  AddContact widget.
    );
  }
}
