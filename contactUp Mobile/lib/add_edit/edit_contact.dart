import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

String baseimage = ""; // image chosen converted in binary
// var uploadimage;

var redrawTimes = 0;

bool _darkTheme = false;

var uploadimage; // this variable catch the image send by the user

bool uploadCancelled = false;

AutovalidateMode contactValid =
    AutovalidateMode.disabled; // Variable of Autovalidation of the form

// Main class for adding contact
class EditContact extends StatefulWidget {
  const EditContact({super.key});

  @override
  State<EditContact> createState() => _EditContactState();
}

// State of the main class for adding contact
class _EditContactState extends State<EditContact> {
  /* Future to create the contacts.
   The future takes all the datas in the form and send them to a server in order to be saved
*/

  /* Future to update the contact.
   The future takes all the datas in the form and send them to a server in order to be modidiy the contact
*/

  Future<void> updateContact(
      nom, prenoms, email, phone, upimage, id, context) async {
    var postUri = Uri.parse(
        "http://10.0.2.2:8000/contact/edit/$id"); // this variable catches the url of the server where the contact will be saved

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

    if (uploadimage == null) {
      request.fields["delImage"] = "none";
    }

    // this http streamresponse variable make it possible to send all data to the server if everything is ok
    // ignore: unused_local_variable
    final http.StreamedResponse response = await request.send();

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    Navigator.pushNamed(context, '/viewContact', arguments: {
      'id': id,
    });
  }

  // Future to take an image from the gallery
  Future<void> chooseImage(context) async {
    var choosedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera

    setState(() {
      uploadimage = choosedimage;
    });

    Navigator.pop(context, 'OK');
  }

  // Future to create a capture an image with the camera
  Future<void> captureImage(context) async {
    var choosedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    //set source: ImageSource.camera to get image from camera

    setState(() {
      uploadimage = choosedimage;
    });

    Navigator.pop(context, 'OK');
  }

  final _formKey = GlobalKey<FormState>();

  // TextEditing's variable to catch formfield's datas
  TextEditingController lastNamesController = TextEditingController();
  TextEditingController firstNamesController = TextEditingController();
  TextEditingController phoneNumberTemplateController = TextEditingController();
  TextEditingController emailAddressTemplateController =
      TextEditingController();

  @override
  initState() {
    super.initState();
    // we restore all this widget when the page is loaded
    _loadTheme();
    _loadLang();

    setState(() {
      uploadimage = null;
      redrawTimes = 0;
      uploadCancelled = false;
      contactValid = AutovalidateMode.disabled;
    });
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

  // Dialog box in order to pick an image
  imageBrowse() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
        title: Text(sysLng == "fr" ? 'Choisissez une image' : 'Choose an image',
            style: TextStyle(color: _darkTheme ? Colors.white : null)),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              TextButton.icon(
                onPressed: () {
                  // Respond to button press
                  chooseImage(context);
                },
                icon: const Icon(Icons.image, size: 18),
                label:
                    Text(sysLng == "fr" ? 'Aller à gallery' : 'Go to gallery'),
              ),
              TextButton.icon(
                onPressed: () {
                  // Respond to button press
                  captureImage(context);
                },
                icon: const Icon(Icons.camera_enhance, size: 18),
                label: Text(
                    sysLng == "fr" ? "Prendre une photo" : "Take a picture"),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Fermer'),
            child: Text(sysLng == "fr" ? 'Fermer' : 'Close',
                style: TextStyle(color: Color(0xFFff474c))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routesArg = ModalRoute.of(context)!.settings.arguments
        as Map?; // variable to catch the route's arguments

    redrawTimes++;

    // autofill the formField when there's arguments
    if (routesArg != null && redrawTimes <= 1) {
      lastNamesController = TextEditingController(text: routesArg["nom"]);
      firstNamesController = TextEditingController(text: routesArg["prenoms"]);
      phoneNumberTemplateController =
          TextEditingController(text: routesArg["phone"]);
      emailAddressTemplateController =
          TextEditingController(text: routesArg["email"]);
    }

    /* if routesArg is null and uploadimage.runtimeType is Xfile we give the link of existing photo on the server.
    This means the photo haven't been uploaded.
    */
    if (routesArg != null &&
        uploadimage.runtimeType != XFile &&
        uploadCancelled != true) {
      if (routesArg["photo"] == "http://10.0.2.2:8000aucun") {
        uploadimage = null;
      } else {
        uploadimage = routesArg["photo"];
      }
    }

    return Scaffold(
      backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(sysLng == "fr" ? "Modifier un contact" : "Edit contact"),
        backgroundColor: Color(0XFF1F1F30),
      ),
      body: SingleChildScrollView(
          // A widget to enable scrolling on the page
          child: Form(
        // A form to save the contact's datas
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xFFF2B538)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.32,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      SizedBox(
                          height: 160,
                          child: uploadimage != null
                              ? uploadimage
                                      is XFile // when the variable is string it isn't an upload file
                                  ? Image.file(
                                      File(uploadimage.path),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: uploadimage,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.person_outline,
                                              size: 160,
                                              color: Color(0XFF142641)),
                                    )
                              : const Icon(Icons.person_outline,
                                  size: 160,
                                  color:
                                      Color(0XFF142641)) //load image from file
                          ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          if (uploadimage == null) {
                            imageBrowse();
                          } else {
                            setState(() {
                              uploadimage = null;
                              uploadCancelled = true;
                            });
                          }
                        },
                        icon: Icon(
                            uploadimage == null
                                ? Icons.camera_enhance
                                : Icons.delete,
                            color: Color(0XFF142641))),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: lastNamesController,
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641)),
                decoration: InputDecoration(
                  labelText: sysLng == "fr" ? "Nom" : "Last Name",
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.person,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
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
            ),
            const SizedBox(
              width: 10,
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: firstNamesController,
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641)),
                decoration: InputDecoration(
                  labelText: sysLng == "fr" ? "Prenoms" : "First Name",
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.person,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
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
            ),
            const SizedBox(
              width: 10,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: phoneNumberTemplateController,
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641)),
                decoration: InputDecoration(
                  labelText: sysLng == "fr" ? "Téléphone" : "Phone",
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.phone,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
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
            ),
            const SizedBox(
              width: 10,
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: emailAddressTemplateController,
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641)),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.mail,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFF142641), width: 2.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
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
            ),
            const SizedBox(
              width: 10,
              height: 20,
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
                            content:
                                const Text('Vérifiez votre connexion internet'),
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
                      // if routes args is null, it is we use the future createContact else we use the future updateContact

                      if (uploadimage is String || uploadimage == null) {
                        updateContact(
                            lastNamesController.text,
                            firstNamesController.text,
                            emailAddressTemplateController.text,
                            phoneNumberTemplateController.text,
                            null,
                            routesArg!["id"],
                            context);
                      } else {
                        updateContact(
                            lastNamesController.text,
                            firstNamesController.text,
                            emailAddressTemplateController.text,
                            phoneNumberTemplateController.text,
                            uploadimage,
                            routesArg!["id"],
                            context);
                      }
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
    );
  }
}
