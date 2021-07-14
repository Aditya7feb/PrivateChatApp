import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                return Text(
                  chatDocs[index]['text'],
                );
              });
        }
      },
    );
  }
}
