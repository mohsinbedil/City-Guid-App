import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycityguide/Services/share_preference.dart';
import 'package:mycityguide/pages/BottomNav/Home.dart';
import 'package:mycityguide/pages/sigin_page.dart';

class HomeAppbar extends StatefulWidget {
  const HomeAppbar({super.key});

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  String? name = "", image = "", email = "";

  getSharedData() async {
    name = await SharedPrefHelper().getUserName() ?? "";
    email = await SharedPrefHelper().getUserEmail() ?? "";
    image = await SharedPrefHelper().getUserImage() ?? "";
    setState(() {});
  }

  getonload() async {
    await getSharedData();
    setState(() {});
  }

  @override
  void initState() {
    getonload();
    super.initState();
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () async {
                await SharedPrefHelper().clearUserData();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: image != null && image!.isNotEmpty
                      ? Image.network(
                          image!,
                          width: 50, // Set a width for the image
                          height: 50, // Set a height for the image
                          fit: BoxFit.cover, // Ensure the image fits within the bounds
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 50); // Fallback to an icon if image fails to load
                          },
                        )
                      : Icon(Icons.person, size: 50), // Fallback to an icon if no image is available
                ),
                const SizedBox(width: 10), // Add some spacing between the image and text
                Text(name ?? "",
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold) ,)
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _logout();
            },
            icon: const Icon(
              Icons.exit_to_app,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
