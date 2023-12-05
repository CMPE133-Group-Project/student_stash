import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'appbar.dart';
import 'current_session.dart';
import 'login.dart';
import 'db_operations.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isMounted = false;
  TextEditingController bioController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadProfileData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _loadProfileData() async {
    try {
      // This should get the bio from the database
      String bio = await DbOperations.readFromFile(
          'userDetails/${CurrentSession.getCurrentName()}/bio');
      if (_isMounted) {
        bioController.text = bio;
      }

      // Loads up the image from the database
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("userDetails/${CurrentSession.getCurrentName()}/image");
      String imageUrl = await storageRef.getDownloadURL();

      if (_isMounted) {
        setState(() {
          _imageFile = null;
          _imageUrl = imageUrl;
        });
      }
    } catch (e) {
      if (_isMounted) {
        print("Error loading profile data: $e");
      }
    }
  }

  //Frontend of what pops up after clicking change password
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Current Password'),
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'New Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _changePassword();
                Navigator.pop(context);
              },
              child: Text('Change Password'),
            ),
          ],
        );
      },
    );
  }

  //the function that checks you put the correct current password
  void _changePassword() async {
    try {
      String currentPassword = currentPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();

      if (await DbOperations.changePassword(currentPassword, newPassword)) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('Incorrect current password.');
      }
    } catch (e) {
      print('Error changing password: $e');
    }
  }

  //error box that comes up if password could not be changed
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text('Error')),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          content: Text(message),
        );
      },
    );
  }

  //Shows up if password change was succesful.
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Password changed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path!);
      }
    });
  }

  void _saveProfile() async {
    try {
      String bio = bioController.text.trim();
      await DbOperations.updateUserBio(bio);

      if (_imageFile != null) {
        await DbOperations.updateUserImage(XFile(_imageFile!.path));
      }

      _loadProfileData();
      Navigator.pop(context, {'bio': bio, 'imageFile': _imageFile});
    } catch (e) {
      print("Error saving profile: $e");
    }
  }

  //the entire build of the profile page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: _imageFile != null
                        ? Image.file(_imageFile!).image
                        : _imageUrl != null
                            ? NetworkImage(_imageUrl!) as ImageProvider
                            : const AssetImage(
                                'assets/images/defaultAvatar.png'),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    controller: bioController,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Write something about yourself...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    textStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text('Save'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    textStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text('Logout'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _showChangePasswordDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
