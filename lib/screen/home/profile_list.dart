import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/posts/my_post.dart';
import 'package:memomi/screen/requests_and_frinds/friends.dart';
import 'package:memomi/screen/show_screen/show_screen_my_post.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ProfileList extends StatefulWidget {
  String currentUserUid;
  ProfileList(this.currentUserUid, {Key? key}) : super(key: key);

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  Map<String, dynamic>? user;
  int counterPost = 0;
  int counterFreinds = 0;
  bool posts = true;
  Map<String, dynamic> mustLike = {};
  int cunterMustLike = 0;
  Map<String, dynamic> mustDislike = {};
  int cunterMustDislike = 0;
  Map<String, dynamic> mustComment = {};
  int cunterComment = 0;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    giveProfiles();
    giveMyPosts();
    giveMyfriends();
    getMostComment();
    getMostLike();
    getMostDislike();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: 128.0,
            height: 128.0,
            margin: const EdgeInsets.only(
              top: 24.0,
              bottom: 64.0,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: (user!['image_url'] != null && user!['image_url'].isNotEmpty)
                ? Image.network(
                    user!['image_url'],
                    fit: BoxFit.cover,
                    //width: 100,height: 100,
                  )
                : Image.asset(
                    'assets/images/img.jpg',
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    posts == false
                        ? Text(
                            counterPost.toString(),
                            style: const TextStyle(color: Colors.black26),
                          )
                        : Text(
                            counterPost.toString(),
                          ),
                    const Center(
                      child: Divider(
                        color: Colors.black,
                        height: 20,
                        thickness: 5,
                        indent: 20,
                        endIndent: 0,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(MyPost(widget.currentUserUid));
                        },
                        child: Text(
                          AppLocalizations.of(context).send,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Column(
                  children: [
                    Text(counterFreinds.toString()),
                    const Center(
                      child: Divider(
                        color: Colors.black,
                        height: 20,
                        thickness: 5,
                        indent: 20,
                        endIndent: 0,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(Friends(widget.currentUserUid));
                        },
                        child: Text(
                          AppLocalizations.of(context).friends,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(ShowScreenMyPost(mustLike));
                  },
                  child: Text(
                    AppLocalizations.of(context).thisPostHasTheMostLikes +
                        ' : ' +
                        cunterMustLike.toString(),
                    style: Consts.textStyleOne,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(ShowScreenMyPost(mustDislike));
                  },
                  child: Text(
                    AppLocalizations.of(context).thiPostHasTheLeastLikes +
                        ' : ' +
                        cunterMustDislike.toString(),
                    style: Consts.textStyleOne,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(ShowScreenMyPost(mustComment));
                  },
                  child: Text(
                    AppLocalizations.of(context).thisPostHasTheMostComments +
                        ' : ' +
                        cunterComment.toString(),
                    style: Consts.textStyleOne,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  giveProfiles() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.currentUserUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        user = documentSnapshot.data() as Map<String, dynamic>?;
      }
    });
  }

  giveMyPosts() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.currentUserUid)
        .collection('userPosts')
        .get()
        .then((snapshot) {
      setState(() {
        counterPost = snapshot.docs.length;
      });
    });
  }

  giveMyfriends() async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(widget.currentUserUid)
        .collection('friends')
        .get()
        .then((snapshot) {
      for (var element in snapshot.docs) {
        if (element['request'] == 'yes') {
          setState(() {
            counterFreinds++;
          });
        }
      }
    });
  }

  getMostLike() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.currentUserUid)
        .collection('userPosts')
        .get()
        .then((snapshot) {
      // cunterFriends = snapshot.data()!.length;
      for (var element in snapshot.docs) {
        if (int.parse(element['countFavorit']) > cunterMustLike) {
          setState(() {
            cunterMustLike = int.parse(element['countFavorit']);
          });
          if (mustLike.isNotEmpty) {
            mustLike.clear();
          }
          mustLike = element.data();
        }
      }
    });
  }

  getMostDislike() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.currentUserUid)
        .collection('userPosts')
        .get()
        .then((snapshot) {
      // cunterFriends = snapshot.data()!.length;
      for (var element in snapshot.docs) {
        if (int.parse(element['countUnFavorit']) > cunterMustDislike) {
          setState(() {
            cunterMustDislike = int.parse(element['countUnFavorit']);
          });
          if (mustDislike.isNotEmpty) {
            mustDislike.clear();
          }
          mustDislike = element.data();
        }
      }
    });
  }

  getMostComment() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.currentUserUid)
        .collection('userPosts')
        .get()
        .then((snapshot) {
      // cunterFriends = snapshot.data()!.length;
      for (var element in snapshot.docs) {
        if (int.parse(element['countComment']) > cunterComment) {
          setState(() {
            cunterComment = int.parse(element['countComment']);
          });
          if (mustComment.isNotEmpty) {
            mustComment.clear();
          }
          mustComment = element.data();
        }
      }
    });
  }
}
