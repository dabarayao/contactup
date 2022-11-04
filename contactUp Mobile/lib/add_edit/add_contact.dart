import 'package:flutter/material.dart'
    show
        AlertDialog,
        Align,
        Alignment,
        AppBar,
        AutovalidateMode,
        BorderSide,
        BoxDecoration,
        BuildContext,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        ElevatedButton,
        Form,
        FormState,
        GlobalKey,
        Icon,
        IconButton,
        Icons,
        Image,
        InputDecoration,
        MainAxisAlignment,
        MediaQuery,
        Navigator,
        Padding,
        Scaffold,
        ScaffoldMessenger,
        SingleChildScrollView,
        SizedBox,
        SnackBar,
        SnackBarAction,
        Text,
        TextButton,
        TextEditingController,
        TextFormField,
        TextStyle,
        UnderlineInputBorder,
        Widget,
        showDialog;
import 'package:flutter_hooks/flutter_hooks.dart'
    show
        HookWidget,
        useEffect,
        useFuture,
        useMemoized,
        useState; // Importing flutter_hooks module

import 'dart:io' show File, Platform;
import 'dart:async';
import 'dart:convert' show base64Encode;
import 'package:image_picker/image_picker.dart' // Importing imagePicker module
    show
        ImagePicker,
        ImageSource,
        XFile;
import 'package:shared_preferences/shared_preferences.dart' // Importing sharedPreferences module
    show
        SharedPreferences;
import 'dart:core';
import 'package:email_validator/email_validator.dart'; // Importing email_validator module
import 'package:http/http.dart' as http; // Importing http module
import 'package:connectivity_plus/connectivity_plus.dart';

String baseimage = ""; // image chosen converted in binary
// var uploadimage;

bool _darkTheme = false; // The boolean for the dark theme of the application

// Future to check internet connectivity (to check if mobile data or wifi are enable)
Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

// Main class for adding contact
class AddContact extends HookWidget {
  AddContact({super.key});

  // Future to create a new contact
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

    if (upimage.path.isNotEmpty) {
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

  /* Future to update the contact.
   The future takes all the datas in the form and send them to a server in order to be modidiy the contact
*/

  final _formKey =
      GlobalKey<FormState>(); // The form key for the Form's contact

  var sysLng = Platform.localeName.split('_')[
      0]; // The variable which contains the current language of the application

  // Dialog box in order to pick an image

  // TextEditing's variable to catch formfield's datas
  TextEditingController lastNamesController = TextEditingController();
  TextEditingController firstNamesController = TextEditingController();
  TextEditingController phoneNumberTemplateController = TextEditingController();
  TextEditingController emailAddressTemplateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(SharedPreferences
        .getInstance); // Hook variable which loads all the sharePreferences written on the disk
    final snapshot = useFuture(future,
        initialData:
            null); // Hook variable which catches the datas of the sharePreferences
    var addImage =
        useState(XFile("")); // Hook variable to catch the upload image data
    var validMod = useState(AutovalidateMode
        .disabled); // Hook variable to set the state of the Form validation

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

    // Future to take an image from the gallery
    Future<void> chooseImage(context) async {
      var choosedimage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //set source: ImageSource.camera to get image from camera

      addImage.value = choosedimage!;

      Navigator.pop(context, 'OK');
    }

    // Future to create a capture an image with the camera
    Future<void> captureImage(context) async {
      var choosedimage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      //set source: ImageSource.camera to get image from camera

      addImage.value = choosedimage!;

      Navigator.pop(context, 'OK');
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
        autovalidateMode: validMod.value,
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
                          child: addImage.value.path.isNotEmpty
                              ? Image.file(File(addImage.value.path))
                              : const Icon(Icons.person_outline,
                                  size: 160, color: Color(0XFF142641))),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          if (addImage.value.path.isEmpty) {
                            imageBrowse();
                          } else {
                            addImage.value = XFile("");
                          }
                        },
                        icon: Icon(
                            addImage.value.path.isEmpty
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
                  } else {
                    if (!EmailValidator.validate(value)) {
                      return sysLng == "fr"
                          ? """Entrez une addresse email valide;\n l\'adresse email doit contenir un "@" et un "." """
                          : """ Enter a valid email address;\n the email address must have an "@" and a "' """;
                    }
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
                  validMod.value = AutovalidateMode.onUserInteraction;

                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, the create data Future to save the datas.

                    // If there is network, the datas are saved or else an alert error is shown
                    http
                        .get(Uri.parse('http://10.0.2.2:8000/'))
                        .timeout(const Duration(seconds: 1))
                        .catchError((e) {
                      var snackBar = SnackBar(
                        content: Text(sysLng == "fr"
                            ? 'Vérifiez votre connexion internet'
                            : "Check your internet connexion"),
                        action: SnackBarAction(
                          label: 'Ok',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar); //
                    }).whenComplete(() {
                      createContact(
                          lastNamesController.text,
                          firstNamesController.text,
                          emailAddressTemplateController.text,
                          phoneNumberTemplateController.text,
                          addImage.value,
                          context);
                    });

                    // Test connectivity async Future
                    checkInternetConnection().then((internet) {
                      if (internet == null || internet == false) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor:
                                _darkTheme ? Color(0XFF1F1F30) : null,
                            title: Text(
                                sysLng == "fr"
                                    ? 'Erreur de connexion'
                                    : 'Internet error 🌍',
                                style: TextStyle(
                                    color: _darkTheme ? Colors.white : null)),
                            content: Text(
                                sysLng == "fr"
                                    ? 'Vérifiez votre connexion internet'
                                    : "Check your internet connexion",
                                style: TextStyle(
                                    color: _darkTheme ? Colors.white : null)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
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

/*
Developped by Yao Dabara Mickael
phone: +2250779549937
email: dabarayao@gmail.com
telegram: @yiox2048
 */
