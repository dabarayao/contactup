// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage; // Importing the cacchedNetworkImage module
import 'package:flutter/material.dart'
    show
        AlertDialog,
        AppBar,
        BoxDecoration,
        BuildContext,
        Card,
        Center,
        CircularProgressIndicator,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FutureBuilder,
        Icon,
        IconButton,
        Icons,
        ListTile,
        MainAxisAlignment,
        MediaQuery,
        ModalRoute,
        Navigator,
        Padding,
        PopupMenuButton,
        PopupMenuDivider,
        PopupMenuEntry,
        PopupMenuItem,
        Row,
        Scaffold,
        SingleChildScrollView,
        SizedBox,
        Text,
        TextAlign,
        TextButton,
        TextStyle,
        Widget,
        showDialog;
import 'package:share_plus/share_plus.dart'
    show Share; // Importing the share_plus module
import 'package:flutter_hooks/flutter_hooks.dart'
    show
        HookWidget,
        useEffect,
        useFuture,
        useMemoized; // Importing the flutter_hooks module
import 'package:url_launcher/url_launcher.dart'
    show launchUrl; // Importing the url_launcher module

// import 'dart:io';
import 'dart:async';
import 'dart:convert' show jsonDecode;
// import 'package:image_picker/image_picker.dart';
import 'package:basic_utils/basic_utils.dart'
    show StringUtils; // Importing the basic_utils module
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences; // Importing the shared_preferences module
import 'dart:io' show Platform;
import 'package:http/http.dart' as http
    show get, Client; // Importing the http module

bool _darkTheme = false; // The boolean for the dark theme of the application

/* The contact field as Argument for the Editing route */
var idField;
var nomField;
var prenomsField;
var phoneField;
var emailField;
var photoField;

