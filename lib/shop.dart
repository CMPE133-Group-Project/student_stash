import 'package:flutter/material.dart';

// Widgets
import 'item_format.dart';

class Shop extends StatelessWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 2,
      children: <Widget>[
        item("Paper Clip", 90.36, "Jane S.", 2.3, "assets/images/paperclip.jpg"),
        item("Paper Clip", 90.35, "Jayce L.", 5.0, "assets/images/paperclip.jpg"),
        item("Paper Clip", 0.01, "Charlie R.", 0.2, "assets/images/paperclip.jpg"),
        item("Paper Clip", 16.01, "Benjamin G.", -864.9, "assets/images/paperclip.jpg"),
      ],
    );
  }
}