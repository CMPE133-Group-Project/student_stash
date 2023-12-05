import 'package:flutter/material.dart';

import 'appbar.dart';

class ItemDetail extends StatelessWidget {
  final String title;
  final String price;
  final String name;
  final String imgURL;
  final String desc;
  const ItemDetail({super.key, required this.title, required this.price, required this.name, required this.imgURL, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),

    );
  }
}