// ignore_for_file: avoid_print, unused_catch_clause

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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

  static Future<List> getAll(String directory) async {
    List res = [];
    Reference ref = FirebaseStorage.instance.ref().child(directory);
    ListResult result = await ref.listAll();

    for (var reference in result.items) {
      String fileName = reference.name;
      // You can also get other properties like URL, metadata, etc., if needed
      // String fileUrl = await reference.getDownloadURL();
      // FullMetadata metadata = await reference.getMetadata();

      res.add(fileName);
    }
    return res;
  }

  static Future<bool> createAccount(
      String emailText, String passwordText) async {
    try {
      await readFromFile('userinfo/$emailText');
      print("Username Already Exists");
    } on Exception catch (e) {
      print("User Not Found, Creating new user");
      try {
        await uploadTextToFirebaseStorage(passwordText, 'userinfo/$emailText');
        await uploadTextToFirebaseStorage(
            'Hello!', 'userDetails/$emailText/bio');
        print("uploaded bio");
        CurrentSession.setCurrentName(emailText);
        return true;
      } catch (e) {
        print("Issue uploading file $e");
      }
    }
    return false;
  }

  static Future<void> updateUserBio(String bio) async {
    await uploadTextToFirebaseStorage(
        bio, 'userDetails/${CurrentSession.getCurrentName()}/bio');
  }

  static Future<void> updateUserImage(XFile? image) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("userDetails/${CurrentSession.getCurrentName()}");
    await storageRef.child("image").putFile(File(image!.path));
  }

  static Future<List> getUserDetails(String username) async {
    List res = [];
    final storageRef =
        FirebaseStorage.instance.ref().child("userDetails/$username");
    try {
      res.add(await readFromFile('userDetails/$username/bio'));
      res.add(await storageRef.child("image").getDownloadURL());
    } catch (e) {
      print("No image");
      try {
        res.add(await readFromFile('userDetails/$username/bio'));
      } catch (e) {
        print("No bio or image");
        return [];
      }
    }
    return res;
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
      XFile? image, String name, String desc, String price) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child("listings/$uniqueName");

    try {
      await storageRef.child("image").putFile(File(image!.path));
      await uploadTextToFirebaseStorage(name, "listings/$uniqueName/itemName");
      await uploadTextToFirebaseStorage(desc, "listings/$uniqueName/itemDesc");
      await uploadTextToFirebaseStorage(
          CurrentSession.getCurrentName(), "listings/$uniqueName/sellerName");
      await uploadTextToFirebaseStorage(
          price, "listings/$uniqueName/itemPrice");

      String allListings = await readFromFile('currentListings.txt');
      await uploadTextToFirebaseStorage(
          "$allListings$uniqueName;", "currentListings.txt");

      try {
        String userListings = await readFromFile(
            'userListings/${CurrentSession.getCurrentName()}/uploads.txt');
        print(userListings);
        await uploadTextToFirebaseStorage("$userListings$uniqueName;",
            "userListings/${CurrentSession.getCurrentName()}/uploads.txt");
      } catch (e) {
        await uploadTextToFirebaseStorage("$uniqueName;",
            "userListings/${CurrentSession.getCurrentName()}/uploads.txt");
      }

      print("Success uploading listing");
      return true;
    } catch (e) {
      print(e);
    }
    return false;
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
      try {
        temp.add(curString);
        temp.add(await readFromFile("listings/$curString/itemName"));
        temp.add(await readFromFile("listings/$curString/itemDesc"));
        temp.add(await readFromFile("listings/$curString/itemPrice"));
        temp.add(await storageRef.child("$curString/image").getDownloadURL());
        temp.add(await readFromFile("listings/$curString/sellerName"));

        res.add(temp);
      } catch (e) {
        print("Value no longer exists");
      }
    }

    return res;
  }

  static Future<List<List>> retreiveUserListings(String userID) async {
    List<List> res = [];
    String allListings = "";
    try {
      allListings = await readFromFile('userListings/$userID/uploads.txt');
    } catch (e) {
      return res;
    }

    final storageRef = FirebaseStorage.instance.ref().child("listings");

    String curString = '';
    while (allListings != "") {
      int index = allListings.indexOf(';');
      curString = allListings.substring(0, index);
      allListings = allListings.substring(index + 1);

      var temp = [];
      try {
        temp.add(curString);
        temp.add(await readFromFile("listings/$curString/itemName"));
        temp.add(await readFromFile("listings/$curString/itemDesc"));
        temp.add(await readFromFile("listings/$curString/itemPrice"));
        temp.add(await storageRef.child("$curString/image").getDownloadURL());
        temp.add(await readFromFile("listings/$curString/sellerName"));

        res.add(temp);
      } catch (e) {
        return res;
      }
    }

    return res;
  }

  static Future<List> getChatsOnListing(String listingID) async {
    List res = [];

    return res;
  }

  static Future<void> removeListing(String listingID) async {
    final storageRef =
        FirebaseStorage.instance.ref().child("listings/$listingID");
    await storageRef.listAll().then((value) {
      value.items.forEach((element) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      });
    });
  }

  static Future<List<List>> getMessagesAsSeller() async {
    List<List> res = [];
    String allListings = "";
    try {
      allListings = await readFromFile(
          'userListings/${CurrentSession.getCurrentName()}/uploads.txt');
    } catch (e) {
      return res;
    }

    String curString = '';
    List listingsAsList = [];
    while (allListings != "") {
      int index = allListings.indexOf(';');
      curString = allListings.substring(0, index);
      allListings = allListings.substring(index + 1);
      listingsAsList.add(curString);
    }

    for (int i = 0; i < listingsAsList.length; i++) {
      try {
        List usersInterested = await getAll('chats/${listingsAsList[i]}');
        String listingName =
            await readFromFile('listings/${listingsAsList[i]}/itemName');
        for (int j = 0; j < usersInterested.length; j++) {
          res.add([listingsAsList[i], listingName, usersInterested[j]]);
        }
      } catch (e) {
        print("listing not in listings");
      }
    }
    return res;
  }

  static Future<List<List>> getMessagesAsBuyer() async {
    List<List> res = [];
    String allListings = "";
    try {
      allListings = await readFromFile(
          'buyerMessages/${CurrentSession.getCurrentName()}');
    } catch (e) {
      return res;
    }

    String curString = '';
    List listingsAsList = [];
    while (allListings != "") {
      int index = allListings.indexOf(';');
      curString = allListings.substring(0, index);
      allListings = allListings.substring(index + 1);
      listingsAsList.add(curString);
    }

    for (int i = 0; i < listingsAsList.length; i++) {
      try {
        String sellerID =
            await readFromFile('listings/${listingsAsList[i]}/sellerName');
        String itemName =
            await readFromFile('listings/${listingsAsList[i]}/itemName');
        res.add([
          listingsAsList[i],
          itemName,
          sellerID,
        ]);
      } catch (e) {
        print("listing no longer exists");
      }
    }

    return res;
  }

  static Future<void> sendMessage(
      String listingID, String content, String buyerID) async {
    //Name, Content, Time

    try {
      String currentMessages = await readFromFile('chats/$listingID/$buyerID');
      await uploadTextToFirebaseStorage(
          "$currentMessages${CurrentSession.getCurrentName()};$content;${DateTime.now()};",
          "chats/$listingID/$buyerID");
    } catch (e) {
      await uploadTextToFirebaseStorage(
          "$buyerID;$content;${DateTime.now()};", "chats/$listingID/$buyerID");
      try {
        String buyerChats = await readFromFile('buyerMessages/$buyerID');
        await uploadTextToFirebaseStorage(
            "$listingID;$buyerChats", "buyerMessages/$buyerID");
      } catch (f) {
        await uploadTextToFirebaseStorage(
            "$listingID;", "buyerMessages/$buyerID");
      }
    }
  }

  static Future<List<List>> readMessages(
      String listingID, String userID) async {
    List<List> res = [];
    String messages = await readFromFile("chats/$listingID/$userID");

    while (messages != "") {
      var temp = [];

      int index = messages.indexOf(';');
      String curString = messages.substring(0, index);
      messages = messages.substring(index + 1);
      temp.add(curString);

      index = messages.indexOf(';');
      curString = messages.substring(0, index);
      messages = messages.substring(index + 1);
      temp.add(curString);

      index = messages.indexOf(';');
      curString = messages.substring(0, index);
      messages = messages.substring(index + 1);
      temp.add(curString);

      res.add(temp);
    }

    return res;
  }

  static Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    String temp =
        await readFromFile('userinfo/${CurrentSession.getCurrentName()}');
    if (currentPassword == temp) {
      try {
        await uploadTextToFirebaseStorage(
            newPassword, 'userinfo/${CurrentSession.getCurrentName()}');
        return true;
      } on Exception {
        print("error uploading data");
      }
    } else {
      print("Passwords do not match");
    }
    return false;
  }
}
