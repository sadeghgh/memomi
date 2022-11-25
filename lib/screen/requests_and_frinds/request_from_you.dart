import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/screen/requests_and_frinds/request_from_you_tile.dart';
import 'package:memomi/widgets/const.dart';

// ignore: must_be_immutable
class RequestFromYou extends StatefulWidget {
  String currentUserUid;
  RequestFromYou(this.currentUserUid, {Key? key}) : super(key: key);

  @override
  State<RequestFromYou> createState() => _RequestFromYouState();
}

class _RequestFromYouState extends State<RequestFromYou> {
  Map<String, dynamic> data = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Consts.appBar,
        body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('friends')
                    .doc(widget.currentUserUid)
                    .collection('friends')
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
                          RequestFromYouListTile(data[index]));
                })));
  }
}
