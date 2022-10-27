import 'package:conactup/view/view_contact.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

String baseimage = ""; // image chosen converted in binary
// var uploadimage;
bool contactServer =
    false; // this variable check if the online server is reached

bool _darkTheme = false;

var uploadimage; // this variable catch the image send by the user

bool uploadCancelled = false;

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

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  /* Future to update the contact.
   The future takes all the datas in the form and send them to a server in order to be modidiy the contact
*/

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

  @override
  initState() {
    super.initState();
    // we restore all this widget when the page is loaded
    _loadTheme();
    _loadLang();

    setState(() {
      uploadimage = null;
      contactServer = false;
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
        title: const Text('Choisissez une image'),
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
                label: const Text("Aller à gallery"),
              ),
              TextButton.icon(
                onPressed: () {
                  // Respond to button press
                  captureImage(context);
                },
                icon: const Icon(Icons.camera_enhance, size: 18),
                label: const Text("Prendre une photo"),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Fermer'),
            child: const Text('Fermer',
                style: TextStyle(color: Color(0xFFff474c))),
          ),
        ],
      ),
    );
  }

  // TextEditing's variable to catch formfield's datas
  TextEditingController lastNamesController = TextEditingController();
  TextEditingController firstNamesController = TextEditingController();
  TextEditingController phoneNumberTemplateController = TextEditingController();
  TextEditingController emailAddressTemplateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    /* if routesArg is null and uploadimage.runtimeType is Xfile we give the link of existing photo on the server.
    This means the photo haven't been uploaded.
    */

    return Scaffold(
      backgroundColor: _darkTheme ? Color(0XFF1F1F30) : null,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(sysLng == "fr" ? 'Ajouter un contact' : 'Add a contact'),
        backgroundColor: Color(0XFF1F1F30),
      ),
      body: SingleChildScrollView(
          // A widget to enable scrolling on the page
          child: Form(
        // A form to save the contact's datas
        key: _formKey,
        autovalidateMode: contactValid,
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
                  SizedBox(height: 10),
                  Column(
                    children: [
                      SizedBox(
                          width: 160,
                          height: 160,
                          child: uploadimage != null
                              ? Image.file(File(uploadimage.path))
                              : const Icon(Icons.person_outline,
                                  size: 160, color: Color(0XFF142641))),
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
                    color: _darkTheme
                        ? Colors.white
                        : Color(
                            0XFF142641)), // want getLastNames() here but can't
                decoration: InputDecoration(
                  labelText: sysLng == "fr" ? 'Nom' : 'Last Name',
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.person,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: _darkTheme ? Colors.white : Color(0XFF142641),
                        width: 2.0),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _darkTheme ? Colors.white : Color(0XFF142641)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return sysLng == "fr"
                        ? 'Entrez votre nom'
                        : 'Enter your Last Name';
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
                  color: _darkTheme ? Colors.white : Color(0XFF142641),
                ),
                decoration: InputDecoration(
                  labelText: sysLng == "fr" ? 'Prénoms' : 'First Name',
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.person,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: _darkTheme ? Colors.white : Color(0XFF142641),
                        width: 2.0),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _darkTheme ? Colors.white : Color(0XFF142641)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return sysLng == "fr"
                        ? 'Entrez votre prénoms'
                        : 'Enter your First Name';
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
                  color: _darkTheme ? Colors.white : Color(0XFF142641),
                ),
                decoration: InputDecoration(
                  labelText: sysLng == "fr" ? 'Téléphone' : 'Phone',
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.phone,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: _darkTheme ? Colors.white : Color(0XFF142641),
                        width: 2.0),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _darkTheme ? Colors.white : Color(0XFF142641)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return sysLng == "fr"
                        ? 'Entrez votre numéro téléphone'
                        : 'Enter your phone number';
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
                  color: _darkTheme ? Colors.white : Color(0XFF142641),
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : Color(0XFF142641),
                  ),
                  prefixIcon: Icon(Icons.mail,
                      color:
                          _darkTheme ? Color(0xFFF2B538) : Color(0XFF142641)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: _darkTheme ? Colors.white : Color(0XFF142641),
                        width: 2.0),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _darkTheme ? Colors.white : Color(0XFF142641)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return sysLng == "fr"
                        ? 'Entrez votre adresse email'
                        : 'Enter your email address';
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
    );
  }
}
