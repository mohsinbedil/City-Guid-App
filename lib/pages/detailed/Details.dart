import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycityguide/pages/detailed/Attractions_page.dart';
import 'package:mycityguide/pages/detailed/Hotel_page.dart';
import 'package:mycityguide/pages/detailed/Overview.dart';
import 'package:mycityguide/pages/detailed/Review_Page.dart';

class Detail extends StatefulWidget {
  final String name;
  final String about;
  final String location;
  final String imageUrl;

  const Detail({
    Key? key,
    required this.name,
    required this.about,
    required this.location,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFavorited = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    _checkIfFavorited();
  }

  _handleTabSelection() {
    setState(() {});
  }

  Future<void> _checkIfFavorited() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user.uid)
        .collection('items')
        .doc(widget.name)
        .get();
    
    setState(() {
      isFavorited = doc.exists;
    });
  }

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (isFavorited) {
      await removeFromFavorites(user.uid);
    } else {
      await addToFavorites(user.uid);
    }

    setState(() {
      isFavorited = !isFavorited;
    });
  }

  Future<void> addToFavorites(String userId) async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('items')
        .doc(widget.name)
        .set({
      'name': widget.name,
      'about': widget.about,
      'location': widget.location,
      'imageUrl': widget.imageUrl,
    });
  }

  Future<void> removeFromFavorites(String userId) async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('items')
        .doc(widget.name)
        .delete();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: toggleFavorite,
                    child: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(widget.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blue,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    tabs: const [
                      Tab(text: "Overview"),
                      Tab(text: "Hotel"),
                      Tab(text: "Review"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  [
                    Overview(
                      name: widget.name,
                      about: widget.about,
                      location: widget.location,
                      imageUrl: widget.imageUrl,
                    ),
                    Hotel(),
                    Reviews(),
                  ][_tabController.index],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
