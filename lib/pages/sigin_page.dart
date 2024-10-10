import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycityguide/Services/share_preference.dart';
import 'package:mycityguide/pages/BottomNav/bottombar.dart';
import 'package:mycityguide/pages/Signup_page.dart';
import 'package:mycityguide/pages/forget_password.dart';
import 'package:mycityguide/text_file_model/button.dart';
import 'package:mycityguide/text_file_model/text_file.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> userLogin(
    BuildContext context,
    String mail,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: password);

      User? user = userCredential.user;

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("Email", isEqualTo: mail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          String userId = userDoc.id;
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          if (userData != null) {
            await SharedPrefHelper().saveUserName(userData["Name"]);
            await SharedPrefHelper().saveUserImage(userData["Image"]);
            await SharedPrefHelper().saveUserEmail(userData["Email"]);
            // await SharedPrefHelper().saveUserEmail(userData["Contact"]);
            // await SharedPrefHelper().saveUserEmail(userData["Address"]);
            await SharedPrefHelper().saveUserId(userId);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.blue,
              content: Text(
                "Login Successfully",
                style: TextStyle(fontSize: 20),
              ),
            ));

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Bottombar()));
          } else {
            throw Exception("User Data is null");
          }
        } else {
          throw Exception("User Document is null");
        }
      } else {
        throw Exception("User is null");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "invalid-email") {
        errorMessage = "No User found for the email";
      } else if (e.code == "wrong-password") {
        errorMessage = "Wrong password provided by the user";
      } else {
        errorMessage = "Unexpected error occurred: ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 20),
        ),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Failed to fetch user data: ${e.toString()}",
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: spacing * 1.5),
                  const Text(
                    "Sign in now",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: spacing),
                  const Text(
                    "Please sign in to continue using our app",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: spacing),
                  MyTextField(
                    hintText: "Enter Email",
                    obscureText: false,
                    controller: emailcontroller,
                    obsureText: false,
                  ),
                  SizedBox(height: spacing),
                  MyTextField(
                    hintText: "Enter Password",
                    obscureText: true,
                    controller: passwordcontroller,
                    obsureText: false,
                  ),
                  SizedBox(height: spacing / 3),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPassword()));
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Color.fromRGBO(13, 110, 253, 1.000)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing),
                  Button(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        userLogin(
                          context,
                          emailcontroller.text,
                          passwordcontroller.text,
                        );
                      }
                    },
                    text: "Sign In",
                  ),
                  SizedBox(height: spacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                              color: Color.fromRGBO(13, 110, 253, 1.000)),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "\nOr connect",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: spacing),
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
