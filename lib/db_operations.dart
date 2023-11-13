import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert'; // Import this for utf8.encode
import 'dart:typed_data';
import 'current_session.dart';
import 'package:image_picker/image_picker.dart';

class DbOperations {
  static Future<void> uploadTextToFirebaseStorage(
      String text, String destination) async {
    // Convert the text to bytes (UTF-8 encoding)
    final Uint8List data = Uint8List.fromList(utf8.encode(text));

    // Create a reference to the desired location in Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref().child(destination);

    try {
      await storageRef.putData(
        data,
        SettableMetadata(contentType: 'text/plain'), // Set the content type
      );

      print('Text uploaded successfully.');
    } catch (e) {
      print('Error uploading text: $e');
    }
  }

  static Future<String> readFromFile(String filePath) async {
    final storageRef = FirebaseStorage.instance.ref().child(filePath);

    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await storageRef.getData(oneMegabyte);
      if (data != null) {
        String stringData = utf8.decode(data);
        return stringData;
      } else {
        throw Exception("Reference data is null");
      }
    } on FirebaseException {
      // Handle any errors.
      throw Exception("Error finding file");
    }
  }

  static Future<bool> createAccount(
      String emailText, String passwordText) async {
    try {
      await readFromFile('userinfo/$emailText');
    } on Exception catch (e) {
      print(e);
      uploadTextToFirebaseStorage(passwordText, 'userinfo/$emailText');
      return Future.value(true);
    }
    return Future.value(false);
  }

  static Future<bool> verifyLogin(String emailText, String passwordText) async {
    try {
      String pass = await readFromFile('userinfo/$emailText');
      print("\n\n\n\n\n\n$pass\n\n\n\n\n\n");
      if (pass == passwordText) {
        print("success");
        CurrentSession.setCurrentName(emailText);
        return Future.value(true);
      } else {
        print("wrong password");
        return Future.value(false);
      }
    } on Exception catch (e) {
      print("Exception: $e");
    }
    return Future.value(false);
  }

  static Future<bool> uploadListing(
      XFile? image, String name, String desc) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageRef =
        FirebaseStorage.instance.ref().child("listings/$uniqueName");

    try {
      await storageRef.child("image").putFile(File(image!.path));
      await uploadTextToFirebaseStorage(name, "listings/$uniqueName/itemName");
      await uploadTextToFirebaseStorage(desc, "listings/$uniqueName/itemDesc");

      String allListings = await readFromFile('currentListings.txt');
      await uploadTextToFirebaseStorage(
          "$allListings$uniqueName;", "currentListings.txt");

      print("Success uploading listing");
      return true;
    } catch (e) {
      print(e);
    }
    return Future.value(false);
  }

  static Future<List<List>> retreiveListings() async {
    List<List> res = [];
    String allListings = await readFromFile('currentListings.txt');
    final storageRef = FirebaseStorage.instance.ref().child("listings");

    String curString = '';
    while (allListings != "") {
      int index = allListings.indexOf(';');
      curString = allListings.substring(0, index);
      allListings = allListings.substring(index + 1);

      var temp = [];
      temp.add(await readFromFile("listings/$curString/itemName"));
      temp.add(await readFromFile("listings/$curString/itemDesc"));
      temp.add(await storageRef.child("$curString/image").getDownloadURL());

      res.add(temp);
    }

    print(curString);
    print(allListings);

    return res;
  }
}
