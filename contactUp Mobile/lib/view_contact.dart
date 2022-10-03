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

  Future<void> createContact(
      nom, prenoms, email, phone, upimage, context) async {
    var postUri = Uri.parse(
        "http://10.0.2.2:8000/contact"); // this variable catches the url of the server where the contact will be saved

    http.MultipartRequest request = http.MultipartRequest("POST",
        postUri); // this http mulipartrequest variable creates a post instance to the server

    // the datas which will be sent to the server
    request.fields["nom"] = nom;
    request.fields["prenoms"] = prenoms;
    request.fields["email"] = email;
    request.fields["phone"] = phone;

    if (upimage != null) {
      List<int> imageBytes = await upimage.readAsBytes();
      baseimage = base64Encode(imageBytes);

      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('image', upimage!.path);
      request.files.add(multipartFile);
    }

    // this http streamresponse variable make it possible to send all data to the server if everything is ok
    // ignore: unused_local_variable
    final http.StreamedResponse response = await request.send();

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
    var routes = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Détails du contact"),
          backgroundColor: Color(0XFF1F1F30),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, size: 28),
              color: Colors.white,
              onPressed: () {
                // Respond to icon toggle
              },
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
                            imageUrl: routes['photo']!,
                          ) //load image from file
                          ),
                      Text(
                        """${StringUtils.capitalize(routes['prenoms']!)} \n ${StringUtils.capitalize(routes['nom']!)}""",
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
                title: Text('${routes['phone']!}'),
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
                title: Text('${routes['email']!}'),
                subtitle: const Text('Email'),
              ),
            )
          ],
        )),
      ),
    );
  }
}
