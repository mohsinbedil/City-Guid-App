import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addEmployeeDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }


  Future<Stream<QuerySnapshot>> getUserDetails() async{
    return  FirebaseFirestore.instance.collection("users").snapshots();
  }

   Future updateEmployeeDetails(
     String id, Map<String, dynamic> updateInfo ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(updateInfo);
  }

 Future DeleteUserDetails(String Id)async{
    return await FirebaseFirestore.instance
    .collection("users")
    .doc(Id)
    .delete();
  }

// get Attraction
      Future<Stream<QuerySnapshot>> getattractions() async{
    return  FirebaseFirestore.instance.collection("Attractions").snapshots();
  }

   Future addReview(Map<String, dynamic> reviewInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("reviews")
        .doc(id)
        .set(reviewInfoMap);
  }

   Future<Stream<QuerySnapshot>> getReviews() async{
    return  FirebaseFirestore.instance.collection("reviews").snapshots();
  }

  
// get Hotels
      Future<Stream<QuerySnapshot>> getHotels() async{
    return  FirebaseFirestore.instance.collection("Hotels").snapshots();
  }
}
