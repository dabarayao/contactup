// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

bool _darkTheme = false;

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

  var sysLng = Platform.localeName.split('_')[0];
  var setLang = Platform.localeName.split('_')[0] == "fr" ? "fr" : "en";

  //Loading counter value on start
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkTheme = (prefs.getBool('darkTheme') ?? false);
    });
  }

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
                  Navigator.pushNamed(context, '/home');
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
              onTap: () {},
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

// Class to set a pattern for the contacts.
