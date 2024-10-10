import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllReviews extends StatefulWidget {
  static const String id = "All_reviews";
  const AllReviews({super.key});

  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
    Future<void> _deleteItem(String itemId) async {
    await FirebaseFirestore.instance
        .collection('reviews')
        .doc(itemId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("reviews").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!.docs;
        return SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: DataTable(
    columns: [
      DataColumn(label: Text("Image")),
      DataColumn(label: Text("Area Name")),
      //  DataColumn(label: Text("Ratings")),
      DataColumn(label: Text("Review")),
      DataColumn(label: Text("Actions")),
    ],
    rows: items.map((item) {
      // Determine if 'Image' is a single URL or a list of URLs
      var imageUrls = item["Avactor"];
      
      // If imageUrls is not a list, convert it to a list with a single element
      if (imageUrls is String) {
        imageUrls = [imageUrls];
      } else if (imageUrls is! List) {
        // Handle unexpected types
        imageUrls = [];
      }

      print("image URLs for item ${item["Avactor"]}: $imageUrls"); // Debugging statement
      
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: List.generate(imageUrls.length, (index) {
                print("loading image from URL: ${imageUrls[index]}"); // Debugging purpose
                return Image.network(
                  imageUrls[index],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    print("Error loading image: $error"); // Log the error
                    return Icon(Icons.error);
                  },
                );
              }),
            ),
          ),
          DataCell(Text(item["Name"] ?? "")),  // Ensure field name matches Firestore document
          DataCell(Text(item["Review"] ?? "")),  // Ensure field Email matches Firestore document
          //  DataCell(Text(item["Rating"] ?? "")),  // Ensure field Email matches Firestore document

          DataCell(
            Row(
              children: [
                // Uncomment if you want edit functionality
                // IconButton(onPressed: () => _editItem(item), icon: Icon(Icons.edit), color: Colors.green,),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await _deleteItem(item["Id"]);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList(),
  ),
);

      },
    );
  }
}
