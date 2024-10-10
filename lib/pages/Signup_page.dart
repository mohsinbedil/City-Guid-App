import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycityguide/Services/data.dart';
import 'package:mycityguide/pages/sigin_page.dart';
import 'package:mycityguide/text_file_model/button.dart';
import 'package:mycityguide/text_file_model/text_file.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
   String? name, mail, password;

  TextEditingController usercontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey =
      GlobalKey<FormState>(); // widget 'uniquelu' identify in UI design

  registration() async {
    if (name != null && mail != null && password != null) {
      try {
        // Erroe Handling
        await FirebaseAuth
            .instance // userCredential class come from auth dependency
            .createUserWithEmailAndPassword(email: mail!, password: password!);

        String id = randomAlphaNumeric(10);

        Map<String, dynamic> userInfoMap = {
          "id": id,
          "Name": name,
          "Email": mail,
          "Contact": '0923083213',
          "Address": 'Adress ',
          "Image":
              "https://img.freepik.com/free-vector/cute-detective-bear-cartoon-character_138676-2911.jpg?t=st=1724242859~exp=1724246459~hmac=8f34071c2563d58b6dc7a3ea9c5504d9e3043f10141a5ceef5412a8826f3ab64&w=740",
        };
        await DatabaseMethods().addEmployeeDetails(userInfoMap, id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blue[600],
            content: const Text(
              "Registrated Successfully",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blue[600],
              content: const Text(
                "Password Provide is to weak",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blue[600],
              content: const Text(
                "Acount already Exist",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )));
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.008;
    final spacing = size.height * 0.03;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
           child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: spacing * 1.5),

                  // Sign up title
                  const Text(
                    "Sign Up now",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: spacing),

                  // Please fill the details and create an account (text)
                  const Text(
                    "Please fill the details and create an account",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: spacing),

                  // Username textfield
                  MyTextField(
                    hintText: "Enter Username",
                    obscureText: false,
                    controller: usercontroller, obsureText: false,
                    validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Username";
                          }
                          return null;
                        },
                  ),
                  SizedBox(height: spacing),

                  // Email textfield
                  MyTextField(
                    hintText: "Enter Email",
                    obscureText: false,
                    controller: emailcontroller, obsureText: false,
                    validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Email";
                          }
                          return null;
                        },
                  ),
                  SizedBox(height: spacing),

                  // Password textfield
                  MyTextField(
                    hintText: "Enter Password",
                    obscureText: true,
                    controller: passwordcontroller, obsureText: false,
                    validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Password";
                          }
                          return null;
                        },
                  ),
                  SizedBox(height: spacing / 3),

                  // Password must be 8 characters (text)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Password must be 8 characters",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing),

                  // Sign up button
                  Button(
                    onTap: () {
                  
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                            mail = emailcontroller.text;
                            password = passwordcontroller.text;
                            name = usercontroller.text; 
                        });
                        registration();
                      }
                    },
                    text: "Sign Up",
                  ),
                  SizedBox(height: spacing),

                  // Already have an account? Sign in or connect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(color: Color.fromRGBO(13, 110, 253, 1.000)),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "\nOr connect",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: spacing),

                  // Icons of Facebook, Instagram, Twitter
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/facebook1.png"),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/insta.png"),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/Twitter1.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
