import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/user.dart';

class DatabaseService {

  DatabaseService(this.uid);
  final String uid;

  final CollectionReference<Map<String, dynamic>> userCollection =
  FirebaseFirestore.instance.collection("Users");

  Future<void> saveUser(String name, int waterCounter) async {
    return await userCollection.doc(uid).set({'name': name, 'waterCount': waterCounter});
  }

  AppUserData _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return AppUserData(
      uid: snapshot.id,
      name: data['name'],
      waterCounter: data['waterCount'],
    );
  }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  List<AppUserData> _userListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppUserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}