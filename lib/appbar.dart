import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar() {
  return AppBar(
    title: const Text('STUDENT STASH'),
    backgroundColor: Colors.indigo,
    centerTitle: true,

    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.person,
            size: 26.0,
          ),
        )
      ),
    ],
  );
}