import 'package:flutter/material.dart';

import 'appbar.dart';
import 'current_session.dart';



class ItemEdit extends StatelessWidget {
  final String title;
  final String price;
  final String name;
  final String imgURL;
  final String desc;
  const ItemEdit({super.key, required this.title, required this.price, required this.name, required this.imgURL, required this.desc});

  @override
  Widget build(BuildContext context) { // detailed page listing if the item belongs to current user
    return Scaffold(
      appBar: myAppBar(context),
      body: ListView(
        children: [
          // Product image
          Image.network(
            imgURL,
            //height: MediaQuery.of(context).size.height / 1.8,
            fit: BoxFit.fill,
          ),
          // Product title and price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Text(
              '$title\n\$$price',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ),
          // Product description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
                'Listed by $name',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Text(
                desc),
          ),
          Center(
            child: TextButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.red,
                side: const BorderSide(
                  color: Colors.red,
                ),
              ),
              onPressed: () {},
              child: const Text("Delete Listing"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
        ],
      ),
    );
  }
}