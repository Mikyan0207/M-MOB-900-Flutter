import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/auth/auth_controller.dart';
import 'package:starlight/domain/entities/message_entity.dart';
import 'package:starlight/presentation/widgets/message_box.dart';

class MessagesList extends StatelessWidget {
  MessagesList({
    Key? key,
    required this.firestoreStream,
    required this.noDataWidget,
  }) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> firestoreStream;
  final Widget noDataWidget;

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestoreStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return noDataWidget;
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: buildMessageList(parseMessages(snapshot.data!.docs)),
          );
        }
      },
    );
  }

  List<Map<String, dynamic>> parseMessages(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<Map<String, dynamic>> messages = docs
        .map(
          (
            QueryDocumentSnapshot<Map<String, dynamic>> e,
          ) =>
              e.data(),
        )
        .toList();

    messages.sort((
      Map<String, dynamic> a,
      Map<String, dynamic> b,
    ) {
      return (b['Time'] as Timestamp).compareTo(a['Time'] as Timestamp);
    });

    return messages;
  }

  ListView buildMessageList(List<Map<String, dynamic>> messages) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return displayMessage(messages, index);
      },
      itemCount: messages.length,
      shrinkWrap: true,
      reverse: true,
      controller: ScrollController(),
    );
  }

  bool isSameAuthorWithSimilarTimestamp(
    MessageEntity previousMessage,
    MessageEntity currentMessage,
  ) {
    return previousMessage.author.id == currentMessage.author.id &&
        currentMessage.time.toDate().millisecondsSinceEpoch <=
            previousMessage.time
                .toDate()
                .add(const Duration(minutes: 15))
                .millisecondsSinceEpoch;
  }

  bool isMentionForCurrentUser(String message) {
    final Iterable<RegExpMatch> matches =
        RegExp(r"\[(@([^\]]+)):([^\]]+)\]").allMatches(message);

    for (final RegExpMatch match in matches) {
      if (match.group(3) == _authController.currentUser.value.idDocument) {
        return true;
      }
    }

    return false;
  }

  Widget displayMessage(List<Map<String, dynamic>> messages, int index) {
    final MessageEntity message = MessageEntity.fromJson(messages[index]);
    if (index + 1 < messages.length &&
        isSameAuthorWithSimilarTimestamp(
          MessageEntity.fromJson(messages[index + 1]),
          message,
        )) {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: MessageBox(
          message: message,
          showAuthor: false,
          showAvatar: false,
          showTime: false,
          isMention:
              RegExp(r"\[(@([^\]]+)):([^\]]+)\]").hasMatch(message.content),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: MessageBox(
        message: message,
        showAuthor: true,
        showAvatar: true,
        showTime: true,
        isMention: isMentionForCurrentUser(message.content),
      ),
    );
  }
}
