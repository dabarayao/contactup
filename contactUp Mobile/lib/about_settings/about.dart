import 'package:flutter/material.dart'
    show
        AppBar,
        AssetImage,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Center,
        Color,
        Colors,
        Column,
        CrossAxisAlignment,
        DecorationImage,
        Drawer,
        DrawerHeader,
        EdgeInsets,
        FontWeight,
        Icon,
        IconButton,
        Icons,
        Image,
        ListTile,
        ListView,
        MainAxisAlignment,
        Navigator,
        Padding,
        Scaffold,
        SingleChildScrollView,
        SizedBox,
        Text,
        TextStyle,
        Widget;
import 'package:flutter_hooks/flutter_hooks.dart'
    show
        HookWidget,
        useEffect,
        useFuture,
        useMemoized; // Importing flutter_hooks module
import 'package:url_launcher/url_launcher.dart'
    show launchUrl; // Importing url_launcher module
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences; // Importing sharedPreferences module
import 'dart:io' show Platform;

bool _darkTheme = false;

class AboutPage extends HookWidget {
  AboutPage({super.key});

  var sysLng = Platform.localeName.split('_')[
      0]; // The variable which contains the current language of the application

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(SharedPreferences
        .getInstance); // Hook variable which loads all the sharePreferences written on the disk
    final snapshot = useFuture(future,
        initialData:
            null); // Hook variable which catches the datas of the sharePreferences

    // Lifecycle to load the Theme and and the language of the application if they have been saved.
    useEffect(() {
      final prefs = snapshot.data;
      if (prefs == null) {
        return;
      }
      sysLng = (prefs.getString('lang') ?? Platform.localeName.split('_')[0]);
      _darkTheme = (prefs.getBool('darkTheme') ?? false);
      return null;
    }, [snapshot.data]);

    return Scaffold(
        backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
        appBar: AppBar(
          title: Text(sysLng == "fr" ? 'A propos' : 'About'),
          backgroundColor: Color(0XFF1F1F30),
        ),
        drawer: Drawer(
          backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
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
                leading: const Icon(Icons.info_outlined),
                title: Text(sysLng == "fr" ? 'A propos' : 'About'),
                selected: true,
                selectedColor: const Color(0xFFF2B538),
                selectedTileColor: const Color(0xFFF2B538).withOpacity(0.2),
                onTap: () {
                  // Update the state of the app.
                  // ...

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined,
                    color: _darkTheme ? Colors.blueGrey : null),
                textColor: _darkTheme ? Colors.white : null,
                title: Text(sysLng == "fr" ? 'Paramètres' : 'Settings'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.pushNamed(context, '/settingContact');
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset("pictures/contact_up.png", width: 250)),
              SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    sysLng == "fr"
                        ? """ 
                     Contact up est une application créé par le développeur Yao Dabara Mickael. Elle permet de sauvegarder ses contacts téléphonique sur un serveur distant.
                """
                        : "Contact up is a software created by the developer Yao Dabara Mickael. It allows you to save your phone contacts on a remote server.",
                    style: TextStyle(
                      color: _darkTheme ? Colors.white : null,
                    )),
              ),
              Text(
                  sysLng == "fr"
                      ? "Informations du développeur"
                      : "Developer information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _darkTheme ? Colors.white : null,
                  )),
              ListTile(
                textColor: _darkTheme ? Colors.white : null,
                onTap: () {
                  launchUrl(Uri.parse("tel:+2250779549937"));
                },
                leading: const Icon(
                  Icons.info,
                  size: 28,
                  color: Color(0xFFF2B538),
                ),
                title: Text("Yao dabara mickael"),
                subtitle: const Text('+2250779549937'),
                trailing: IconButton(
                    icon: const Icon(
                      Icons.mail,
                      color: Color(0xFFF2B538),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse("mailto:dabarayao@gmail.com"));
                    }),
              )
            ],
          ),
        ));
  }
}

/*
Developped by Yao Dabara Mickael
phone: +2250779549937
email: dabarayao@gmail.com
telegram: @yiox2048
 */