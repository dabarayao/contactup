// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart'
    show
        AlertDialog,
        AssetImage,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Center,
        ChangeNotifier,
        CircularProgressIndicator,
        Color,
        Colors,
        Column,
        CrossAxisAlignment,
        DecorationImage,
        Drawer,
        DrawerHeader,
        EdgeInsets,
        ElevatedButton,
        FutureBuilder,
        Icon,
        IconButton,
        Icons,
        Image,
        ListTile,
        ListView,
        MainAxisAlignment,
        Navigator,
        RefreshIndicator,
        Scaffold,
        ScaffoldMessenger,
        SnackBar,
        SnackBarAction,
        Text,
        TextButton,
        TextOverflow,
        TextStyle,
        ValueKey,
        Widget,
        showDialog;
import 'dart:convert' show jsonDecode;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage; // Importing cachedNetworkImage module
import 'package:flutter/foundation.dart' show ChangeNotifier, ValueKey, compute;
import 'package:basic_utils/basic_utils.dart'
    show StringUtils; // Importing basic_utils module
import 'package:flutter_slidable/flutter_slidable.dart'
    show ActionPane, DismissiblePane, ScrollMotion, Slidable, SlidableAction;
import 'package:provider/provider.dart'; // Importing provider module
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences; // Importing sharedPreferences module
import 'package:flutter_hooks/flutter_hooks.dart'
    show
        HookWidget,
        useEffect,
        useFuture,
        useMemoized,
        useState; // Importing flutter_hooks module

import "../utils/appBar.dart";

import 'dart:io' show HttpHeaders, Platform;
import 'package:http/http.dart' as http
    show
        MultipartRequest,
        StreamedResponse,
        get,
        Client; // Importing http module
import 'package:connectivity_plus/connectivity_plus.dart';

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

// Provider for the search into the appBar
class GlobalSearch with ChangeNotifier {
  String _globalSearchValue = "";

  String get globalSearchValue => _globalSearchValue;

  void changeGlobalSearchValue(value) {
    _globalSearchValue = value;

    notifyListeners();
  }
}

// Provider for the contacts in order to load or reload them
class LoadContact with ChangeNotifier {
  Future<List<Contact>>? _allContacts;

  Future<List<Contact>>? get allContacts => _allContacts;

  void changeAllContacts(value) {
    _allContacts = value;
    notifyListeners();
  }
}

// Provider for the contacts in order to load or reload them
class SelectedContacts with ChangeNotifier {
  List _selectedContacts = [];

  List get selectedContacts => _selectedContacts;

  void newSelectedContacts(value) {
    _selectedContacts.add(value);

    notifyListeners();
  }

  void removeSelectedContacts(value) {
    _selectedContacts.removeWhere((item) => item == value);

    notifyListeners();
  }

  void emptySelectedContacts() {
    _selectedContacts.clear();

    notifyListeners();
  }
}

// Future to archive or unarchive contacts
Future updateArch(archId, archive, context) async {
  var postUri = Uri.parse(
      "http://10.0.2.2:8000/contact/edit/arch/$archId"); // this variable catches the url of the server where the contact will be saved

  http.MultipartRequest request = http.MultipartRequest("POST",
      postUri); // this http mulipartrequest variable creates a post instance to the server

  // the datas which will be sent to the server
  request.fields["isArch"] = "$archive";

  // this http streamresponse variable make it possible to send all data to the server if everything is ok
  // ignore: unused_local_variable
  final http.StreamedResponse response = await request.send();
}

// Future to make contacts favorite or not
Future<void> updateFav(favId, favorite) async {
  var postUri = Uri.parse(
      "http://10.0.2.2:8000/contact/edit/fav/$favId"); // this variable catches the url of the server where the contact will be saved

  http.MultipartRequest request = http.MultipartRequest("POST",
      postUri); // this http mulipartrequest variable creates a post instance to the server

  // the datas which will be sent to the server
  request.fields["isFav"] = "$favorite";

  // this http streamresponse variable make it possible to send all data to the server if everything is ok
  // ignore: unused_local_variable
  final http.StreamedResponse response = await request.send();
}

