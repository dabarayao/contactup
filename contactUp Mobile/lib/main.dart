import 'package:flutter/material.dart';
import 'add_edit/add_contact.dart';
import 'add_edit/edit_contact.dart';
import 'contact_list/contact_list.dart';
import 'contact_list/fav_contact.dart';
import 'view/view_contact.dart';
import './splashPage.dart';
import './contact_list/arch_contact.dart';
import './about_settings/about.dart';
import './about_settings/settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalSearch()),
      ],
      child: const MyApp(),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact up', // the name of the material page
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        // When navigating to the "/home" route, build the FirstScreen widget.
        '/home': (context) => ContactList(),

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
