// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'dart:io';
import 'dart:async';
import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

import '../view/view_contact.dart';

bool _darkTheme = false;

var isFavorite = null;

var idField;
var nomField;
var prenomsField;
var phoneField;
var emailField;
var photoField;

Future<Contact> fetchContact(contactId, context, route) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:8000/contact/show/$contactId'))
      .timeout(
    const Duration(seconds: 1),
    onTimeout: () {
      // Time has run out, do what you wanted to do.
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/$route', (route) => false);

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
class ViewContact extends StatefulWidget {
  const ViewContact({super.key});

  @override
  State<ViewContact> createState() => _ViewContactState();
}

// State of the main class for adding contact
class _ViewContactState extends State<ViewContact> {
  /* Future to create the contacts.
   The future takes all the datas in the form and send them to a server in order to be saved
*/
  // future to delete the contact
  Future<void> delContact(http.Client client, contactId) async {
    final response = await client
        .get(Uri.parse('http://10.0.2.2:8000/delcontact/$contactId'), headers: {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000"
    });

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);

    // Use the compute function to run parsePhotos in a separate isolate.
  }

/*
  // Future to take an image from the gallery
  Future<void> chooseImage() async {
    var choosedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }

  // Future to create a capture an image with the camera
  Future<void> captureImage() async {
    var choosedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }
  */

  @override
  initState() {
    super.initState();
    // we restore all this widget when the page is loaded
    _loadTheme();
    _loadLang();
  }

  var sysLng = Platform.localeName.split('_')[0];

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
    });
  }

  @override
  Widget build(BuildContext context) {
    var routesArg = ModalRoute.of(context)!.settings.arguments
        as Map; // variable to catch the route's arguments

    if (isFavorite == null) {
      if (routesArg["isFav"] == true) {
        setState(() {
          isFavorite = true;
        });
      } else {
        setState(() {
          isFavorite = false;
        });
      }
    }

    return Scaffold(
      backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title:
              Text(sysLng == "fr" ? "Détails du contact" : "Display contact"),
          backgroundColor: Color(0XFF1F1F30),
          actions: [
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
                        ? "http://10.0.2.2:8000aucun"
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
                      color: _darkTheme ? Color(0xFFF2B538) : null,
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
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.person_outline,
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
                                        style: TextStyle(
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
                              launch("tel:${snapshot.data!.phone}");
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
                                  launch("sms:${snapshot.data!.phone}");
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
                              launch("mailto:${snapshot.data!.email}");
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

                return Center(
                    child: const CircularProgressIndicator(
                        color: Color(0xFFF2B538)));
              })),
    );
  }
}
