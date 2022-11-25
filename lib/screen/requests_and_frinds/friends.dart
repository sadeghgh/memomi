import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/screen/requests_and_frinds/friends_list_tile.dart';
import 'package:memomi/widgets/const.dart';

// ignore: must_be_immutable
class Friends extends StatefulWidget {
  String currentUserUid;
  Friends(this.currentUserUid, {Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  Map<String, dynamic> data = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Consts.appBar,
      backgroundColor: Consts.backGroundColor,
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('friends')
                .doc(widget.currentUserUid)
                .collection('friends')
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> objectsSnapsshot) {
              if (objectsSnapsshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              objectsSnapsshot.data!.docs.map((DocumentSnapshot document) {
                data = document.data()! as Map<String, dynamic>;
              });

              return ListView.builder(
                  reverse: false,
                  itemCount: data.length,
                  itemBuilder: (ctx, index) => FriendsListTile(data[index]));
            }),
      ),
    );
  }
}
