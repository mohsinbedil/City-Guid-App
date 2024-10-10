import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});
  static const String id = "add_services";

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();
  final imagePicker = ImagePicker();
  List<XFile> image = []; // Multiple file list for extensive use
  List<String> imageURL = []; // For Firebase database

  // Function to pick image
  Future<void> pickimage() async {
  final List<XFile>? pickimage = await imagePicker.pickMultiImage();
  if (pickimage != null) {
    setState(() {
      image.addAll(pickimage);
    });
    print("Images selected: ${image.length}");
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
  for (var i in image) {
    try {
      String downloadUrl = await postimage(i);
      print("Image uploaded: $downloadUrl");
      imageURL.add(downloadUrl);
    } catch (e) {
      print("Error uploading image: $e");
      throw e; // Re-throw the error to handle it in addServices()
    }
  }
}


  void Showsuccessdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Added Successfully"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

Future<void> addServices() async {
  if (_formkey.currentState!.validate()) {
    try {
      String AttractionId = randomAlpha(10);
      String AttractionName = namecontroller.text;
      String AttractionLocation = locationcontroller.text;
      String AttractionAbout = aboutcontroller.text;

      await uploadImage();
      await FirebaseFirestore.instance.collection("Attractions").doc(AttractionId).set({
        "AttractionsId": AttractionId,
        "AttractionseName": AttractionName,
        "AttractionsLocation": AttractionLocation,
        "AttractionsAbout": AttractionAbout,
        "image_url": imageURL,
      });

      Showsuccessdialog(context);
      namecontroller.clear();
      locationcontroller.clear();
      aboutcontroller.clear();
      setState(() {
        image.clear();
        imageURL.clear();
      });
    } catch (e) {
      print("Error adding services: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error adding service: $e"),
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Attractions"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                const SizedBox(height: 40),
                const Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Name";
                    }
                    return null;
                  },
                  controller: namecontroller,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.text_fields, color: Colors.blue),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 121, 120, 120))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    hintText: "Enter Name",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Location";
                    }
                    return null;
                  },
                  controller: locationcontroller,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.location_on, color: Colors.blue),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 121, 120, 120))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    hintText: "Enter Location",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter About";
                    }
                    return null;
                  },
                  controller: aboutcontroller,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.info_outline, color: Colors.blue),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 121, 120, 120))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    hintText: "Enter About",
                  ),
                ),
                const SizedBox(height: 20),
                if (image.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    height: 100,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true, // Ensures the GridView doesn't expand infinitely
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: image.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            kIsWeb
                                ? Image.network(image[index].path, width: 150, height: 150, fit: BoxFit.cover)
                                : Image.file(io.File(image[index].path), width: 150, height: 150, fit: BoxFit.cover),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    image.removeAt(index);
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
                else
                  Text("No Image Selected"),
                ElevatedButton(
                  onPressed: () async {
                    await pickimage();
                  },
                  child: Text("Pick Image"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await addServices();
                  },
                  child: Text(
                    "Uplode Attractions",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
