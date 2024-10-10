import 'package:flutter/material.dart';
import 'package:mycityguide/Services/share_preference.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    _nameController.text = await SharedPrefHelper().getUserName() ?? '';
    _emailController.text = await SharedPrefHelper().getUserEmail() ?? '';
    // _locationController.text =
    // await SharedPrefHelper().getUserLocation() ?? 'Karachi';
  }

  void _updateProfile() async {
    await SharedPrefHelper().saveUserName(_nameController.text);
    await SharedPrefHelper().saveUserEmail(_emailController.text);
    // await SharedPrefHelper().saveUserLocation(_locationController.text);

    Navigator.of(context).pop(true); // Pass true to indicate an update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0D6EFD), // Background color
              ),
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
