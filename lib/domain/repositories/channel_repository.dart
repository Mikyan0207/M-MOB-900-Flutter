import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/domain/entities/channel_entity.dart';

class ChannelRepository {
  Future<List<ChannelEntity>> getServerChannels(String serverId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final List<Map<String, dynamic>> data = (await firestore
            .collection("Channels")
            .where('ServerId', isEqualTo: serverId)
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
