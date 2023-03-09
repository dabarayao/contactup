// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart'
    show
        AppBar,
        AssetImage,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Color,
        Colors,
        DecorationImage,
        Drawer,
        DrawerHeader,
        EdgeInsets,
        Icon,
        Icons,
        ListTile,
        ListView,
        Navigator,
        RadioListTile,
        Scaffold,
        SimpleDialog,
        State,
        StateSetter,
        StatefulBuilder,
        StatefulWidget,
        Switch,
        Text,
        TextStyle,
        Widget,
        showDialog;
import 'package:flutter/services.dart' show Color, rootBundle;
import 'package:shared_preferences/shared_preferences.dart' // Importing sharedPreferences module
    show
        SharedPreferences; // Importing sharedPreferences module
import 'package:share_plus/share_plus.dart'
    show Share; // Importing share_plus module
import 'package:path_provider/path_provider.dart'
    show getTemporaryDirectory; // Importing path_provider module
import 'dart:io' show File, Platform;

bool _darkTheme = false; // The boolean for the dark theme of the application

//  Future to share the application
// Future<void> shareApp() async {
//   final bytes = await rootBundle.load('assets/apk/contactup.apk');
//   final list = bytes.buffer.asUint8List();

//   final tempDir = await getTemporaryDirectory();
//   final file = await File('${tempDir.path}/contactup.apk').create();
//   file.writeAsBytesSync(list);

//   Share.shareFiles([(file.path)]);
// }

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadLang();
  }

  var sysLng = Platform.localeName.split('_')[
      0]; // The variable which contains the current language of the application
  var setLang = Platform.localeName.split('_')[0] == "fr"
      ? "fr"
      : "en"; // Variable for the radio tile

  //Loading theme value on start
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkTheme = (prefs.getBool('darkTheme') ?? false);
    });
  }

  //Loading language value on start
  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sysLng = (prefs.getString('lang') ?? Platform.localeName.split('_')[0]);
      setLang = sysLng;
    });
  }

  //Incrementing counter after click
  Future<void> _changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkTheme = (prefs.getBool('darkTheme') ?? false) == true ? false : true;
      prefs.setBool('darkTheme', _darkTheme);
    });
  }

  //Incrementing counter after click
  Future<void> _changeLang(lang) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sysLng = lang;
      prefs.setString('lang', lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
        appBar: AppBar(
          title: Text(sysLng == "fr" ? 'Paramètres' : 'Settings'),
          backgroundColor: Color(0XFF1F1F30),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
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
                leading: Icon(Icons.home_outlined,
                    color: _darkTheme ? Colors.blueGrey : null),
                textColor: _darkTheme ? Colors.white : null,
                title: Text(sysLng == "fr" ? 'Accueil' : 'Home'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.pushNamed(context, '/');
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite_outline,
                    color: _darkTheme ? Colors.blueGrey : null),
                textColor: _darkTheme ? Colors.white : null,
                title: Text(sysLng == "fr" ? 'Mes favoris' : 'My favorites'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.pushNamed(context, '/favsContact');
                },
              ),
              ListTile(
                leading: Icon(Icons.archive_outlined,
                    color: _darkTheme ? Colors.blueGrey : null),
                textColor: _darkTheme ? Colors.white : null,
                title: const Text('Archive'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.pushNamed(context, '/archsContact');
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outlined,
                    color: _darkTheme ? Colors.blueGrey : null),
                textColor: _darkTheme ? Colors.white : null,
                title: Text(sysLng == "fr" ? 'A propos' : 'About'),
                onTap: () {
                  // Update the state of the app.
                  // ...

                  Navigator.pushNamed(context, '/aboutContact');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text(sysLng == "fr" ? 'Paramètres' : 'Settings'),
                selected: true,
                selectedColor: const Color(0xFFF2B538),
                selectedTileColor: const Color(0xFFF2B538).withOpacity(0.2),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return SimpleDialog(
                            backgroundColor:
                                _darkTheme ? Color(0XFF1F1F30) : null,
                            title: Text(
                                sysLng == "fr"
                                    ? "Choisir une langue"
                                    : "Choose a language",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: _darkTheme ? Colors.white : null)),
                            children: [
                              RadioListTile(
                                activeColor: Color(0xFFF2B538),
                                title: Text(
                                    sysLng == "fr" ? "Français" : "French",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            _darkTheme ? Colors.white : null)),
                                value: "fr",
                                groupValue: setLang,
                                onChanged: (value) {
                                  setState(() {
                                    setLang = "fr";
                                  });
                                  _changeLang("fr");
                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile(
                                activeColor: Color(0xFFF2B538),
                                title: Text(
                                    sysLng == "fr" ? "Anglais" : "English",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            _darkTheme ? Colors.white : null)),
                                value: "en",
                                groupValue: setLang,
                                onChanged: (value) {
                                  setState(() {
                                    setLang = "en";
                                  });
                                  _changeLang("en");
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        }));
              },
              textColor: _darkTheme ? Colors.white : null,
              leading: Icon(Icons.language,
                  color: _darkTheme ? Colors.blueGrey : null),
              title: Text(sysLng == "fr" ? 'Langue' : 'Language'),
            ),
            ListTile(
                onTap: () {
                  _changeTheme();
                },
                textColor: _darkTheme ? Colors.white : null,
                leading: Icon(Icons.color_lens_outlined,
                    color: _darkTheme ? Colors.blueGrey : null),
                title: Text(sysLng == "fr" ? 'Thème sombre' : 'Dark theme'),
                trailing:
                    // IconButton(
                    //     onPressed: () {
                    //       _changeTheme();
                    //     },
                    //     icon: _darkTheme
                    //         ? Icon(Icons.toggle_on,
                    //             size: 35, color: Color(0xFFF2B538))
                    //         : Icon(Icons.toggle_off, size: 35)),
                    Switch(
                  value: _darkTheme,
                  activeColor: Color(0xFFF2B538),
                  onChanged: (value) {
                    setState(() {
                      _changeTheme();
                    });
                  },
                )),
            ListTile(
              onTap: () {
                Share.share(
                    "https://drive.google.com/drive/folders/1m8wF7GT0vt5qMiL-ANXgRANeU23RyApW?usp=share_link",
                    subject: sysLng == "fr"
                        ? "Contactup - Enregistrer et suivez vos contacts"
                        : "Contactup - Save and track your contacts");
              },
              textColor: _darkTheme ? Colors.white : null,
              leading: Icon(
                Icons.share_outlined,
                color: _darkTheme ? Colors.blueGrey : null,
              ),
              title: Text(
                  sysLng == "fr" ? "Partager l'application" : "Share the app"),
            ),
          ],
        ));
  }
}

/*
Developped by Yao Dabara Mickael
phone: +2250779549937
email: dabarayao@gmail.com
telegram: @yiox2048
 */