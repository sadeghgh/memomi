import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memomi/helper/firbase_helper.dart';
import 'package:memomi/screen/comment/comments_tile.dart';
import 'package:memomi/widgets/const.dart';
import 'package:memomi/widgets/custom_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class Comments extends StatefulWidget {
  Map<String, dynamic> data;
  Comments(this.data, {Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String postId = '';
  Map<String, dynamic> data = {};
  String mediaUrl = '';
  int countComment = 0;
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;
  String comment = '';
  String userName = '';
  String imageProfile = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    postId = widget.data['postId'];
    countComment = int.parse(widget.data['countComment']);
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Consts.backGroundColor,
      appBar: Consts.appBar,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: height / 4.5),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('comments')
                        .doc(postId)
                        .collection('comments')
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
                              CommentsListTile(data[index]));
                    })),
            Container(
              padding: EdgeInsets.only(top: height / 1.3),
              child: CustomInput(
                  hinttext: AppLocalizations.of(context).writeYourComment,
                  onChanged: (value) {
                    comment = value;
                  },
                  checkPassword: false,
                  keyboardType: TextInputType.multiline,
                  maxLength: 500,
                  maxLines: 3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Consts.appBarColor,
        onPressed: () async {
          Map<String, dynamic> objectData = {
            'userId': currentUserUid,
            'userName': userName,
            'imageProfile': imageProfile,
            'comment': comment,
            'date': Timestamp.fromDate(DateTime.now()),
          };

          String ok = await FirebaseHelper.addComment(postId, objectData);
          if (ok == 'ok') {
            Map<String, dynamic> data = {
              'type': 'comment',
              'seen': '0',
              'comment': comment,
              'userId': currentUserUid,
              'userName': userName,
              'imageProfile': imageProfile,
              'postId': postId,
              'mediaUrl': mediaUrl,
              'time': Timestamp.fromDate(DateTime.now()),
            };

            String com = await FirebaseHelper.typeNotification(
                widget.data['ownerId'], postId, data);
            if (com == 'ok') {
              countComment++;
              String count = countComment.toString();
              await FirebaseHelper.counterComment(
                  currentUserUid, postId, count);
              //peigham bede va be safe ghabl bargarde
            }
          }
        },
        child: const Icon(
          Icons.send,
          color: Consts.backGroundColor,
        ),
      ),
    );
  }

  getUserName() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? user;
        user = documentSnapshot.data() as Map<String, dynamic>?;
        userName = user!['username'];
        imageProfile = user['image_url'];
      }
    });
  }
}
