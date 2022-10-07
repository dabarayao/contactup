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
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("pictures/contact_up.png"),
                              fit: BoxFit.cover)),
                      child: Text(""),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Accueil'),
                      selected: true,
                      selectedColor: const Color(0xFFF2B538),
                      selectedTileColor:
                          const Color(0xFFF2B538).withOpacity(0.2),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/addContact');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: const Text('Mes favoris'),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outlined),
                      title: const Text('A propos'),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Paramètres'),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                  ],
                ),
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
