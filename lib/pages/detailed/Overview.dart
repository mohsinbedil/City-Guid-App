// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tourister/Service/connect.dart';

class Overview extends StatelessWidget {
  final String name;
  final String location;
  final String about;
  // final String ratings;
  final String imageUrl;

  const Overview(
      {Key? key,
      required this.name,
      required this.location,
      required this.imageUrl,
      required this.about,
      // required this.ratings
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 4.5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'About Destination',
              style: GoogleFonts.getFont(
                'Roboto Condensed',
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                fontSize: 18,
                height: 1.4,
                color: const Color(0xFF1B1E28),
              ),
            ),
          ),
        ),
        
        RichText(
          text: TextSpan(
            style: GoogleFonts.getFont(
              'Roboto Condensed',
              fontWeight: FontWeight.w400,
              fontSize: 13,
              height: 1.7,
              color: const Color.fromARGB(255, 0, 110, 255),
            ),
            children: [
              TextSpan(
                text:
                    //  'You will get a complete travel package on the beaches. Packages in the form of airline tickets, recommended Hotel rooms, Transportation, Have you ever been on holiday to the Greek ETC... ',
                    '$about',
                style: GoogleFonts.getFont(
                  'Roboto Condensed',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  height: 1.5,
                  color: const Color(0xFF7D848D),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
            //Details of Atraction
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Rewiews",
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    const Spacer(),
                    Icon(Icons.star,color: Colors.yellow,size: 10,),
                    SizedBox(width:2),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          height: 1.7,
                          color: const Color.fromARGB(255, 0, 110, 255),
                        ),
                        children: [
                          TextSpan(
                            text:
                                // 'You will get a complete travel package on the beaches. Packages in the form of airline tickets, recommended Hotel rooms, Transportation, Have you ever been on holiday to the Greek ETC... ',
                                '5',
                            style: GoogleFonts.getFont(
                              'Roboto Condensed',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 1.5,
                              color: const Color(0xFF7D848D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
            const Divider(),
        const SizedBox(
          height: 10,
        ),
         Row(children: [
          const Text(
        "Location",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
          color: Colors.black,
        ), ),
        Spacer(),
                 RichText(
                      text: TextSpan(
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          height: 1.7,
                          color: const Color.fromARGB(255, 0, 110, 255),
                        ),
                        children: [
                          TextSpan(
                            text:
                                // 'You will get a complete travel package on the beaches. Packages in the form of airline tickets, recommended Hotel rooms, Transportation, Have you ever been on holiday to the Greek ETC... ',
                                '$location',
                            style: GoogleFonts.getFont(
                              'Roboto Condensed',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 1.5,
                              color: const Color(0xFF7D848D),
                            ),
                          ),
                        ],
                      ),
                    ),
                ]),
        const SizedBox(height: 20),
        // Container(
        //   padding: EdgeInsets.all(40),
        //   height: 100,
        //   decoration: BoxDecoration(
        //     color: const Color.fromARGB(255, 223, 223, 223),
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        //   child: GoogleMap(
        //     initialCameraPosition: CameraPosition(
        //       target: LatLng(25.0, 67.0), // Replace with your location
        //       zoom: 14.0,
        //     ),
        //     mapType: MapType.normal,
        //     onMapCreated: (GoogleMapController controller) {
        //       // Optionally, you can use the controller to manipulate the map
        //     },
        //   ),
        // )
      ],
    );
  }
}

