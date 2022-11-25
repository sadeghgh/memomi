import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/screen/save_post/save_page_tile.dart';
import 'package:memomi/widgets/const.dart';

// ignore: must_be_immutable
class SavePage extends StatefulWidget {
  String currentUserUid;
  SavePage(this.currentUserUid, {Key? key}) : super(key: key);

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  Map<String, dynamic> data = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Consts.appBar,
        body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('save')
                    .doc(widget.currentUserUid)
                    .collection('save')
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
                      itemBuilder: (ctx, index) =>
                          SavePageListTile(data[index]));
                })));
  }
}
