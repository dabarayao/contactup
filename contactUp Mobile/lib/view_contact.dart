// ignore_for_file: sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// import 'dart:io';
import 'dart:async';
import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
import 'package:basic_utils/basic_utils.dart';

import 'package:http/http.dart' as http;

String baseimage = ""; // image chosen converted in binary
var uploadimage; // variable of the image chose in the gallery or camera
bool contactServer =
    false; // this variable check if the online server is reached

AutovalidateMode contactValid =
    AutovalidateMode.disabled; // Variable of Autovalidation of the form

// Main class for adding contact
class ViewContact extends StatefulWidget {
  const ViewContact({super.key});

  @override
  State<ViewContact> createState() => _ViewContactState();
}

// State of the main class for adding contact
class _ViewContactState extends State<ViewContact> {
  // Editin's variable to catch formfield's datas

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

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

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
    setState(() {
      uploadimage = null;
      contactServer = false;
      contactValid = AutovalidateMode.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    var routesArg = ModalRoute.of(context)!.settings.arguments
        as Map; // variable to catch the route's arguments

    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Détails du contact"),
          backgroundColor: Color(0XFF1F1F30),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                print("the value is ${value}");

                if (value == "delete") {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Suppression 🗑️'),
                      content: const Text(
                          'Etes-vous sûre de vouloir supprimer ce contact?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('Annuler'),
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
                  Navigator.pushNamed(context, '/addContact', arguments: {
                    'id': routesArg['id'],
                    'nom': routesArg['nom'],
                    'prenoms': routesArg['prenoms'],
                    'email': routesArg['email'],
                    'phone': routesArg['phone'],
                    'photo': routesArg['photo'],
                  });
                }
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(children: [
                    const Icon(Icons.favorite, color: Color(0xFFF2B538)),
                    const Text(' Ajouter au favoris'),
                  ]),
                  value: 'favs',
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(children: [
                    const Icon(Icons.edit, color: Color(0XFF1F1F30)),
                    const Text(' Modifier'),
                  ]),
                  value: 'edit',
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(children: [
                    const Icon(Icons.delete, color: Color(0xFFff474c)),
                    const Text(' Supprimer'),
                  ]),
                  value: 'delete',
                ),
              ],
            )
          ]),
      body: Padding(
        // a padding which move avay the widget from the edge
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: SingleChildScrollView(
            // A widget to enable scrolling on the page
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(
                          width: 200,
                          child: CachedNetworkImage(
                            imageUrl: routesArg['photo']!,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 120,
                                color: Colors.grey),
                          ) //load image from file
                          ),
                      Text(
                        """${StringUtils.capitalize(routesArg['prenoms']!)} \n ${StringUtils.capitalize(routesArg['nom']!)}""",
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 8,
              child: ListTile(
                leading: const Icon(
                  Icons.phone,
                  size: 28,
                  color: Color(0xFFF2B538),
                ),
                title: Text('${routesArg['phone']!}'),
                subtitle: const Text('Mobile'),
                trailing: IconButton(
                    icon: const Icon(
                      Icons.messenger,
                      color: Color(0xFFF2B538),
                    ),
                    onPressed: () {}),
              ),
            ),
            Card(
              elevation: 8,
              child: ListTile(
                leading: const Icon(
                  Icons.mail,
                  size: 28,
                  color: Color(0xFFF2B538),
                ),
                title: Text('${routesArg['email']!}'),
                subtitle: const Text('Email'),
              ),
            )
          ],
        )),
      ),
    );
  }
}
