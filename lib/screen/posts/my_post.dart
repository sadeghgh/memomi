import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/screen/posts/my_post_list_tile.dart';
import 'package:memomi/widgets/const.dart';

// ignore: must_be_immutable
class MyPost extends StatefulWidget {
  String currentUserUid;
  MyPost(this.currentUserUid, {Key? key}) : super(key: key);

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  Map<String, dynamic> data = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Consts.appBar,
        body: SafeArea(
          child: SizedBox(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.currentUserUid)
                  .collection('userPosts')
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> objectsSnapsshot) {
                if (objectsSnapsshot.connectionState ==
                    ConnectionState.waiting) {
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
                    itemBuilder: (ctx, index) => MyPostListTile(data[index]));
              },
            ),
          ),
        ));
  }
}
