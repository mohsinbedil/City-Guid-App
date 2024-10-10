import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  static const String id = "dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalPlaces= 0;
  int totalClients = 0;
  int totalHotels = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch total number of orders
      QuerySnapshot PlacesSnapshot =
          await FirebaseFirestore.instance.collection('Attractions').get();
      if (mounted) {
        setState(() {
          totalPlaces = PlacesSnapshot.size;
        });
      }

      // Fetch total number of clients
      QuerySnapshot clientsSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      if (mounted) {
        setState(() {
          totalClients = clientsSnapshot.size;
        });
      }

      //fetching No of Hotels
       QuerySnapshot HotelsSnapshot =
          await FirebaseFirestore.instance.collection('Hotels').get();
      if (mounted) {
        setState(() {
          totalHotels = HotelsSnapshot.size;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardHeight = MediaQuery.of(context).size.height * 0.3;
    final double cardWidth = MediaQuery.of(context).size.width * 0.3;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: cardWidth,
                          height: cardHeight,
                          child: Card(
                            color: const Color.fromARGB(255, 89, 170, 236),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.people, color: Colors.white),
                                    Text(
                                      "Total Users",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "$totalClients",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: cardWidth,
                          height: cardHeight,
                          child: Card(
                            color: const Color.fromARGB(255, 89, 170, 236),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.local_attraction, color: Colors.white),
                                    Text(
                                      "Total Places",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "$totalPlaces",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: cardWidth,
                          height: cardHeight,
                          child: Card(
                            color: const Color.fromARGB(255, 89, 170, 236),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.hotel_sharp, color: Colors.white),
                                    Text(
                                      "Total Hotels",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "$totalHotels",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                       
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16), // Add spacing between rows
              // Add more rows of cards if needed
            ],
          ),
        ),
      ),
    );
  }
}
