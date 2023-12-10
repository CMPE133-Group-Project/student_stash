// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'db_operations.dart';
import 'main.dart';
import 'item_format.dart';
import 'current_session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Sell(),
    );
  }
}

class Sell extends StatelessWidget {
  const Sell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get list of current listings on the firebase
    List<GestureDetector> listings = [];
    for (List item in items) {
      if (item[5] == CurrentSession.getCurrentName()) {
        listings.add(item_listing(
            item[1], item[3], item[5], item[4], item[2], item[0], context));
      }
    }

    // main build
    return Scaffold(
      body: Stack(
        children: [
            RefreshIndicator(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              children: listings,
            ),
            onRefresh: (){
              return fetchUserOrder();
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _showProductEntryDialog(context);
              },
              child: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductEntryDialog(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    List<XFile> imageFiles = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Product Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText:
                      '\$ ', // Dollar at the start, easier for user and looks cool
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () async {
                  XFile? file = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (file != null) {
                    imageFiles.add(file);
                  }
                },
                child: const Text('Select Picture'),
              ),
              const SizedBox(
                  height: 20), // Adding some space between the buttons
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String title = titleController.text;
                String description = descriptionController.text;
                String price = priceController.text;

                // Upload for every picture, as well as the other stuff
                for (XFile file in imageFiles) {
                  await DbOperations.uploadListing(file, title, description, price);
                  await fetchUserOrder();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
