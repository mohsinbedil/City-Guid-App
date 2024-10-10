import 'dart:io'as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycityguide/Services/share_preference.dart';
import 'package:mycityguide/pages/BottomNav/editProfile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  String? name = "", image = "", email = "";
  DocumentSnapshot? userDoc;

  Future<void> getSharedData() async {
    name = await SharedPrefHelper().getUserName();
    email = await SharedPrefHelper().getUserEmail();
    image = await SharedPrefHelper().getUserImage();

    // Fetch the user document
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userId = 'user-id'; // Replace with the actual user ID or fetch from Shared Preferences
    userDoc = await firestore.collection('users').doc(userId).get();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSharedData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[200],
                    child: image != null && image!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              image!,
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 70,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 70,
                          ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(name ?? ""),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Display Name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfile()));
                        },
                        child: Icon(Icons.edit_sharp),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name ?? ""),
                        Icon(
                          Icons.done,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(email ?? ""),
                        Icon(
                          Icons.done,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

