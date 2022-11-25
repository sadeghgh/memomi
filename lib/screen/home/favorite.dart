import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/widgets/const.dart';
import 'favorite_list_tile.dart';

// ignore: must_be_immutable
class Favorite extends StatefulWidget {
  String currentUserUid;
  Favorite(this.currentUserUid, {Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  Map<String, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Consts.appBar,
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('feed')
                  .doc(widget.currentUserUid)
                  .collection('feedItems')
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
                    itemBuilder: (ctx, index) => FavoriteListTile(data[index]));
              })),
    );
  }
}
