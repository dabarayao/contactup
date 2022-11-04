/*This is the main page where all windows are located */

import 'package:flutter/material.dart'
    show BuildContext, MaterialApp, State, StatefulWidget, Widget, runApp;
import 'add_edit/add_contact.dart';
import 'add_edit/edit_contact.dart';
import 'contact_list/contact_list.dart';
import 'contact_list/fav_contact.dart';
import 'view/view_contact.dart';
import './contact_list/arch_contact.dart';
import './about_settings/about.dart';
import './about_settings/settings.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider; // Importing provider module
import './splashPage.dart';

// The main class which run the app
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalSearch()),
        ChangeNotifierProvider(create: (_) => LoadContact()),
        ChangeNotifierProvider(create: (_) => GlobalSearchFav()),
        ChangeNotifierProvider(create: (_) => LoadContactFav()),
        ChangeNotifierProvider(create: (_) => GlobalSearchArch()),
        ChangeNotifierProvider(create: (_) => LoadContactArch()),
        ChangeNotifierProvider(create: (_) => SelectedContacts()),
      ],
      child: MyApp(),
    ),
  );
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
    // The materialApp widget with all routes for the application
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact up', // the name of the material page
      initialRoute: '/',
      routes: {
        // When navigating to the "/home" route, build the FirstScreen widget.
        '/': (context) => ContactList(),

        // When navigating to the "/addContact" route, build the  AddContact widget.
        '/addContact': (context) => AddContact(),
        '/editContact': (context) => EditContact(),
        '/viewContact': (context) => ViewContact(),
        '/favsContact': (context) => FavContactList(),
        '/archsContact': (context) => ArchContactList(),
        '/aboutContact': (context) => AboutPage(),
        '/settingContact': (context) => SettingPage(),
      },
      // When navigating to the "/addContact" route, build the  AddContact widget.
    );
  }
}

/*
Developped by Yao Dabara Mickael
phone: +2250779549937
email: dabarayao@gmail.com
telegram: @yiox2048
 */