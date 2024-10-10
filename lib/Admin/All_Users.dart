
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersDetails extends StatefulWidget {
  static const String id = "User_Details";
  const UsersDetails({super.key});

  @override
  State<UsersDetails> createState() => _UsersDetailsState();
}

class _UsersDetailsState extends State<UsersDetails> {
    Future<void> _deleteItem(String itemId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(itemId)
        .delete();
  }

//   Future<void> _editItem(DocumentSnapshot item) async {
//     TextEditingController _nameController = TextEditingController(text: item['Name']);
//     // TextEditingController _emailController = TextEditingController(text: item['Email']);
//     TextEditingController _contactController = TextEditingController(text: item['Contact']);
//     TextEditingController _adressController = TextEditingController(text: item['Address']);

    
//     io.File? _imageFile = null;
//     final imagepicker = ImagePicker();
//     List<XFile> images = [];
//     List<String> imageUrls = [];
//     // Function to pick an image
//      Future<void> pickimage() async {
//   final List<XFile>? pickimage = await imagepicker.pickMultiImage();
//   if (pickimage != null) {
//     setState(() {
//       images.addAll(pickimage);
//     });
//     print("Images selected: ${images.length}");
//   } else {
//     print("No image Selected");
//   }
// }

//   // Related to storage
//   Future<String> postimage(XFile imageFile) async {
//     Reference ref = FirebaseStorage.instance.ref().child("Image").child(imageFile.name);
//     if (kIsWeb) {
//       await ref.putData(await imageFile.readAsBytes()); // For web
//     } else {
//       await ref.putFile(io.File(imageFile.path)); // For mobile
//     }
//     return await ref.getDownloadURL();
//   }

//   // For iteration of image
//  Future<void> uploadImage() async {
//   for (var i in images) {
//     try {
//       String downloadUrl = await postimage(i);
//       print("Image uploaded: $downloadUrl");
//       imageUrls.add(downloadUrl);
//     } catch (e) {
//       print("Error uploading image: $e");
//       throw e; // Re-throw the error to handle it in addServices()
//     }
//   }
// }

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Edit Item'),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(labelText: 'Item Name'),
//                   ),
//                   TextFormField(
//                     controller: _adressController,
//                     decoration: InputDecoration(labelText: 'Item Contact'),
//                   ),
//                    TextFormField(
//                     controller: _contactController,
//                     decoration: InputDecoration(labelText: 'Item contact'),
//                   ),
//                   SizedBox(height: 20),
//                   if (_imageFile != null)
//                     kIsWeb
//                         ? Image.network(_imageFile.path,
//                             height: 200) // Display local image path on web
//                         : Image.file(_imageFile,
//                             height:
//                                 200) // Display local image file on mobile/desktop
//                   else if (imageUrls != null)
//                     Container(
//                       padding: EdgeInsets.all(10.0),
//                       margin: EdgeInsets.only(bottom: 10.0),
//                       height: 100.0,
//                       width: 400.0,
//                       decoration: BoxDecoration(
//                           color: Colors.grey.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       child: GridView.builder(
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 10),
//                           itemCount: images.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Stack(children: [
//                               Image.network(
//                                 File(images[index].path).path,
//                                 width: 150.0,
//                                 height: 150.0,
//                                 fit: BoxFit.cover,
//                               ),
//                               IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       images.removeAt(index);
//                                     });
//                                   },
//                                   icon: Icon(Icons.cancel_outlined))
//                             ]);
//                           }),
//                     ) // Display uploaded image URL
//                   else
//                     Text('No image selected'),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await pickimage();
//                     },
//                     child: Text('Pick Image'),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await uploadImage();

//                   await FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(item.id)
//                       .update({
//                     'Name': _nameController.text,
//                     'Address': _adressController.text,
//                     'Contact': _contactController.text,
//                     'image_url': imageUrls,
//                   });
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
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
      DataColumn(label: Text("Name")),
      DataColumn(label: Text("Email")),
      // DataColumn(label: Text("Contact")),
      // DataColumn(label: Text("Address")),
      DataColumn(label: Text("Actions")),
    ],
    rows: items.map((item) {
      // Determine if 'Image' is a single URL or a list of URLs
      var imageUrls = item["Image"];
      
      // If imageUrls is not a list, convert it to a list with a single element
      if (imageUrls is String) {
        imageUrls = [imageUrls];
      } else if (imageUrls is! List) {
        // Handle unexpected types
        imageUrls = [];
      }

      print("image URLs for item ${item["id"]}: $imageUrls"); // Debugging statement
      
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
          DataCell(Text(item["Email"] ?? "")),  // Ensure field Email matches Firestore document
          // DataCell(Text(item["Contact"] ?? "")),  // Ensure field Contact matches Firestore document
          // DataCell(Text(item["Address"] ?? "")),  // Ensure field Adress matches Firestore document                
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
                    await _deleteItem(item["id"]);
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
