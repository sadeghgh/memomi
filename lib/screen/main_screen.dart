import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/home/favorite.dart';
import 'package:memomi/screen/home/home.dart';
import 'package:memomi/screen/home/inbox.dart';
import 'package:memomi/screen/home/profile.dart';
import 'package:memomi/screen/home/search.dart';
import 'package:memomi/screen/home/world.dart';
import 'package:memomi/screen/posts/add_post_screen.dart';
import 'package:memomi/widgets/const.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  int page = 0;
  int count = 0;
  int countInbox = 0;
  bool visibil = false;
  bool visibilInbox = false;
  bool home = true,
      world = false,
      fav = false,
      search = false,
      person = false,
      inbox = false;

  counterFavorite() async {
    await FirebaseFirestore.instance
        .collection('feed')
        .doc(currentUserUid)
        .collection('feedItems')
        .get()
        .then((snapshot) {
      for (var element in snapshot.docs) {
        if (element['seen'] == '0') {
          setState(() {
            count++;
          });
        }
      }
    });
  }

  visibility() {
    if (count > 0) {
      setState(() {
        visibil = true;
      });
    }
  }

  counterInbox() async {
    await FirebaseFirestore.instance
        .collection('inbox')
        .doc(currentUserUid)
        .collection('inboxItems')
        .get()
        .then((snapshot) {
      for (var element in snapshot.docs) {
        if (element['seen'] == '0') {
          setState(() {
            countInbox++;
          });
        }
      }
    });
  }

  visibilityInbox() {
    if (countInbox > 0) {
      setState(() {
        visibilInbox = true;
      });
    }
  }

  Widget returnPage(int page) {
    Widget s;
    if (page == 0) {
      s = HomePage(currentUserUid);
    } else if (page == 1) {
      s = const WorldPage();
    } else if (page == 2) {
      s = const Search();
    } else if (page == 3) {
      s = const InboxScreen();
    } else if (page == 4) {
      s = Favorite(currentUserUid);
    } else if (page == 5) {
      s = ProfileScreen(currentUserUid);
    } else {
      s = HomePage(currentUserUid);
    }
    return s;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    counterFavorite();
    counterInbox();
    visibility();
    visibilityInbox();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: returnPage(page),
        bottomNavigationBar: BottomAppBar(
          color: Consts.appBarColor,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: home == true
                            ? const Icon(Icons.home, color: Colors.black)
                            : const Icon(Icons.home,
                                color: Consts.backGroundColor),
                        onPressed: () {
                          setState(() {
                            page = 0;
                            home = true;
                            fav = false;
                            world = false;
                            search = false;
                            person = false;
                            inbox = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: world == true
                            ? const Icon(Icons.all_out, color: Colors.black)
                            : const Icon(Icons.all_out_outlined,
                                color: Consts.backGroundColor),
                        onPressed: () {
                          setState(() {
                            page = 1;
                            home = false;
                            fav = false;
                            search = false;
                            world = true;
                            person = false;
                            inbox = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: search == true
                            ? const Icon(Icons.search, color: Colors.black)
                            : const Icon(Icons.search,
                                color: Consts.backGroundColor),
                        onPressed: () {
                          setState(() {
                            page = 2;
                            home = false;
                            fav = false;
                            search = true;
                            world = false;
                            person = false;
                            inbox = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            icon: inbox == true
                                ? const Icon(Icons.inbox, color: Colors.black)
                                : const Icon(Icons.inbox_outlined,
                                    color: Consts.backGroundColor),
                            onPressed: () {
                              setState(() {
                                page = 3;
                                home = false;
                                fav = false;
                                search = false;
                                world = false;
                                person = false;
                                inbox = true;
                              });
                            },
                          ),
                          Visibility(
                            visible: visibilInbox,
                            child: Positioned(
                                bottom: 2,
                                right: 2,
                                child: Text(
                                  countInbox.toString(),
                                  style: const TextStyle(color: Colors.red),
                                )),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: fav == true
                                ? const Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                  )
                                : const Icon(Icons.favorite_border,
                                    color: Consts.backGroundColor),
                            onPressed: () {
                              setState(() {
                                page = 4;
                                home = false;
                                fav = true;
                                search = false;
                                world = false;
                                person = false;
                                inbox = false;
                              });
                            },
                          ),
                          Visibility(
                            visible: visibil,
                            child: Positioned(
                                bottom: 2,
                                right: 2,
                                child: Text(
                                  count.toString(),
                                  style: const TextStyle(color: Colors.red),
                                )),
                          )
                        ],
                      ),
                      IconButton(
                        icon: person == true
                            ? const Icon(
                                Icons.person,
                                color: Colors.black,
                              )
                            : const Icon(Icons.person_outlined,
                                color: Consts.backGroundColor),
                        onPressed: () {
                          setState(() {
                            page = 5;
                            home = false;
                            fav = false;
                            search = false;
                            world = false;
                            inbox = false;
                            person = true;
                          });
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Consts.appBarColor,
          onPressed: () {
            Get.to(const AddPostScreen());
          },
          child: const Icon(
            Icons.add,
            color: Consts.backGroundColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
