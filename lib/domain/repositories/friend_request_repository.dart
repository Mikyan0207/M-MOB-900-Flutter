import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/friend_request_entity.dart';

class FriendRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> create(FriendRequestEntity fre) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("FriendRequests").add(fre.toJson());

    fre.id = document.id;
    await document.set(fre.toJson());
  }

  Future<void> delete(FriendRequestEntity fre) async {
    await _firestore.collection("FriendRequests").doc(fre.id).delete();
  }

  Future<void> update(FriendRequestEntity fre) async {
    await _firestore
        .collection("FriendRequests")
        .doc(fre.id)
        .update(fre.toJson());
  }
}
