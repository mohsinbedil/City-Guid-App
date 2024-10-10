import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycityguide/Services/data.dart';
import 'package:mycityguide/pages/BottomNav/write_review.dart';
// import 'package:tourister/Pages/detailed/Overview.dart';

class Reviews extends StatefulWidget {
  //  final String name;
  // final String reviews;
  // final String location;
  //   final String imageUrl;

  const Reviews({
    Key? key,
    // required this.name,
    // required this.reviews,
    // required this.location,
    // required this.imageUrl,
  }) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  Stream? ReviewStream;

  getontheload() async {
    ReviewStream = await DatabaseMethods().getReviews();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget Reviews() {
    return StreamBuilder(
        stream: ReviewStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 1),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(color: Color.fromARGB(0, 187, 225, 255), width: 2), // Blue border as shown in the image
                      ),
                      child:
                          ListTile(
                                      leading:  ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: ds["Avactor"] != null && ds["Avactor"].isNotEmpty
                          ? Image.network(
                              ds["Avactor"],
                              width: 50, // Set a width for the image
                              height: 50, // Set a height for the image
                              fit: BoxFit.cover, // Ensure the image fits within the bounds
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person, size: 50); // Fallback to an icon if image fails to load
                              },
                            )
                          : Icon(Icons.person, size: 50), // Fallback to an icon if no image is available
                                          ), // Leading icon
                                      title: Text(ds['Name']),
                                      subtitle: Text(ds['Review']),
                                      trailing: Column(
                                        children: [
                                           Icon(Icons.star, color: Colors.yellow,),
                                          Text(ds['Rating'].toString()),
                                        ],
                                      ), // Optional trailing icon
                                      onTap: () {
                                        print('ListTile tapped');
                                      },
                                    ),
                                   
                        
                    );
                  })
              : Container();
        });
  }

   @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Reviews(), // Assuming Reviews() is a widget that you have defined elsewhere
          Positioned(
            bottom: 16, // Adjusted the padding to be a bit more standard
            right: 16,  // Adjusted the padding to be a bit more standard
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WriteReview(), // Assuming WriteReview() is another widget
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
