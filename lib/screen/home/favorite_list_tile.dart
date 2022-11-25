import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/helper/firbase_helper.dart';
import 'package:memomi/screen/show_screen/show_other_profile.dart';
import 'package:memomi/screen/show_screen/show_screen.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class FavoriteListTile extends StatefulWidget {
  Map<String, dynamic> data;
  FavoriteListTile(this.data, {Key? key}) : super(key: key);

  @override
  State<FavoriteListTile> createState() => _FavoriteListTileState();
}

class _FavoriteListTileState extends State<FavoriteListTile> {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? story;
  String type = '';
  bool seen = false;
  getType() {
    if (widget.data['type'] == 'favorit') {
      setState(() {
        type = AppLocalizations.of(context).likedYourStory;
      });
    } else if (widget.data['type'] == 'unFavorit') {
      setState(() {
        type = AppLocalizations.of(context).dontLikeYourStory;
      });
    } else if (widget.data['type'] == 'comment') {
      setState(() {
        type = AppLocalizations.of(context).writeaCommentForYourStory;
      });
    }
  }

  updateSeen() {
    if (widget.data['seen'] == 0) {
      setState(() {
        seen = true;
      });
      FirebaseHelper.updateNotification(currentUserUid, widget.data['postId']);
    }
  }

  showPost() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(currentUserUid)
        .collection('userPosts')
        .doc(widget.data['postId'])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        story = documentSnapshot.data() as Map<String, dynamic>?;
      }
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getType();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(ShowScreen(story!));
        },
        child: Card(
          color: Consts.backGroundColor,
          elevation: 3,
          shadowColor: Colors.black38,
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: (widget.data['imageProfile'] != null &&
                            widget.data['imageProfile'].isNotEmpty)
                        ? Image.network(
                            widget.data['imageProfile'],
                            fit: BoxFit.cover,
                            //width: 100,height: 100,
                          )
                        : Image.asset(
                            'assets/images/img.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    child: Text(
                      widget.data['userName'],
                      style: const TextStyle(color: Consts.appBarColor),
                    ),
                    onPressed: () {
                      Get.to(ShowOtherProfile(widget.data['userId']));
                    },
                  ),
                  Text(
                    type,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
