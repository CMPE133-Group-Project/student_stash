import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'db_operations.dart';

class Sell extends StatelessWidget {
  const Sell({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sell Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);

                  if (file != null) {
                    DbOperations.uploadListing(file, "Testname", "TestDesc");
                  }
                },
                child: Text('Select Picture'),
              ),
              SizedBox(height: 20), // Adding some space between the buttons
              ElevatedButton(
                onPressed: () {},
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
