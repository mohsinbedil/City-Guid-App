import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewCategariesitems extends StatefulWidget {
  static const String id = "View_Attractions";
  const ViewCategariesitems({super.key});

  @override
  State<ViewCategariesitems> createState() => _ViewCategariesitemsState();
}

class _ViewCategariesitemsState extends State<ViewCategariesitems> {
    Future<void> _deleteItem(String itemId) async {
    await FirebaseFirestore.instance
        .collection('Attractions')
        .doc(itemId)
        .delete();
  }

  Future<void> _editItem(DocumentSnapshot item) async {
    TextEditingController _nameController = TextEditingController(text: item['AttractionseName']);
    TextEditingController _locationController = TextEditingController(text: item['AttractionsLocation']);
    TextEditingController _aboutController = TextEditingController(text: item['AttractionsAbout']);
    
    io.File? _imageFile = null;
    final imagepicker = ImagePicker();
    List<XFile> images = [];
    List<String> imageUrls = [];
    // Function to pick an image
     Future<void> pickimage() async {
  final List<XFile>? pickimage = await imagepicker.pickMultiImage();
  if (pickimage != null) {
    setState(() {
      images.addAll(pickimage);
    });
    print("Images selected: ${images.length}");
  } else {
    print("No image Selected");
  }
}

  // Related to storage
  Future<String> postimage(XFile imageFile) async {
    Reference ref = FirebaseStorage.instance.ref().child("Images").child(imageFile.name);
    if (kIsWeb) {
      await ref.putData(await imageFile.readAsBytes()); // For web
    } else {
      await ref.putFile(io.File(imageFile.path)); // For mobile
    }
    return await ref.getDownloadURL();
  }

  // For iteration of image
 Future<void> uploadImage() async {
  for (var i in images) {
    try {
      String downloadUrl = await postimage(i);
      print("Image uploaded: $downloadUrl");
      imageUrls.add(downloadUrl);
    } catch (e) {
      print("Error uploading image: $e");
      throw e; // Re-throw the error to handle it in addServices()
    }
  }
}

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                  TextFormField(
                    controller: _aboutController,
                    decoration: InputDecoration(labelText: 'Item About'),
                  ),
                   TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Item Location'),
                  ),
                  SizedBox(height: 20),
                  if (_imageFile != null)
                    kIsWeb
                        ? Image.network(_imageFile.path,
                            height: 200) // Display local image path on web
                        : Image.file(_imageFile,
                            height:
                                200) // Display local image file on mobile/desktop
                  else Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: 100.0,
                    width: 400.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10),
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(children: [
                            Image.network(
                              File(images[index].path).path,
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    images.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.cancel_outlined))
                          ]);
                        }),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await pickimage();
                    },
                    child: Text('Pick Image'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await uploadImage();

                  await FirebaseFirestore.instance
                      .collection('Attractions')
                      .doc(item.id)
                      .update({
                    'AttractionseName': _nameController.text,
                    'AttractionsLocation': _locationController.text,
                    'AttractionsAbout': _aboutController.text,
                    'image_url': imageUrls,
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Attractions").snapshots(),
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
              DataColumn(label: Text("Location")),
              DataColumn(label: Text("About")),
              DataColumn(label: Text("Actions")),

            ],
            rows: items.map((item) {
              List<dynamic> imageUrls = item["image_url"] ?? [];
              print("image URLs for item ${item.id}: $imageUrls"); // Debugging statement
              return DataRow(cells: [
                DataCell(
                  Row(
                    children: List.generate(imageUrls.length, (index) {
                      print("loading image from URL: ${imageUrls[index]}"); // debugging purpose
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
                DataCell(Text(item["AttractionseName"] ?? "")),  // Ensure field name matches Firestore document
                DataCell(Text(item["AttractionsLocation"] ?? "")),  // Ensure field name matches Firestore document
                DataCell(Text(item["AttractionsAbout"] ?? "")),  // Ensure field name matches Firestore document
                DataCell(
                  Row(children: [
                    IconButton(onPressed: () => _editItem(item), icon: Icon(Icons.edit), color: Colors.green,),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await _deleteItem(item.id);
                        },
                      ),
                  ],)
                )
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
