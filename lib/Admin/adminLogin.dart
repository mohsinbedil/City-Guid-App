import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycityguide/Admin/Web_main.dart';
import 'package:mycityguide/Admin/gradientButton/gradient_btn.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usercontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:  Container(
          decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 2, 140, 253),Color.fromARGB(255, 160, 211, 253)],
                    begin: Alignment.topLeft,
                    end: Alignment.topCenter,
                  )
                ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10,top: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: Text("Admin Panel",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                // color:  Color.fromARGB(255, 0, 129, 235),
                
              ),
              Container(
                padding: EdgeInsets.only(top: 40,left: 30,bottom: 30),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 249, 249, 249),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)

                  )
                ),
                child:  Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     SizedBox(height: 40,),
                     const Text("Username",
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.blue),),

                     TextFormField(
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return "Please enter your Username";
                        }
                       return null; 
                      },
                      controller: usercontroller,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                       icon: Icon(Icons.person, color: Colors.blue,),
                        enabledBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 121, 120, 120))
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        ),
                        hintText: "Enter Username", 
                      ),
                     ),

                      SizedBox(height: 20,),
                     const Text("Password",
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.blue),),

                     TextFormField(
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return "Please enter your Password";
                        }
                       return null; 
                      },
                      controller: passwordcontroller,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password, color: Colors.blue,),
                        enabledBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 121, 120, 120))
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        ),
                      hintText: "Enter Password",                     
                      ),
                      obscureText:true,
                      obscuringCharacter: "*",
                     ),
                     SizedBox(height: 20,),

                     Center(
                       child: GradientButton(text: "Login", onPressed: (){ AdminLogin(); },colors: [
                        Color.fromARGB(255, 2, 140, 253),Color.fromARGB(255, 160, 211, 253)
                       ], )
                          
                     )


                    ],
                  ),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AdminLogin(){
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot){
      snapshot.docs.forEach((result){
        if(result.data()["Name"] != usercontroller.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              "Your given Credential is not correct",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            
          ));
        }
        else if(result.data()["Password"] != passwordcontroller.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              "Your given Credential is not correct",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            
          ));

        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WebMain()));
        }
      });
    });
  }
}

