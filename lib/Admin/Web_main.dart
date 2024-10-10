import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:mycityguide/Admin/Add_Hotels.dart';
import 'package:mycityguide/Admin/All_Users.dart';
import 'package:mycityguide/Admin/Dashbord.dart';
import 'package:mycityguide/Admin/View_hotels.dart';
import 'package:mycityguide/Admin/Add_Attractions.dart';
import 'package:mycityguide/Admin/all_Reviews.dart';
import 'package:mycityguide/Admin/view_Attractions.dart';


class WebMain extends StatefulWidget {
  const WebMain({super.key});
  static const String id = "Web_main";

  @override
  State<WebMain> createState() => _WebMainState();
}

class _WebMainState extends State<WebMain> {

  Widget selectedScreen =  Dashboard();

  void chooseScreen(String? route){
    switch(route){
      case Dashboard.id:
      setState(() {
        selectedScreen = const Dashboard();
      });
      break;

      case AddHotels.id:
      setState(() {
        selectedScreen = const AddHotels();
      });
      break;

      case AddServices.id:
      setState(() {
        selectedScreen = const AddServices();
      });
      break;

      case ViewCategariesitems.id:
      setState(() {
        selectedScreen = const ViewCategariesitems();
      });
      break;

      case UsersDetails.id:
      setState(() {
        selectedScreen = const UsersDetails();
      });
      break;

       case AllReviews.id:
      setState(() {
        selectedScreen = const AllReviews();
      });
      break;
      // case favorite.id:
      // setState(() {
      //   selectedScreen = const favorite();
      // });
      // break;

      case ViewHotels.id:
      setState(() {
        selectedScreen = const ViewHotels();
      });
      break;

    }
  }
  @override
  Widget build(BuildContext context) {
    return  AdminScaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 37, 67),
        title: const Text("Admin Panel",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        iconTheme: const IconThemeData(
          color: Colors.white
        )
      ),
      sideBar: SideBar(
        onSelected: (item)=> chooseScreen(item.route) ,
        items: const [
          AdminMenuItem(
            title: "DASHBOARD",
            icon: Icons.dashboard,
            route: Dashboard.id,
            ),
             AdminMenuItem(
            title: "Users Details",
            icon: Icons.people,
            route: UsersDetails.id,
            ),

            AdminMenuItem(
            title: "All Reviews",
            icon: Icons.people,
            route: AllReviews.id,
            ),
            
            // AdminMenuItem(
            // title: "All Favorites",
            // icon: Icons.people,
            // route: favorite.id,
            // ),

             AdminMenuItem(
            title: "View Hotels",
            icon: Icons.hotel_sharp,
            route: ViewHotels.id,
            ),

              AdminMenuItem(
            title: "View Places",
            icon: Icons.category,
            route: ViewCategariesitems.id,
            ),

          AdminMenuItem(
            title: "Add Hotels",
            icon: Icons.add_business,
            route: AddHotels.id,
            ),
           
          AdminMenuItem(
            title: "Add Places",
            icon: Icons.add_box,
            route: AddServices.id,
            ),
          
        ], selectedRoute: Dashboard.id,
      ), body: selectedScreen  ,
    
      // body: ,
    );
  }
}