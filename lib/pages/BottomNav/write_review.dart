import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycityguide/Services/data.dart';
import 'package:random_string/random_string.dart';

class WriteReview extends StatefulWidget {
  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  TextEditingController titleController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  int rating = 0;

  void _handleStarTap(int index) {
    setState(() {
      rating = index;
    });
  }

  String _getRatingMessage() {
    switch (rating) {
      case 1:
        return "Bad";
      case 2:
        return "Not Bad";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      default:
        return "Extremly satistfied";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Write a Review",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 62, 168, 255)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String id = randomAlphaNumeric(10);
              Map<String, dynamic> reviewInfoMap = {
                "Id": id,
                "Name": titleController.text,
                "Review": reviewController.text,
                "Avactor":
                    "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671122.jpg?w=740&t=st=1723380844~exp=1723381444~hmac=03a8a3543286098577386651c0e7d076080c7f56098827767aa66f403078bf5d",
                "Rating": rating,
              };
              await DatabaseMethods()
                  .addReview(reviewInfoMap, id)
                  .then((value) {
                Fluttertoast.showToast(
                  msg: "Thanks for Your Feedback",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromARGB(255, 6, 247, 255),
                  textColor: Color.fromARGB(255, 133, 245, 196),
                  fontSize: 16.0,
                );
              });
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0x1F000000)),
                color: Color(0xFF0D6EFD),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 7, 15.9, 7),
                child: Text(
                  'Post',
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0.2,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating Section
              Text(
                'Score:',
                style: GoogleFonts.getFont(
                  'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0x99000000),
                ),
              ),
              SizedBox(
                height: 30,
                child: Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () => _handleStarTap(index + 1),
                    );
                  }),
                ),
              ),
              Text(
                _getRatingMessage(),
                style: GoogleFonts.getFont(
                  'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0x99000000),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.getFont(
                  'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0x99000000),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: reviewController,
                decoration: InputDecoration(
                  hintText: "Write your review here...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                style: GoogleFonts.getFont(
                  'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0x99000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}