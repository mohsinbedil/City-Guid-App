import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'finalEditprofile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar with First Letter of Name
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      'L', // First letter of the name
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Name and Email
                  const Text(
                    'Leonardo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'leonardo@gmail.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Reward Points, Travel Trips, Bucket List Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Reward Points', '360'),
                      _buildStatColumn('Travel Trips', '238'),
                      _buildStatColumn('Bucket List', '473'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Menu Items List
            _buildMenuItem(
              Icons.person_outline,
              'Profile',
              () {
                // Navigate to the detailed profile screen on tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailsScreen()),
                );
              },
            ),
            _buildMenuItem(Icons.bookmark_border, 'Bookmarked', () {}),
            _buildMenuItem(
              Icons.history,
              'Previous Trips',
              () {
                // Navigate to the Previous Trips screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreviousTripsScreen()),
                );
              },
            ),
            _buildMenuItem(Icons.settings, 'Settings', () {}),
            _buildMenuItem(Icons.info_outline, 'Version', () {}),
          ],
        ),
      ),
    );
  }

  // Helper method to build stat columns (Reward Points, Travel Trips, Bucket List)
  Widget _buildStatColumn(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () => onTap(), // Call the provided function when tapped
    );
  }
}






class ProfileDetailsScreen extends StatefulWidget {
  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
    Map<String, dynamic>? userData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("Email", isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          userData = userDoc.data() as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (userData != null) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditProfileScreen(userData: userData!),
                //   ),
                // ).then((_) => fetchUserData()); // Refresh data after edit
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData != null
              ?  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with First Letter of Name
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  'L', // First letter of the name
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                 "Name: ${userData!['Name'] ?? 'N/A'}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                 "Email: ${userData!['Email'] ?? 'N/A'}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 40),
            // Display other profile fields here
            _buildProfileField('Name',  " ${userData!['Name'] ?? 'N/A'}",),
            _buildProfileField('Email',  " ${userData!['Email'] ?? 'N/A'}",),
            _buildProfileField('Age',  " ${userData!['Age'] ?? 'N/A'}",),
            _buildProfileField('Address',  " ${userData!['Adress'] ?? 'N/A'}",),
            _buildProfileField('Gender',  " ${userData!['Gender'] ?? 'N/A'}",),
            // _buildProfileField('Bucket List', '473'),
          ],
        ),
      )
       : const Center(child: Text("No user data found")),
    );
  }

  // Helper method to build profile fields
  Widget _buildProfileField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// New PreviousTripsScreen
class PreviousTripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for previous trips (You can replace it with real data)
    List<Map<String, String>> previousTrips = [
      {'destination': 'Paris', 'date': '2023-06-15', 'duration': '5 Days'},
      {'destination': 'New York', 'date': '2023-05-10', 'duration': '7 Days'},
      {'destination': 'Tokyo', 'date': '2023-04-25', 'duration': '10 Days'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Trips'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: previousTrips.length,
        itemBuilder: (context, index) {
          var trip = previousTrips[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(trip['destination']!),
              subtitle: Text('${trip['date']} • ${trip['duration']}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Logic for opening details of a specific trip can be added here
                // Currently, tapping on the trip just prints its details
                print('Tapped on ${trip['destination']}');
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}