// A future to get all the contacts
Future<List<Contact>> fetchContacts(http.Client client, context, lang) async {
  final response =
      await client.get(Uri.parse('http://10.0.2.2:8000/'), headers: {
    HttpHeaders.contentTypeHeader: "application/json",
    "Connection": "Keep-Alive",
    "Keep-Alive": "timeout=2, max=1000"
  }).timeout(
    const Duration(seconds: 3),
  );

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseContacts, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Contact> parseContacts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Contact>((json) => Contact.fromJson(json)).toList();
}

/*The Contact class which formats the Datas */
class Contact {
  final int id;
  final String nom;
  final String prenoms;
  final String email;
  final String phone;
  final String photo;
  final bool isFav;
  final bool isArch;

  const Contact({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.email,
    required this.phone,
    required this.photo,
    required this.isFav,
    required this.isArch,
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
      isArch: json['is_arch'] == 1 ? true : false,
    );
  }
}

class ContactList extends HookWidget {
  var sysLng = Platform.localeName.split('_')[
      0]; // The variable which contains the current language of the application

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(SharedPreferences
        .getInstance); // Hook variable which loads all the sharePreferences written on the disk
    final snapshot = useFuture(future,
        initialData:
            null); // Hook variable which catches the datas of the sharePreferences

    if (context.watch<SelectedContacts>().selectedContacts.isEmpty) {
      context.read<LoadContact>().changeAllContacts(fetchContacts(
          http.Client(),
          context,
          sysLng)); // Loading all the contacts by calling a method of his provider if ther's none selectedContacts
    }

    var loadContact = context.watch<LoadContact>().allContacts;

    // Lifecycle to load the Theme and and the language of the application if they have been saved.
    useEffect(() {
      final prefs = snapshot.data;
      if (prefs == null) {
        return;
      }
      sysLng = (prefs.getString('lang') ?? Platform.localeName.split('_')[0]);
      _darkTheme = (prefs.getBool('darkTheme') ?? false);
      return null;
    }, [loadContact]);

    context.read<GlobalSearch>().changeGlobalSearchValue(
        ""); // Erase the globalSearch previous value from the Search input

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
      appBar: DefaultAppBar(
          globalSearchValue: context.read<GlobalSearch>(),
          title: "Contact Up",
          selCont: context.watch<SelectedContacts>(),
          lang: sysLng,
          theme: _darkTheme),
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
              leading: const Icon(Icons.home_outlined),
              title: Text(sysLng == "fr" ? 'Accueil' : 'Home'),
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
              leading: Icon(Icons.info_outlined,
                  color: _darkTheme ? Colors.blueGrey : null),
              textColor: _darkTheme ? Colors.white : null,
              title: Text(sysLng == "fr" ? 'A propos' : 'About'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, '/aboutContact');
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
      body: Center(
        child: FutureBuilder<List<Contact>>(
          future: loadContact,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("pictures/no_internet.png"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF2B538),
                        onPrimary: Color(0XFF142641)),
                    onPressed: () {
                      // try reloading data with internet connection
                      context.read<LoadContact>().changeAllContacts(
                          fetchContacts(http.Client(), context, sysLng));

                      // Test connectivity async Future
                      checkInternetConnection().then((internet) {
                        if (internet == false) {
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

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          // check if there's network to reload the data
                          http
                              .get(Uri.parse("http://10.0.2.2:8000"))
                              .timeout(const Duration(seconds: 2))
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

                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar); // Finally, callback fires.
                          });
                        }
                      });
                    },
                    child: Text(sysLng == "fr" ? "Actualiser" : "Refresh",
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              return ContactsItems(contacts: snapshot.data!, lang: sysLng);
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFF2B538)),
              );
            }
          },
        ),
      ),
    );
  }
}

// Class to set a pattern for the contacts.
class ContactsItems extends HookWidget {
  const ContactsItems({super.key, required this.contacts, this.lang});

  final List<Contact> contacts;
  final lang;

