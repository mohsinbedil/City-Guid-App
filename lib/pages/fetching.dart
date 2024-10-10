// 29. import 'package:cloud_firestore/cloud_firestore.dart';
// 30. import 'package:flutter/material.dart';
// 31. import 'package:firebase_auth/firebase_auth.dart';
// 32. 
// 33. class ProfileScreen extends StatefulWidget {34.   @override
// 35.   _ProfileScreenState createState() => _ProfileScreenState();
//  }

// 38. class _ProfileScreenState extends State<ProfileScreen> {39.   User? _user;
// 40.   Map<String, dynamic>? _userData;
// 41. 
// 42.   @override
// 43.   void initState() {
// 44.     super.initState();
// 45.     _getUserData();
// 46.   }
// 47. 
// 48.   Future<void> _getUserData() async {
// 49.     User? user = FirebaseAuth.instance.currentUser;
// 50.     if (user != null) {
// 51.       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
// 52.       setState(() {
// 53.         _user = user;
// 54.         _userData = userDoc.data() as Map<String, dynamic>?;
// 55.       });
// 56.     }
// 57.   }
// 58. 
// 59.   @override
// 60.   Widget build(BuildContext context) {
// 61.     if (_user == null || _userData == null) {
// 62.       return Scaffold(
// 63.         appBar: AppBar(title: Text('Profile')),
// 64.         body: Center(child: CircularProgressIndicator()),
// 65.       );
// 66.     }
// 67. 
// 68.     return Scaffold(
// 69.       appBar: AppBar(title: Text('Profile')),
// 70.       body: Padding(
// 71.         padding: const EdgeInsets.all(16.0),
// 72.         child: Column(
// 73.           crossAxisAlignment: CrossAxisAlignment.start,
// 74.           children: [
// 75.             Text('Name: ${_userData!['name']}', style: TextStyle(fontSize: 18)),
// 76.             Text('Email: ${_user!.email}', style: TextStyle(fontSize: 18)),
// 77.             // Add other profile fields as needed
// 78.           ],
// 79.         ),
// 80.       ),
// 81.     );
// 82.   }
// 83. }
// 84. 
//  Store User Data: When a user signs up or updates their profile, 
//  ensure you store their details in Firestore:dartCopy codeFuture<void> updateUserData(String uid, String name) async
//   {86.   await FirebaseFirestore.instance.collection('users').doc(uid).set({
//     'name': name,
// 88.     // Add other user fields as needed
// 89.   });
// 90. }
// 91. 