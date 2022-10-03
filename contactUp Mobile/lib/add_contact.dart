import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

String baseimage = ""; // image chosen converted in binary
var uploadimage; // variable of the image chose in the gallery or camera
bool contactServer =
    false; // this variable check if the online server is reached

AutovalidateMode contactValid =
    AutovalidateMode.disabled; // Variable of Autovalidation of the form

// Main class for adding contact
class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

// State of the main class for adding contact
class _AddContactState extends State<AddContact> {
  // Editin's variable to catch formfield's datas
  TextEditingController lastNamesController = TextEditingController();
  TextEditingController firstNamesController = TextEditingController();
  TextEditingController phoneNumberTemplateController = TextEditingController();
  TextEditingController emailAddressTemplateController =
      TextEditingController();

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

  final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Ajouter un contact"),
        backgroundColor: Color(0XFF1F1F30),
      ),
      body: Padding(
        // a padding which move avay the widget from the edge
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: SingleChildScrollView(
            // A widget to enable scrolling on the page
            child: Form(
          // A form to save the contact's datas
          key: _formKey,
          autovalidateMode: contactValid,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: uploadimage != null
                    ? SizedBox(
                        height: 120,
                        child: Image.file(
                          File(uploadimage!.path),
                        ) //load image from file
                        )
                    : const Text(""),
              ),
              TextFormField(
                controller: lastNamesController,
                maxLines: 1, // want getLastNames() here but can't
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(
                width: 10,
                height: 20,
              ),
              TextFormField(
                controller: firstNamesController,
                decoration: const InputDecoration(
                  labelText: 'Prénoms',
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre prénoms';
                  }
                  return null;
                },
              ),
              const SizedBox(
                width: 10,
                height: 30,
              ),
              TextFormField(
                controller: phoneNumberTemplateController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre numéro téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(
                width: 10,
                height: 20,
              ),
              TextFormField(
                controller: emailAddressTemplateController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre adresse email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                width: 10,
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: Align(
                      // ignore: sort_child_properties_last
                      child: IconButton(
                        icon: const Icon(
                          Icons.photo,
                          color: Color(0XFF40BCD0),
                          size: 30,
                        ),
                        color: Colors.black,
                        onPressed: () {
                          // Respond to icon toggle
                          chooseImage();
                        },
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: Align(
                      // ignore: sort_child_properties_last
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera,
                          color: Color(0XFF40BCD0),
                          size: 30,
                        ),
                        color: Colors.black,
                        onPressed: () {
                          // Respond to icon toggle
                          captureImage();
                        },
                      ),
                      alignment: Alignment.center,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF2B538), onPrimary: Color(0XFF142641)),
                  onPressed: () {
                    setState(() {
                      contactValid = AutovalidateMode.onUserInteraction;
                    }); //

                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, the create data Future to save the datas.

                      // If there is network, the datas are saved or else an alert error is shown
                      http.get(Uri.parse('http://10.0.2.2:8000/')).timeout(
                        const Duration(seconds: 1),
                        onTimeout: () {
                          // Time has run out, do what you wanted to do.
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Internet error 🌍'),
                              content: const Text(
                                  'Vérifiez votre connexion internet'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          throw ("big error 404"); // Request Timeout response status code
                        },
                      ).whenComplete(() {
                        createContact(
                            lastNamesController.text,
                            firstNamesController.text,
                            emailAddressTemplateController.text,
                            phoneNumberTemplateController.text,
                            uploadimage,
                            context);
                      });
                    }
                  },
                  child:
                      const Text("Enregistrer", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
