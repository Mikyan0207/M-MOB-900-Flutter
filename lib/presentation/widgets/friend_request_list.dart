import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starlight/domain/entities/friend_request_entity.dart';

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({
    super.key,
    required this.requestStream,
    required this.requestCardBuilder,
  });

  final Stream<QuerySnapshot<Map<String, dynamic>>> requestStream;
  final Widget Function(FriendRequestEntity fre) requestCardBuilder;

  List<Map<String, dynamic>> _parseFriendRequests(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<Map<String, dynamic>> requests = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data(),
        )
        .toList();

    return requests;
  }

  ListView _buildRequestsList(List<dynamic> requests) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      shrinkWrap: true,
      itemCount: requests.length,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        final FriendRequestEntity fre = FriendRequestEntity.fromJson(
          requests[index],
        );

        return requestCardBuilder.call(fre);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: requestStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return _buildRequestsList(
            _parseFriendRequests(snapshot.data!.docs),
          );
        }
      },
    );
  }
}
