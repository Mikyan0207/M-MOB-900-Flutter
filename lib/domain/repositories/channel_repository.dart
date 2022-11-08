import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/channel_entity.dart';

class ChannelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ChannelEntity> create(ChannelEntity ce) async {
    final DocumentReference<Map<String, dynamic>> document =
        await _firestore.collection("Channels").add(ce.toJson());

    ce.id = document.id;
    await document.set(ce.toJson());

    return ce;
  }

  Future<List<ChannelEntity>> getServerChannels(String serverId) async {
    final List<Map<String, dynamic>> data = (await _firestore
            .collection("Channels")
            .where('Server.Id', isEqualTo: serverId)
            .get())
        .docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
      final Map<String, dynamic> r = e.data();

      r['Id'] = e.id;

      return r;
    }).toList();

    return ChannelEntity.fromJsonList(data);
  }
}
