import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewHotels extends StatefulWidget {
  static const String id = "View_Hotels";
  const ViewHotels({super.key});

  @override
  State<ViewHotels> createState() => _ViewhotleState();
}

class _ViewhotleState extends State<ViewHotels> {
  Future<void> _deleteItem(String itemId) async {
    await FirebaseFirestore.instance.collection('Hotels').doc(itemId).delete();
  }

  Future<void> _editItem(DocumentSnapshot item) async {
    TextEditingController _nameController = TextEditingController(text: item['HotelName']);
    TextEditingController _locationController = TextEditingController(text: item['HoletLocation']);
    TextEditingController _ratingController = TextEditingController(text: item['HotelRating']);
    
    final imagepicker = ImagePicker();
    List<XFile> images = [];
    List<String> imageUrls = [];

    Future<void> pickimage() async {
      final List<XFile>? pickedImages = await imagepicker.pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          images = pickedImages;
        });
        print("Images selected: ${images.length}");
      } else {
        print("No image selected");
      }
    }

    Future<String> postimage(XFile imageFile) async {
      Reference ref = FirebaseStorage.instance.ref().child("Images").child(imageFile.name);
      if (kIsWeb) {
        await ref.putData(await imageFile.readAsBytes()); // For web
      } else {
        await ref.putFile(io.File(imageFile.path)); // For mobile
      }
      return await ref.getDownloadURL();
    }

    Future<void> uploadImage() async {
      for (var image in images) {
        try {
          String downloadUrl = await postimage(image);
          print("Image uploaded: $downloadUrl");
          imageUrls.add(downloadUrl);
        } catch (e) {
          print("Error uploading image: $e");
          // Handle the error appropriately
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Item Location'),
                    ),
                    TextFormField(
                      controller: _ratingController,
                      decoration: InputDecoration(labelText: 'Item Rating'),
                    ),
                    const SizedBox(height: 20),
                    images.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 10),
                            height: 100,
                            width: 400,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: images.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    kIsWeb
                                         ? Image.network(images[index].path, width: 150, height: 150, fit: BoxFit.cover)
                                : Image.file(io.File(images[index].path), width: 150, height: 150, fit: BoxFit.cover),
                           
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            images.removeAt(index);
                                          });
                                        },
                                        icon: Icon(Icons.cancel, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : const Text("No Image Selected"),
                    ElevatedButton(
                      onPressed: () async {
                        await pickimage();
                      },
                      child: const Text("Pick Image"),
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
                    await FirebaseFirestore.instance.collection('Hotels').doc(item.id).update({
                      'HotelName': _nameController.text,
                      'HoletLocation': _locationController.text,
                      'HotelRating': _ratingController.text,
                      'image_url': imageUrls,
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Hotels").snapshots(),
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
              DataColumn(label: Text("Ratings")),
              DataColumn(label: Text("Actions")),
            ],
            rows: items.map((item) {
              List<dynamic> imageUrls = item["image_url"] ?? [];
              print("image URLs for item ${item.id}: $imageUrls"); // Debugging statement
              return DataRow(cells: [
                DataCell(
                  Row(
                    children: List.generate(imageUrls.length, (index) {
                      print("loading image from URL: ${imageUrls[index]}"); // Debugging
                      return Image.network(
                        imageUrls[index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          print("Error loading image: $error"); // Log the error
                          return Icon(Icons.error);
                        },
                      );
                    }),
                  ),
                ),
                DataCell(Text(item["HotelName"] ?? "")),
                DataCell(Text(item["HoletLocation"] ?? "")),
                DataCell(Text(item["HotelRating"] ?? "")),
                DataCell(
                  Row(children: [
                    IconButton(onPressed: () => _editItem(item), icon: const Icon(Icons.edit), color: Colors.green,),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _deleteItem(item.id);
                      },
                    ),
                  ]),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