  @override
  Widget build(BuildContext context) {
    var searchText = context
        .watch<GlobalSearch>()
        .globalSearchValue; // Hooks variable which contains the search text from the serach input

    var selectedContacts = context.watch<SelectedContacts>().selectedContacts;

    // Checking if the favorites list is not empty or not
    if (contacts.isNotEmpty) {
      // Checking if the search text is empty or not
      if (context.watch<GlobalSearch>().globalSearchValue == "") {
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<LoadContact>()
                .changeAllContacts(fetchContacts(http.Client(), context, lang));
          },
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              // ignore: prefer_const_constructors
              // Filtering the serachValue with the favorite's contact list
              return Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: ValueKey(0),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {
                      updateArch(
                          contacts[index].id, contacts[index].isArch, context);
                    }),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: (BuildContext context) {
                          updateArch(contacts[index].id, contacts[index].isArch,
                              context);

                          context.read<LoadContact>().changeAllContacts(
                              fetchContacts(http.Client(), context, lang));
                        },
                        backgroundColor: Color(0xFFF2B538),
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: 'Archive',
                      ),
                    ],
                  ),

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {
                      updateArch(
                          contacts[index].id, contacts[index].isArch, context);
                    }),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: (BuildContext context) {
                          updateArch(contacts[index].id, contacts[index].isArch,
                              context);

                          context.read<LoadContact>().changeAllContacts(
                              fetchContacts(http.Client(), context, lang));
                        },
                        backgroundColor: Color(0xFFF2B538),
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: 'Archive',
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: ListTile(
                    onTap: () {
                      // push to viewContact route with some parameters
                      if (selectedContacts.isNotEmpty) {
                        if (selectedContacts.contains(contacts[index].id)) {
                          context
                              .read<SelectedContacts>()
                              .removeSelectedContacts(contacts[index].id);
                        } else {
                          context
                              .read<SelectedContacts>()
                              .newSelectedContacts(contacts[index].id);
                        }
                      } else {
                        Navigator.pushNamed(context, '/viewContact',
                            arguments: {
                              'id': contacts[index].id,
                              'route': "home"
                            });
                      }

                      // Test connectivity async Future
                      checkInternetConnection().then((internet) {
                        if (internet == false) {
                          context
                              .read<SelectedContacts>()
                              .emptySelectedContacts();
                          var snackBar = SnackBar(
                            content: Text(lang == "fr"
                                ? 'Vérifiez votre connexion internet'
                                : "Check your internet connexion"),
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    onLongPress: () {
                      if (selectedContacts.contains(contacts[index].id)) {
                        context
                            .read<SelectedContacts>()
                            .removeSelectedContacts(contacts[index].id);
                      } else {
                        context
                            .read<SelectedContacts>()
                            .newSelectedContacts(contacts[index].id);
                      }

                      // Test connectivity async Future
                      checkInternetConnection().then((internet) {
                        if (internet == false) {
                          context
                              .read<SelectedContacts>()
                              .emptySelectedContacts();
                          var snackBar = SnackBar(
                            content: Text(lang == "fr"
                                ? 'Vérifiez votre connexion internet'
                                : "Check your internet connexion"),
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    textColor: _darkTheme ? Colors.white : null,
                    selected: selectedContacts.contains(contacts[index].id)
                        ? true
                        : false,
                    selectedColor: _darkTheme ? Colors.white : Colors.black,
                    selectedTileColor: const Color(0xFFF2B538).withOpacity(0.3),
                    leading: CachedNetworkImage(
                      imageUrl: "http://10.0.2.2:8000${contacts[index].photo}",
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 48,
                        color: _darkTheme ? Colors.blueGrey : null,
                      ),
                    ),
                    title: Text(
                      "${StringUtils.capitalize(contacts[index].prenoms)} ${StringUtils.capitalize(contacts[index].nom)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('${contacts[index].phone}'),
                    trailing: IconButton(
                        icon: Icon(
                          contacts[index].isFav
                              ? Icons.star
                              : Icons.star_border,
                          color: contacts[index].isFav
                              ? Color(0xFFF2B538)
                              : _darkTheme
                                  ? Colors.white
                                  : Color(0XFF1F1F30),
                        ),
                        onPressed: () {
                          // If there is network, the contact become favorite or else a snackbar error is shown
                          http
                              .get(Uri.parse('http://10.0.2.2:8000/'))
                              .timeout(const Duration(seconds: 1))
                              .catchError((e) {
                            var snackBar = SnackBar(
                              content: Text(lang == "fr"
                                  ? 'Vérifiez votre connexion internet'
                                  : "Check your internet connexion"),
                              action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }).whenComplete(() {
                            updateFav(
                              contacts[index].id,
                              contacts[index].isFav,
                            );

                            Navigator.of(context).pushNamed('/');
                          });
                        }),
                  ));
              //return Image.network(contacts[index].photo);
            },
          ),
        );
      } else {
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            // ignore: prefer_const_constructors
            return contacts[index]
                        .nom
                        .toLowerCase()
                        .contains(searchText.toLowerCase()) ||
                    contacts[index]
                        .prenoms
                        .toLowerCase()
                        .contains(searchText.toLowerCase()) ||
                    contacts[index]
                        .phone
                        .toLowerCase()
                        .contains(searchText.toLowerCase())
                ? Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: ValueKey(0),

                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(onDismissed: () {
                        updateArch(contacts[index].id, contacts[index].isArch,
                            context);
                      }),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          onPressed: (BuildContext context) => updateArch(
                              contacts[index].id,
                              contacts[index].isArch,
                              context),
                          backgroundColor: Color(0xFFF2B538),
                          foregroundColor: Colors.white,
                          icon: Icons.archive,
                          label: 'Archive',
                        ),
                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        updateArch(contacts[index].id, contacts[index].isArch,
                            context);
                      }),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          onPressed: (BuildContext context) => updateArch(
                              contacts[index].id,
                              contacts[index].isArch,
                              context),
                          backgroundColor: Color(0xFFF2B538),
                          foregroundColor: Colors.white,
                          icon: Icons.archive,
                          label: 'Archive',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: ListTile(
                      onTap: () {
                        // push to viewContact route with some parameters
                        if (selectedContacts.isNotEmpty) {
                          if (selectedContacts.contains(contacts[index].id)) {
                            context
                                .read<SelectedContacts>()
                                .removeSelectedContacts(contacts[index].id);
                          } else {
                            context
                                .read<SelectedContacts>()
                                .newSelectedContacts(contacts[index].id);
                          }
                        } else {
                          Navigator.pushNamed(context, '/viewContact',
                              arguments: {
                                'id': contacts[index].id,
                                'route': "home"
                              });
                        }

                        // Test connectivity async Future
                        checkInternetConnection().then((internet) {
                          if (internet == false) {
                            context
                                .read<SelectedContacts>()
                                .emptySelectedContacts();
                            var snackBar = SnackBar(
                              content: Text(lang == "fr"
                                  ? 'Vérifiez votre connexion internet'
                                  : "Check your internet connexion"),
                              action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      },
                      textColor: _darkTheme ? Colors.white : null,
                      leading: CachedNetworkImage(
                        imageUrl:
                            "http://10.0.2.2:8000${contacts[index].photo}",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 48,
                          color: _darkTheme ? Colors.blueGrey : null,
                        ),
                      ),
                      title: Text(
                        "${StringUtils.capitalize(contacts[index].prenoms)} ${StringUtils.capitalize(contacts[index].nom)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('${contacts[index].phone}'),
                      trailing: IconButton(
                          icon: Icon(
                            contacts[index].isFav
                                ? Icons.star
                                : Icons.star_border,
                            color: contacts[index].isFav
                                ? Color(0xFFF2B538)
                                : _darkTheme
                                    ? Colors.white
                                    : _darkTheme
                                        ? Colors.white
                                        : Color(0XFF1F1F30),
                          ),
                          onPressed: () {
                            // If there is network, the datas are saved or else an alert error is shown
                            http
                                .get(Uri.parse('http://10.0.2.2:8000/'))
                                .timeout(const Duration(seconds: 1))
                                .catchError((e) {
                              var snackBar = SnackBar(
                                content: Text(lang == "fr"
                                    ? 'Vérifiez votre connexion internet'
                                    : "Check your internet connexion"),
                                action: SnackBarAction(
                                  label: 'Ok',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }).whenComplete(() {
                              updateFav(
                                  contacts[index].id, contacts[index].isFav);

                              Navigator.of(context).pushNamed('/');
                            });
                          }),
                    ))
                : Text("");
            //return Image.network(contacts[index].photo);
          },
        );
      }
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              lang == "fr"
                  ? "Votre liste de contact est vide"
                  : "Contact's list is empty",
              style: TextStyle(
                  fontSize: 18, color: _darkTheme ? Colors.white : null)),
          Icon(Icons.list, size: 200, color: Color(0xFFF2B538)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color(0XFF142641), onPrimary: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed('/addContact');
            },
            child: const Text("Ajouter", style: TextStyle(fontSize: 18)),
          ),
        ],
      );
    }
  }
}

/*
Developped by Yao Dabara Mickael
phone: +2250779549937
email: dabarayao@gmail.com
telegram: @yiox2048
 */