import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/screen/home/search_tile_acount.dart';
import 'package:memomi/screen/home/search_tile_post.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Map<String, dynamic> data = {};
  String objects = '';
  bool posts = false;
  bool acount = true;
  bool searchBy = true;
  String order = 'acount';
  late OverlayEntry _orderEntry;
  late OverlayState _orderlay;
  @override
  void initState() {
    super.initState();
    _orderlay = Overlay.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Consts.backGroundColor,
      appBar: AppBar(
        backgroundColor: Consts.appBarColor,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.sort,
                semanticLabel: 'sort',
                color: Consts.backGroundColor,
              ),
              onPressed: () => {
                    _orderEntry = _createOrderlyEntry(height),
                    _orderlay.insert(_orderEntry)
                  }),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              cursorColor: Consts.colorB,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              onChanged: (value) => _runSearch(value),
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: searchBy == false
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .snapshots(),
                    builder:
                        (ctx, AsyncSnapshot<QuerySnapshot> objectsSnapsshot) {
                      if (objectsSnapsshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      objectsSnapsshot.data!.docs
                          .map((DocumentSnapshot document) {
                        data = document.data()! as Map<String, dynamic>;
                      });

                      return ListView.builder(
                          reverse: false,
                          itemCount: data.length,
                          itemBuilder: (ctx, index) =>
                              SearchTileAcount(data[index]));
                    },
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('userPosts')
                        .snapshots(),
                    builder:
                        (ctx, AsyncSnapshot<QuerySnapshot> objectsSnapsshot) {
                      if (objectsSnapsshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      objectsSnapsshot.data!.docs
                          .map((DocumentSnapshot document) {
                        data = document.data()! as Map<String, dynamic>;
                      });

                      return ListView.builder(
                          reverse: false,
                          itemCount: data.length,
                          itemBuilder: (ctx, index) =>
                              SearchTilePost(data[index]));
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _runSearch(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        objects = '';
      });
    } else {
      setState(() {
        objects = enteredKeyword.toLowerCase();
      });
      // we use the toLowerCase() method to make it case-insensitive
    }
  }

  OverlayEntry _createOrderlyEntry(double height) {
    return OverlayEntry(
        maintainState: true,
        builder: (context) => Expanded(
              child: Container(
                padding: EdgeInsets.only(top: height / 1.5),
                child: Card(
                    color: Consts.backGroundColor,
                    elevation: 4.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context).searchBy,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                          title: Text(AppLocalizations.of(context).acount),
                          trailing: Checkbox(
                            checkColor: Consts.appBarColor,
                            value: acount,
                            onChanged: (value) {
                              _orderlay.setState(() {
                                acount = value!;
                                if (acount == true) {
                                  posts = false;
                                  searchBy = true;
                                  order = 'acount';
                                }
                                if (acount == false && posts == false) {
                                  acount = true;
                                  searchBy = true;
                                  order = 'acount';
                                }
                              });
                            },
                          )),
                      ListTile(
                          title: Text(AppLocalizations.of(context).posts),
                          trailing: Checkbox(
                            checkColor: Consts.appBarColor,
                            value: posts,
                            onChanged: (value) {
                              _orderlay.setState(() {
                                posts = value!;
                                if (posts == true) {
                                  acount = false;
                                  searchBy = false;
                                  order = 'posts';
                                }
                                if (acount == false && posts == false) {
                                  acount = true;
                                  searchBy = true;
                                  order = 'acount';
                                }
                              });
                            },
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      FloatingActionButton.extended(
                          onPressed: () {
                            setState(() {
                              _orderEntry.remove();
                            });
                          },
                          label: Text(
                            AppLocalizations.of(context).done,
                            style:
                                const TextStyle(color: Consts.backGroundColor),
                          ),
                          icon: const Icon(
                            Icons.thumb_up,
                            color: Colors.white,
                          ),
                          backgroundColor: Consts.appBarColor),
                    ])),
              ),
            ));
  }
}
