

// import 'package:flutter/material.dart';

// class Attractions extends StatefulWidget {
//   const Attractions({super.key});
  
//   @override
//   State<Attractions> createState() => _AttractionsState();
// }

// class _AttractionsState extends State<Attractions> {
//   // List of attractions, locations, and their corresponding images.  
//   final List<Map<String, String>> attractions = [  
//     {  
//       'image': '../assets/image1.png', // Replace with your actual image paths  
//       'name': 'Attraction 1',  
//       'location': 'Location 1',  
//     },  
//     {  
//       'image': '../assets/image2.png',  
//       'name': 'Attraction 2',  
//       'location': 'Location 2',  
//     },  
//     {  
//       'image': '../assets/image3.png',  
//       'name': 'Attraction 3',  
//       'location': 'Location 3',  
//     },  
//     {  
//       'image': '../assets/image4.png',  
//       'name': 'Attraction 4',  
//       'location': 'Location 4',  
//     },  
//     {  
//       'image': '../assets/image5.png',  
//       'name': 'Attraction 5',  
//       'location': 'Location 5',  
//     },  
//     {  
//       'image': '../assets/image6.png',  
//       'name': 'Attraction 6',  
//       'location': 'Location 6',  
//     },  
//   ];  

//   @override  
//   Widget build(BuildContext context) {  
//     return Scaffold(  
//         appBar: AppBar(  
//           title: Text('Attraction Places'),  
//         ),  
//         body: Padding(  
//           padding: const EdgeInsets.all(16.0),  
//           child: GridView.count(  
//             crossAxisCount: 2,  
//             childAspectRatio: 2 / 3, // Adjust the aspect ratio here  
//             children: List.generate(attractions.length, (index) {  
//               return Card(  
//                 elevation: 4,  
//                 child: Column(  
//                   children: [  
//                     Expanded(  
//                       child: Container(  
//                         decoration: BoxDecoration(  
//                           image: DecorationImage(  
//                             image: AssetImage(attractions[index]['image']!), // Using '!' to assert that the value is non-null  
//                             fit: BoxFit.cover,  
//                           ),  
//                         ),  
//                       ),  
//                     ),  
//                     Padding(  
//                       padding: const EdgeInsets.all(8.0),  
//                       child: Text(  
//                         attractions[index]['name']!, // Get attraction name  
//                         style: TextStyle(fontWeight: FontWeight.bold),  
//                       ),  
//                     ),  
//                     Row(  
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,  
//                       children: [  
//                         Icon(Icons.location_on), // Icon for location  
//                         Text(attractions[index]['location']!), // Get location  
//                       ],  
//                     ),  
//                   ],  
//                 ),  
//               );  
//             }),  
//           ),  
//         )
//         );  
//   }  
// }