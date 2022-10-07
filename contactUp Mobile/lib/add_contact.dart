import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:http/http.dart' as http;

String baseimage = ""; // image chosen converted in binary
var uploadimage;
bool uploadCancelled = false;
// variable of the image chose in the gallery or camera
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

    // this http streamresponse variable make it possible to send all data to the server if everything is ok
    // ignore: unused_local_variable
    final http.StreamedResponse response = await request.send();

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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

  @override
  initState() {
    super.initState();
    // we restore all this widget when the page is loaded
    setState(() {
      uploadimage = null;
      contactServer = false;
      uploadCancelled = false;
      contactValid = AutovalidateMode.disabled;
    });
  }

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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var routesArg = ModalRoute.of(context)!.settings.arguments
        as Map?; // variable to catch the route's arguments

    // Editin's variable to catch formfield's datas
    TextEditingController lastNamesController = routesArg == null
        ? TextEditingController()
        : TextEditingController(text: routesArg['nom']);
    TextEditingController firstNamesController = routesArg == null
        ? TextEditingController()
        : TextEditingController(text: routesArg['prenoms']);

    TextEditingController phoneNumberTemplateController = routesArg == null
        ? TextEditingController()
        : TextEditingController(text: routesArg['phone']);
    TextEditingController emailAddressTemplateController = routesArg == null
        ? TextEditingController()
        : TextEditingController(text: routesArg['email']);

    /* if routesArg is null and uploadimage.runtimeType is Xfile we give the link of existing photo on the server.
    This means the photo haven't been uploaded.
    */
    if (routesArg != null &&
        uploadimage.runtimeType != XFile &&
        uploadCancelled != true) {
      uploadimage = routesArg["photo"];
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: routesArg ==
                null // if routesArg is null we display a title for addinf contacts else we display a title for modidfing contacts
            ? Text("Ajouter un contact")
            : Text("Modifier un contact"),
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
                      ? Column(
                          children: [
                            SizedBox(
                                height: 120,
                                child: uploadimage
                                        is XFile // when the variable is string it isn't an upload file
                                    ? Image.file(
                                        File(uploadimage!.path),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: uploadimage,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.person,
                                                size: 120, color: Colors.grey),
                                      ) //load image from file
                                ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      imageBrowse();
                                    },
                                    icon: const Icon(Icons.camera_enhance,
                                        color: Color(0XFF40BCD0))),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        uploadCancelled = true;
                                        uploadimage = null;
                                      });
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFFff474c)))
                              ],
                            )
                          ],
                        )
                      : const Text("")),
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
              uploadimage == null
                  ? TextButton.icon(
                      // this widget suggest to pick image when there isn't
                      onPressed: () {
                        // Respond to button press
                        imageBrowse();
                      },
                      icon: const Icon(Icons.select_all, size: 18),
                      label: const Text("choisir une image"),
                    )
                  : Text(""),
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
                        // if routes args is null, it is we use the future createContact else we use the future updateContact
                        if (routesArg == null) {
                          createContact(
                              lastNamesController.text,
                              firstNamesController.text,
                              emailAddressTemplateController.text,
                              phoneNumberTemplateController.text,
                              uploadimage,
                              context);
                        } else {
                          if (uploadimage is String) {
                            updateContact(
                                lastNamesController.text,
                                firstNamesController.text,
                                emailAddressTemplateController.text,
                                phoneNumberTemplateController.text,
                                null,
                                routesArg["id"],
                                context);
                          } else {
                            updateContact(
                                lastNamesController.text,
                                firstNamesController.text,
                                emailAddressTemplateController.text,
                                phoneNumberTemplateController.text,
                                uploadimage,
                                routesArg["id"],
                                context);
                          }
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
      ),
    );
  }
}
