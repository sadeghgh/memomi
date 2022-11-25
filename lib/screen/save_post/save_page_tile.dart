import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/comment/comments.dart';
import 'package:memomi/screen/favor_and_unfavor/favor_my_post.dart';
import 'package:memomi/screen/favor_and_unfavor/un_favor_my_post.dart';
import 'package:memomi/screen/show_screen/show_other_profile.dart';
import 'package:memomi/screen/show_screen/show_screen.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SavePageListTile extends StatefulWidget {
  Map<String, dynamic> data;
  SavePageListTile(this.data, {Key? key}) : super(key: key);

  @override
  State<SavePageListTile> createState() => _SavePageListTileState();
}

class _SavePageListTileState extends State<SavePageListTile> {
  Map<String, dynamic>? data;

  giveData() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.data['ownerId'])
        .collection('userPosts')
        .doc(widget.data['postId'])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map<String, dynamic>?;
      }
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    giveData();
  }

  @override
  Widget build(BuildContext context) {
    return data != null
        ? myCard()
        : Container(
            height: 0,
          );
  }

  myCard() {
    GestureDetector(
        onTap: () {
          Get.to(ShowScreen(data!));
        },
        child: Card(
          color: Consts.backGroundColor,
          elevation: 3,
          shadowColor: Colors.black38,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin:
                        const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: (data!['imageProfile'] != null &&
                            data!['imageProfile'].isNotEmpty)
                        ? Image.network(
                            data!['imageProfile'],
                            fit: BoxFit.cover,
                            //width: 100,height: 100,
                          )
                        : Image.asset(
                            'assets/images/img.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                  TextButton(
                    child: Text(
                      data!['username'],
                      style: const TextStyle(color: Consts.appBarColor),
                    ),
                    onPressed: () {
                      Get.to(ShowOtherProfile(widget.data['ownerId']));
                    },
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin:
                        const EdgeInsets.only(right: 15, bottom: 5, left: 5),
                    child: (widget.data['image_urls'] != null &&
                            widget.data['image_urls'].isNotEmpty)
                        ? Image.network(
                            widget.data['image_urls'][0],
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 100.0,
                          )
                        : Image.asset(
                            'assets/images/img.jpg',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['subject'] != null
                              ? (widget.data['subject'])
                              : AppLocalizations.of(context).notadded,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.data['story'] != null
                              ? (widget.data['story'].length > 25
                                  ? widget.data['story'].substring(0, 22) +
                                      '...'
                                  : widget.data['story'])
                              : AppLocalizations.of(context).notadded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(UnFavoritMyPost(data!['unFavorit']));
                        },
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.black54,
                        ),
                      ),
                      Text(data!['countUnFavorit'])
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.to(Comments(data!));
                          },
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.black54,
                          )),
                      Text(data!['countComment'])
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(FavoritMyPost(data!['favorit']));
                        },
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                      Text(data!['countFavorit'])
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
