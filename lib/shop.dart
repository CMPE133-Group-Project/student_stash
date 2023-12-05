import 'package:flutter/material.dart';

// Widgets
import 'item_format.dart';
import 'main.dart';
import 'current_session.dart';

class Shop extends StatelessWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<GestureDetector> listings = [];
    for (List item in items) {
      if (item[5] != CurrentSession.getCurrentName()) {
        listings.add(item_listing(item[1], item[3], item[5], item[4], item[2], context));
      }
    }

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 2,
      children: listings,
    );
  }
}