import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mycityguide/Admin/Add_Hotels.dart';
import 'package:mycityguide/Admin/All_Users.dart';
import 'package:mycityguide/Admin/Dashbord.dart';
import 'package:mycityguide/Admin/View_hotels.dart';
import 'package:mycityguide/Admin/Web_main.dart';
import 'package:mycityguide/Admin/Add_Attractions.dart';
import 'package:mycityguide/Admin/all_Reviews.dart';
import 'package:mycityguide/Admin/view_Attractions.dart';
import 'package:mycityguide/pages/sigin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb){
    await Firebase.initializeApp(
     options:const FirebaseOptions(
  apiKey: "AIzaSyDEu6MBVXjeOFl_17G1CpaaMmeRx745WOg",
  authDomain: "mycityguide-e8828.firebaseapp.com",
  projectId: "mycityguide-e8828",
  storageBucket: "mycityguide-e8828.appspot.com",
  messagingSenderId: "1024120836899",
  appId: "1:1024120836899:web:38e8abe4a9beb14da27296",
  measurementId: "G-BE08NM260V"
     
      )
  );
  
  }
  else{
  await Firebase.initializeApp(
     options:const FirebaseOptions(
      apiKey: "AIzaSyC94UnD9XCRwMpf3m_bRFBsKP0Zbb2k9gM", 
      appId: "1:1024120836899:android:51ffb4417c5758c0a27296", 
      messagingSenderId:"1024120836899", 
      projectId: "mycityguide-e8828"
      )
  );
  }

  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      
      title: "City Guide",
      home: const LoginPage(),
      routes: {
        WebMain.id: (context)=> const WebMain(),
        AddHotels.id: (context)=> const AddHotels(),        
        ViewHotels.id: (context)=> const ViewHotels(),
        Dashboard.id: (context)=> const Dashboard(),
        AddServices.id: (context)=> const AddServices(),
       UsersDetails.id: (context)=> const UsersDetails(),
       AllReviews.id: (context)=> const AllReviews(),
      //  favorite.id: (context)=> const favorite(),
        ViewCategariesitems.id: (context)=> const ViewCategariesitems(),
      },
      
      
    );
  }
}
