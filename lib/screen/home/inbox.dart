import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/screen/home/inbox_tile.dart';
import 'package:memomi/widgets/const.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  Map<String, dynamic> data = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Consts.appBar,
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collectionGroup('userPosts')
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final objectDocs = snapshot.data!.docs;
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  data = document.data()! as Map<String, dynamic>;
                });

                return ListView.builder(
                    reverse: false,
                    itemCount: objectDocs.length,
                    itemBuilder: (ctx, index) => InboxListTile(data[index]));
              })),
    );
  }
}
