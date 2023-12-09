import 'package:flutter/material.dart';
import 'package:student_stash/current_session.dart';
import 'package:student_stash/db_operations.dart';
import 'main.dart';

import 'appbar.dart';

class ItemDetail extends StatelessWidget {
  final String title;
  final String price;
  final String name;
  final String imgURL;
  final String desc;
  final String id;
  const ItemDetail(
      {super.key,
      required this.title,
      required this.price,
      required this.name,
      required this.imgURL,
      required this.desc,
      required this.id});

  @override
  Widget build(BuildContext context) {
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
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Text(
              '$title\n\$$price',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ),
          // Product description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Listed by $name',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17.0)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Text(desc),
          ),
          Center(
            child: TextButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.indigo,
                side: const BorderSide(
                  color: Colors.indigo,
                ),
              ),
              onPressed: () async {
                await DbOperations.sendMessage(
                    id,
                    "Hello, I am interested in buying $title.",
                    CurrentSession.getCurrentName());
                fetchListingMessages();
              },
              child: const Text("Interested? Message me!"),
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
