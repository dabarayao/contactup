// ignore: file_names
// ignore_for_file: prefer_typing_uninitialized_variables, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart'
    show
        AlertDialog,
        AppBar,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Builder,
        Center,
        Color,
        Colors,
        Container,
        Icon,
        IconButton,
        Icons,
        InputBorder,
        InputDecoration,
        Navigator,
        PreferredSizeWidget,
        ScaffoldMessenger,
        Size,
        SnackBar,
        SnackBarAction,
        Text,
        TextButton,
        TextField,
        TextStyle,
        Visibility,
        Widget,
        showDialog;

import 'package:flutter_hooks/flutter_hooks.dart'
    show
        HookWidget,
        useState,
        useTextEditingController; // Importing the flutter_hooks module
import 'package:http/http.dart' as http
    show
        Client,
        MultipartRequest,
        StreamedResponse; // Importing the http module

// future to delete the selected contacts
Future<void> delMulContact(
    http.Client client, contactIds, route, context, lang) async {
  var allids = "";

  contactIds.forEach((n) {
    allids += "$n;";
  });

  final response = await client
      .get(Uri.parse('http://10.0.2.2:8000/delmulcontact/$allids'), headers: {
    "Connection": "Keep-Alive",
    "Keep-Alive": "timeout=5, max=1000"
  });

  if (response.body == "success") {
    var snackBar = SnackBar(
        content: Text(lang == "fr"
            ? "Contacts supprimé avec succès"
            : "Contacts deleted successfuly"),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
          },
        ));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Navigator.of(context).pushNamedAndRemoveUntil('/$route', (route) => false);
}

// future to delete the selected contacts
Future<void> archMulContact(
    http.Client client, contactIds, route, context, lang, title) async {
  var allids = "";

  contactIds.forEach((n) {
    allids += "$n;";
  });

  final response = await client
      .get(Uri.parse('http://10.0.2.2:8000/archmulcontact/$allids'), headers: {
    "Connection": "Keep-Alive",
    "Keep-Alive": "timeout=5, max=1000"
  });

  if (response.body == "success") {
    var snackBar = SnackBar(
        content: Text(lang == "fr"
            ? title != "Archive"
                ? "Contacts archivé avec succès"
                : "Contacts restauré avec succès"
            : title != "Archive"
                ? "Contacts archived successfuly"
                : "Contacts restored successfuly"),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
          },
        ));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Navigator.of(context).pushNamedAndRemoveUntil('/$route', (route) => false);
}

/*PreferredSizeWidget is an interface implementded to set the size of teh appBar */
class DefaultAppBar extends HookWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);
  DefaultAppBar(
      {super.key,
      this.globalSearchValue,
      this.title,
      this.selCont,
      this.lang,
      this.theme});

  var globalSearchValue;
  var selCont;
  final title;
  var lang;
  var theme;

  @override
  Widget build(BuildContext context) {
    var barSearch = useState(
        false); // Hooks variable to change the appearence of the appBar
    var closeVisible = useState(
        false); // Hooks variable to empty to change visibilty of the search eraser
    var searchValue =
        useTextEditingController(); // Hooks variable to catch the value of the search input

    if (selCont.selectedContacts.isNotEmpty) {
      return AppBar(
        leading: IconButton(
            onPressed: () {
              selCont.emptySelectedContacts();
            },
            icon: Icon(Icons.close)),
        title: Text("${selCont.selectedContacts.length}"),
        backgroundColor: Color(0XFF1F1F30),
        actions: [
          IconButton(
            icon: Icon(title == "Archive"
                ? Icons.unarchive_outlined
                : Icons.archive_outlined),
            onPressed: () {
              // Call the future to delete all the selectedContacts
              archMulContact(http.Client(), selCont.selectedContacts, "",
                      context, lang, title)
                  .timeout(const Duration(seconds: 2))
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

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
              selCont.emptySelectedContacts();
              globalSearchValue.changeGlobalSearchValue("");
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.delete_outline, size: 28),
              color: Colors.white,
              onPressed: () {
                // Respond to icon toggle
                showDialog<String>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: theme ? Color(0XFF1F1F30) : null,
                    title: Text(
                        lang == "fr"
                            ? 'Supprimer les  ${selCont.selectedContacts.length} contacts ?'
                            : 'Delete the ${selCont.selectedContacts.length} contacts? ',
                        style: TextStyle(color: theme ? Colors.white : null)),
                    content: Text(
                        lang == "fr"
                            ? 'Ceci est permanent et ne peut pas être annulé'
                            : "This is permanent and can't be undone",
                        style: TextStyle(color: theme ? Colors.white : null)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: Text(lang == "fr" ? 'Annuler' : 'Cancel',
                            style: TextStyle(color: Color(0xFFff474c))),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call the future to delete all the selectedContacts

                          delMulContact(http.Client(), selCont.selectedContacts,
                                  "", context, lang)
                              .timeout(const Duration(seconds: 2))
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
                            Navigator.pop(context, 'OK');
                          });
                          selCont.emptySelectedContacts();
                          globalSearchValue.changeGlobalSearchValue("dd");
                          globalSearchValue.changeGlobalSearchValue("");
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            );
          })
        ],
      );
    } else {
      if (barSearch.value == false) {
        return AppBar(
          title: Text(title),
          backgroundColor: Color(0XFF1F1F30),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                barSearch.value = true;
                globalSearchValue.changeGlobalSearchValue("");
              },
            ),
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.add, size: 28),
                color: Colors.white,
                onPressed: () {
                  // Respond to icon toggle
                  Navigator.pushNamed(context, '/addContact');
                },
              );
            })
          ],
        );
      } else {
        return AppBar(
            // The search area here
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                /* Clear the search field */
                barSearch.value = false;
                closeVisible.value = false;
                searchValue.text = ("");
                globalSearchValue.changeGlobalSearchValue("");
              },
            ),
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0XFF1F1F30),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  onChanged: (text) {
                    globalSearchValue.changeGlobalSearchValue(text);
                    if (text == "") {
                      closeVisible.value = false;
                      globalSearchValue.changeGlobalSearchValue("");
                    } else {
                      closeVisible.value = true;
                    }
                  },
                  controller: searchValue,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: ' Search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
            ),
            backgroundColor: Color(0XFF1F1F30),
            actions: [
              Visibility(
                visible: closeVisible.value ? true : false,
                child: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    /* Clear the search field */
                    searchValue.text = "";
                    closeVisible.value = false;
                  },
                ),
              )
            ]);
      }
    }
  }
}

/*
Developped by Yao Dabara Mickael
phone: +2250779549937
email: dabarayao@gmail.com
telegram: @yiox2048
 */