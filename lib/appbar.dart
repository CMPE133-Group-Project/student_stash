import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'dart:io';

PreferredSizeWidget myAppBar(BuildContext context) {
  return AppBar(
    title: const Text('STUDENT STASH'),
    backgroundColor: Colors.indigo,
    centerTitle: true,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () async {
            // Navigate to ProfilePage and wait result
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );

            if (result != null && result is Map<String, dynamic>) {
              // Handle the result from ProfilePage
              String updatedBio = result['bio'];
              File? updatedImageFile = result['imageFile'];

              // Print statements I put for debugging
              print('Updated Bio: $updatedBio');
              if (updatedImageFile != null) {
                print('Updated Image File: $updatedImageFile');
              }
            }
          },
          child: const Icon(
            Icons.person,
            size: 26.0,
          ),
        ),
      ),
    ],
  );
}
