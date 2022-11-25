import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/comment/comments.dart';
import 'package:memomi/screen/favor_and_unfavor/favor_my_post.dart';
import 'package:memomi/screen/favor_and_unfavor/un_favor_my_post.dart';
import 'package:memomi/widgets/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ShowScreen extends StatefulWidget {
  Map<String, dynamic> data;
  ShowScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<ShowScreen> createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> unFavorit = {};
  Map<String, dynamic> favorit = {};
  int intUnFav = 0;
  int intFav = 0;
  int intComment = 0;
  bool unFav = false;
  bool fav = false;
  bool save = false;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    favAndUnFav();
    giveSave();
    intUnFav = int.parse(widget.data['countUnFavorit']);
    intFav = int.parse(widget.data['countFavorit']);
    intComment = int.parse(widget.data['countComment']);
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: Consts.appBar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: widget.data['image_urls'].length,
                itemBuilder: ((context, index, realIndex) =>
                    (widget.data['image_urls'] != null &&
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
                          )),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  widget.data['subject'] != null
                      ? (widget.data['subject'])
                      : AppLocalizations.of(context).notadded,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                itemCount: widget.data['select_Interests'].length,
                itemBuilder: (context, index) => Text(
                  widget.data[index],
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 10),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                child: Text(
                  widget.data['story'] != null
                      ? (widget.data['story'])
                      : AppLocalizations.of(context).notadded,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        color: Colors.black54,
                        icon: unFav == false
                            ? const Icon(Icons.favorite_border)
                            : const Icon(Icons.favorite),
                        onPressed: () {
                          setState(() {
                            if (unFav == false) {
                              updateUnFavPositive();
                              if (fav == true) {
                                updateUnFavPositive();
                                updateFavNegative();
                              }
                            } else {
                              updateUnFavNegative();
                            }
                          });
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            if (intUnFav > 0) {
                              Get.to(UnFavoritMyPost(widget.data['unFavorit']));
                            }
                          },
                          child: Text(intUnFav.toString()))
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.save,
                      color: save == false ? Colors.black54 : Colors.black,
                    ),
                    onPressed: () {
                      if (save == false) {
                        createSave();
                      } else {
                        deleteSave();
                      }
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.black54),
                        onPressed: () {
                          if (intComment > 0) {
                            Get.to(Comments(widget.data));
                          }
                        },
                      ),
                      Text(intComment.toString())
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: fav == false
                            ? const Icon(Icons.favorite_border,
                                color: Colors.red)
                            : const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            if (fav == false) {
                              updateFavPositive();
                              if (unFav == true) {
                                updateFavPositive();
                                updateUnFavNegative();
                              }
                            } else {
                              updateFavNegative();
                            }
                          });
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            if (intFav > 0) {
                              Get.to(FavoritMyPost(widget.data['favorit']));
                            }
                          },
                          child: Text(intFav.toString()))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  favAndUnFav() {
    favorit = widget.data['favorit'];
    if (favorit[currentUserUid] == true) {
      setState(() {
        fav = true;
      });
    } else {
      setState(() {
        fav = false;
      });
    }

    unFavorit = widget.data['unFavorit'];
    if (unFavorit[currentUserUid] == true) {
      setState(() {
        unFav = true;
      });
    } else {
      setState(() {
        unFav = false;
      });
    }
  }

  updateFavPositive() async {
    setState(() {
      intFav++;
    });
    favorit[currentUserUid] = true;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.data['ownerId'])
        .collection('userPosts')
        .doc(widget.data['postId'])
        .update({'favorit': favorit, 'countFavorit': intFav.toString()});
  }

  updateFavNegative() async {
    setState(() {
      intFav--;
    });
    favorit[currentUserUid] = false;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.data['ownerId'])
        .collection('userPosts')
        .doc(widget.data['postId'])
        .update({'favorit': favorit, 'countFavorit': intFav.toString()});
  }

  updateUnFavPositive() async {
    setState(() {
      intUnFav++;
    });
    unFavorit[currentUserUid] = true;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.data['ownerId'])
        .collection('userPosts')
        .doc(widget.data['postId'])
        .update(
            {'unFavorit': unFavorit, 'countUnFavorit': intUnFav.toString()});
  }

  updateUnFavNegative() async {
    setState(() {
      intFav--;
    });
    unFavorit[currentUserUid] = false;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.data['ownerId'])
        .collection('userPosts')
        .doc(widget.data['postId'])
        .update(
            {'unFavorit': unFavorit, 'countUnFavorit': intUnFav.toString()});
  }

  giveSave() async {
    await FirebaseFirestore.instance
        .collection('save')
        .doc(currentUserUid)
        .collection('save')
        .doc(widget.data['postId'])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? saves =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (saves!['ownerId'] == widget.data['ownerId'] &&
            saves['postId'] == widget.data['postId']) {
          setState(() {
            save = true;
          });
        }
      }
    });
  }

  deleteSave() async {
    await FirebaseFirestore.instance
        .collection('save')
        .doc(currentUserUid)
        .collection('save')
        .doc(widget.data['postId'])
        .delete();

    setState(() {
      save = false;
    });
  }

  createSave() async {
    await FirebaseFirestore.instance
        .collection('save')
        .doc(currentUserUid)
        .collection('save')
        .doc(widget.data['postId'])
        .set({
      'ownerId': widget.data['ownerId'],
      'postId': widget.data['postId']
    });
  }
}