/* Future which displays the details of the contact */
Future<Contact> fetchContact(contactId, context, route) async {
  final response = await http
      .get(Uri.parse('https://contactup.dabarayao.com/contact/show/$contactId'))
      .timeout(
    const Duration(seconds: 1),
    onTimeout: () {
      // Time has run out, do what you wanted to do.
      Navigator.of(context).pushNamedAndRemoveUntil(
          route != null ? '/$route' : 'home', (route) => false);

      throw ("big error 404"); // Request Timeout response status code
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    idField = jsonDecode(response.body)["id"];
    nomField = jsonDecode(response.body)["nom"];
    prenomsField = jsonDecode(response.body)["prenoms"];
    phoneField = jsonDecode(response.body)["phone"];
    emailField = jsonDecode(response.body)["email"];
    photoField = jsonDecode(response.body)["photo"];

    return Contact.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

/*The contact class which formats the Datas */
class Contact {
  final int id;
  final String nom;
  final String prenoms;
  final String email;
  final String phone;
  final String photo;
  final bool isFav;

  const Contact({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.email,
    required this.phone,
    required this.photo,
    required this.isFav,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prenoms: json['prenoms'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] ?? "aucun",
      isFav: json['is_fav'] == 1 ? true : false,
    );
  }
}

// Main class for adding contact
class ViewContact extends HookWidget {
  ViewContact({super.key});

  var sysLng = Platform.localeName.split('_')[
      0]; // The variable which contains the current language of the application

  @override
  Widget build(BuildContext context) {
    var routesArg = ModalRoute.of(context)!.settings.arguments
        as Map; // variable to catch the route's arguments
    final future = useMemoized(SharedPreferences
        .getInstance); // Hook variable which loads all the sharePreferences written on the disk
    final snapshot = useFuture(future,
        initialData:
            null); // Hook variable which catches the datas of the sharePreferences

    // future to delete the contact
    Future<void> delContact(http.Client client, contactId) async {
      final response = await client.get(
          Uri.parse('https://contactup.dabarayao.com/delcontact/$contactId'),
          headers: {
            "Connection": "Keep-Alive",
            "Keep-Alive": "timeout=5, max=1000"
          });

      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

      // Use the compute function to run parsePhotos in a separate isolate.
    }

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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title:
              Text(sysLng == "fr" ? "Détails du contact" : "Display contact"),
          backgroundColor: Color(0XFF1F1F30),
          actions: [
            IconButton(
              onPressed: () {
                Share.share("""Nom: $nomField
Prénoms: $prenomsField
Phone: $phoneField
Email: $emailField
""", subject: sysLng == "fr" ? 'Mes coordonnés' : 'My person details');
              },
              icon: Icon(Icons.share),
            ),
            PopupMenuButton(
              color: _darkTheme ? Color(0XFF1F1F30) : null,
              onSelected: (value) {
                print("the value is ${value}");

                if (value == "delete") {
                  showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
                      title: Text(
                          sysLng == "fr" ? 'Suppression ❌' : 'Deletion ❌',
                          style: TextStyle(
                              color: _darkTheme ? Colors.white : null)),
                      content: Text(
                          sysLng == "fr"
                              ? 'Etes-vous sûre de vouloir supprimer ce contact?'
                              : 'Are you sure to delete this contact ?',
                          style: TextStyle(
                              color: _darkTheme ? Colors.white : null)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text(sysLng == "fr" ? 'Annuler' : 'Cancel',
                              style: TextStyle(color: Color(0xFFff474c))),
                        ),
                        TextButton(
                          onPressed: () =>
                              delContact(http.Client(), routesArg['id']),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else if (value == "edit") {
                  Navigator.pushNamed(context, '/editContact', arguments: {
                    'id': idField,
                    'nom': nomField,
                    'prenoms': prenomsField,
                    'email': emailField,
                    'photo': photoField == null
                        ? ""
                        : "http://10.0.2.2:8000$photoField",
                    'phone': phoneField,
                  });
                }
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(children: [
                    Icon(
                      Icons.edit,
                      color: _darkTheme ? Color(0xFFF2B538) : Color(0XFF1F1F30),
                    ),
                    Text(sysLng == "fr" ? ' Modifier' : ' Edit',
                        style: TextStyle(
                          color: _darkTheme ? Colors.white : null,
                        )),
                  ]),
                  value: 'edit',
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(children: [
                    const Icon(Icons.delete, color: Color(0xFFff474c)),
                    Text(sysLng == "fr" ? ' Supprimer' : ' Delete',
                        style: TextStyle(
                          color: _darkTheme ? Colors.white : null,
                        )),
                  ]),
                  value: 'delete',
                ),
              ],
            )
          ]),
      body: SingleChildScrollView(
          // A widget to enable scrolling on the page
          child: FutureBuilder<Contact>(
              future:
                  fetchContact(routesArg["id"], context, routesArg["route"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Color(0xFFF2B538)),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            SizedBox(height: 20),
                            Column(
                              children: [
                                SizedBox(
                                    height: 160,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://10.0.2.2:8000${snapshot.data!.photo}",
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.person_outline,
                                              size: 160,
                                              color: Color(0XFF1F1F30)),
                                    ) //load image from file
                                    ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        """${StringUtils.capitalize(snapshot.data!.prenoms)} \n ${StringUtils.capitalize(snapshot.data!.nom)}""",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: _darkTheme ? Color(0XFF1F1F30) : null,
                          elevation: 8,
                          child: ListTile(
                            onTap: () {
                              launchUrl(
                                  Uri.parse("tel:${snapshot.data!.phone}"));
                            },
                            textColor: _darkTheme ? Colors.white : null,
                            leading: const Icon(
                              Icons.phone,
                              size: 28,
                              color: Color(0xFFF2B538),
                            ),
                            title: Text(snapshot.data!.phone),
                            subtitle: Text(
                                sysLng == "fr" ? 'Mobile' : 'Primary number'),
                            trailing: IconButton(
                                icon: const Icon(
                                  Icons.messenger,
                                  color: Color(0xFFF2B538),
                                ),
                                onPressed: () {
                                  launchUrl(
                                      Uri.parse("sms:${snapshot.data!.phone}"));
                                }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: _darkTheme ? Color(0XFF1F1F30) : null,
                          elevation: 8,
                          child: ListTile(
                            onTap: () {
                              launchUrl(
                                  Uri.parse("mailto:${snapshot.data!.email}"));
                            },
                            textColor: _darkTheme ? Colors.white : null,
                            leading: const Icon(
                              Icons.mail,
                              size: 28,
                              color: Color(0xFFF2B538),
                            ),
                            title: Text(snapshot.data!.email),
                            subtitle: const Text('Email'),
                          ),
                        ),
                      )
                    ],
                  );
                }

                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF2B538)));
              })),
    );
  }
}

/*
Developped by Yao Dabara Mickael
phone: +2250779549937
email: dabarayao@gmail.com
telegram: @yiox2048
 */