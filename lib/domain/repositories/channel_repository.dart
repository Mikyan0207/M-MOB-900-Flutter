import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/channel_entity.dart';

class ChannelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ChannelEntity> create(ChannelEntity ce) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Channels").add(ce.toJson());

    ce.id = document.id;
    await document.set(<String, dynamic>{'Id': ce.id}, SetOptions(merge: true));

    return ce;
  }

  Future<ChannelEntity> get(String id) async {
    final Map<String, dynamic>? data =
        (await _firestore.collection("Channels").doc(id).get()).data();

    return ChannelEntity.fromJson(data);
  }

  Future<List<ChannelEntity>> getWhereIsEqualTo(
    String field,
    Object value,
  ) async {
    final List<Map<String, dynamic>> data = (await _firestore
            .collection("Channels")
            .where(field, isEqualTo: value)
            .get())
        .docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data())
        .toList();

    return ChannelEntity.fromJsonList(data);
  }
}
