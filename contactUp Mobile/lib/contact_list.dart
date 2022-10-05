import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;

// A future to get all the contacts
Future<List<Contact>> fetchContacts(http.Client client) async {
  final response = await client.get(Uri.parse('http://10.0.2.2:8000/'),
      headers: {
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000"
      });

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseContacts, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Contact> parseContacts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Contact>((json) => Contact.fromJson(json)).toList();
}

class Contact {
  final int id;
  final String nom;
  final String prenoms;
  final String email;
  final String phone;
  final String photo;

  const Contact({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.email,
    required this.phone,
    required this.photo,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prenoms: json['prenoms'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] ?? "aucun",
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    super.initState();
  }

  var internetOk = false;

  @override
  Widget build(BuildContext context) {
    /* http.get(Uri.parse('http://10.0.2.2:8000/')).whenComplete(() {
      internetOk = true;
    }).timeout(const Duration(seconds: 2), onTimeout: () {
      internetOk = false;
      throw ("big error 404");
    }); */

    return Center(
      child: FutureBuilder<List<Contact>>(
        future: fetchContacts(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ContactsItems(contacts: snapshot.data!));
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF2B538)),
            );
          }
        },
      ),
    );
  }
}

// Class to set a pattern for the contacts.
class ContactsItems extends StatelessWidget {
  const ContactsItems({super.key, required this.contacts});

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        // ignore: prefer_const_constructors
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: "http://10.0.2.2:8000${contacts[index].photo}",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              size: 48,
            ),
          ),
          title: Text(
            "${StringUtils.capitalize(contacts[index].prenoms)} ${StringUtils.capitalize(contacts[index].nom)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('📞 ${contacts[index].phone}'),
          trailing: IconButton(
              icon: const Icon(Icons.remove_red_eye),
              onPressed: () {
                // push to a new route with some parameters
                Navigator.pushNamed(context, '/viewContact', arguments: {
                  'id': contacts[index].id,
                  'nom': contacts[index].nom,
                  'prenoms': contacts[index].prenoms,
                  'email': contacts[index].email,
                  'phone': contacts[index].phone,
                  'photo': "http://10.0.2.2:8000${contacts[index].photo}",
                });
              }),
        );
        //return Image.network(contacts[index].photo);
      },
    );
  }
}
