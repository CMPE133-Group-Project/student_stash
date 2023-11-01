import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'dart:convert'; // Import this for utf8.encode
import 'dart:typed_data';
import 'current_session.dart';

import 'home.dart';

class DbOperations{

  static Future<void> uploadTextToFirebaseStorage(String text, String destination) async {
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

  static Future<String> readFromFile(String filePath) async{

    final storageRef = FirebaseStorage.instance.ref().child(filePath);

    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await storageRef.getData(oneMegabyte);
      if(data != null){
        String stringData = utf8.decode(data);
        return stringData;
      }
      else
      {
        throw Exception("Reference data is null");
      }
    } on FirebaseException{
      // Handle any errors.
      throw Exception("Error finding file");
    }
  }

  static Future<void> createAccount(String emailText, String passwordText) async{
    // Convert the text to bytes (UTF-8 encoding)
    final Uint8List data = Uint8List.fromList(utf8.encode(emailText));

    // Create a reference to the desired location in Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref().child('userinfo/$emailText.txt');

    final listResult = await storageRef.listAll();
    if(listResult.items.isNotEmpty)
    {
      print("Error: username already exists");
    }
    else
    {     
      try {
        await storageRef.putData(
          data,
          SettableMetadata(contentType: 'text/plain'), // Set the content type
        );

        print('Created Account Successfully.');
      } catch (e) {
        print('Error creating account: $e');
      }
    }
  } 

  static Future<bool> verifyLogin(String emailText, String passwordText) async{
      try
      {
        String pass = await readFromFile('userinfo/$emailText.txt');
        print ("\n\n\n\n\n\n$pass\n\n\n\n\n\n");
        if(pass == passwordText)
        {
          print ("success");
          CurrentSession.setCurrentName(emailText);
          return Future.value(true);  
        }
        else{
          print("wrong password");
          return Future.value(false);  
        }
      } on Exception catch (e)
      {
        print("Exception: $e");
      }
      return Future.value(false);  
  }
}
