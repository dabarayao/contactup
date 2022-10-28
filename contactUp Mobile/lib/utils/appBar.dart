// ignore: file_names
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class DefaultAppBar extends HookWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);
  DefaultAppBar({super.key, this.globalSearchValue, this.title});

  var globalSearchValue;
  final title;

  @override
  Widget build(BuildContext context) {
    var barSearch = useState(false);
    var closeVisible = useState(false);
    var searchValue = useTextEditingController();

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
