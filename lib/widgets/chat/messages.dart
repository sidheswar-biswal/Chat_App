import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: FirebaseAuth.instance.currentUser,
    //   builder: (ctx, futureSnapshot) {
    //     if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    final user = FirebaseAuth.instance.currentUser;
        return StreamBuilder<dynamic>(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy(
              'createdAt',
              descending: true,
            )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                  chatDocs[index]['userId'] == user!.uid,
                  key: ValueKey(chatDocs[index].id),
                ),
              );
            }
        );
    }
}
