
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycityguide/Services/data.dart';
import 'package:mycityguide/pages/detailed/Details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController reviewcontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  var searchname = "";
  Stream<QuerySnapshot>? attractionStream;

  Fetchdata() async {
    attractionStream = await DatabaseMethods().getattractions();
    setState(() {});
  }

  @override
  void initState() {
    Fetchdata();
    super.initState();
    _initializeStream();
  }
  
  Widget allAttractions() {
    return StreamBuilder(
      stream: attractionStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No attractions found.'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20.0, top: 25.0),
              child: Material(
                elevation: 10.0, // Box Shadow
                borderRadius: BorderRadius.circular(20.0),
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      padding: const EdgeInsets.all(20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 102, 233, 247),
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage(
                            "../img/city${index + 1}.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Name: " + ds['AttractionseName'],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 47, 58),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                             
                            ],
                          ),
                          Text(
                            "About: " + ds["AttractionsAbout"],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 190, 10),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Location: " + ds["AttractionsLocation"],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 250, 145, 182),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _initializeStream() {
    // Initialize with all attractions
    attractionStream = FirebaseFirestore.instance.collection('Attractions').snapshots();
  }
  void _updateStream(String searchTerm) {
    if (searchTerm.isNotEmpty) {
      // Create a stream to query Firestore for exact and partial matches
      attractionStream = FirebaseFirestore.instance
          .collection('Attractions')
          .where('AttractionseName', isGreaterThanOrEqualTo: searchTerm)
          .where('AttractionseName', isLessThanOrEqualTo: searchTerm + '\uf8ff')
          .snapshots();
    } else {
      // Reset to show all attractions if the search term is empty
      _initializeStream();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
             onChanged: (value) {
                setState(() {
                  searchname = value.toUpperCase();
                  _updateStream(searchname);
                });
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 243, 243, 243),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Search Places",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Destinations",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Results",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 117, 233),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(child: Container(
                        height: 260,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: attractionStream as Stream<QuerySnapshot>?,
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.hasError) {
                              return Center(child: Text('Error loading data'));
                            }
                            return ListView.builder(
                              itemCount: snapshot.data?.docs.length ?? 0,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data = snapshot.data!.docs[index];
                                // Handle data with type safety
                                List<dynamic> imageUrlList = data['image_url'] ?? [];
                                String imageUrl = imageUrlList.isNotEmpty && imageUrlList[0] is String ? imageUrlList[0] as String : '';

                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Detail(
                                        name: data['AttractionseName'] ?? 'Unknown',
                                        about: data['AttractionsAbout'] ?? 'No description',
                                        location: data['AttractionsLocation'] ?? 'Unknown location',

                                        imageUrl: imageUrl,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    width: 190,
                                    padding: EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 247, 247, 247),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 170,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 225, 225, 225),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: imageUrl.isNotEmpty
                                              ? Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, progress) {
                                                    if (progress == null) {
                                                      return child;
                                                    } else {
                                                      return Center(child: CircularProgressIndicator());
                                                    }
                                                  },
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Center(child: Text('Error loading image'));
                                                  },
                                                )
                                              : Center(child: CircularProgressIndicator()),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              children: [
                                                Text(
                                                  data['AttractionseName'] ?? 'Unknown',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(255, 29, 29, 29),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: Colors.yellow,
                                                ),
                                                Text('5'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(1),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.pin_drop_outlined,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                data['AttractionsLocation'] ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),),
          ],
        ),
      ),
    );
  }
}
