import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycityguide/Services/data.dart';
import 'package:mycityguide/pages/BottomNav/Home_Appbar.dart';
import 'package:mycityguide/pages/detailed/Details.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Stream? AreaStream;

  Future<void> getontheload() async {
    AreaStream = await DatabaseMethods().getattractions();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: HomeAppbar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore the",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 45,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Row(
                            children: [
                              Text(
                                "Beautiful ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " World",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 136, 0),
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Places",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 260,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: AreaStream as Stream<QuerySnapshot>?,
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}