import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memomi/screen/home/home_list_tile.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String currentUserUid;
  HomePage(this.currentUserUid, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool leastLikes = false;
  bool mostCommments = false;
  bool mostLikes = true;
  String order = 'mostLikes';
  late OverlayEntry _orderEntry;
  late OverlayState _orderlay;
  List<String> friends = [];
  Map<String, dynamic> data = {};
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _orderlay = Overlay.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
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
            body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('userPosts')
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final objectDocs = snapshot.data!.docs;

                  if (order == 'mostLikes') {
                    objectDocs.sort((a, b) => double.parse(b["mostLikes"])
                        .compareTo(double.parse(a["mostLikes"])));
                  } else if (order == 'mostComments') {
                    objectDocs.sort((a, b) => double.parse(b["mostComments"])
                        .compareTo(double.parse(a["mostComments"])));
                  } else if (order == 'leastLikes') {
                    objectDocs.sort((a, b) => double.parse(b["leastLikes"])
                        .compareTo(double.parse(a["leastLikes"])));
                  }
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    data = document.data()! as Map<String, dynamic>;
                  });
                  return ListView.builder(
                    reverse: false,
                    itemCount: objectDocs.length,
                    itemBuilder: (ctx, index) =>
                        HomeListTile(data[index], friends),
                  );
                })));
  }

  OverlayEntry _createOrderlyEntry(double height) {
    return OverlayEntry(
        maintainState: true,
        builder: (context) => Expanded(
              child: Container(
                padding: EdgeInsets.only(top: height / 1.61),
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
                        AppLocalizations.of(context).sortBy,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Consts.backGroundColor),
                      ),
                      ListTile(
                          title: Text(AppLocalizations.of(context).mostLikes),
                          trailing: Checkbox(
                            checkColor: Consts.appBarColor,
                            value: mostLikes,
                            onChanged: (value) {
                              _orderlay.setState(() {
                                mostLikes = value!;
                                if (mostLikes == true) {
                                  mostCommments = false;
                                  leastLikes = false;
                                  order = 'mostLikes';
                                }
                                if (mostLikes == false &&
                                    mostCommments == false &&
                                    leastLikes == false) {
                                  mostLikes = true;
                                  order = 'mostLikes';
                                }
                              });
                            },
                          )),
                      ListTile(
                          title:
                              Text(AppLocalizations.of(context).mostComments),
                          trailing: Checkbox(
                            checkColor: Consts.appBarColor,
                            value: mostCommments,
                            onChanged: (value) {
                              _orderlay.setState(() {
                                mostCommments = value!;
                                if (mostCommments == true) {
                                  leastLikes = false;
                                  mostLikes = false;
                                  order = 'mostComments';
                                }
                                if (mostLikes == false &&
                                    mostCommments == false &&
                                    leastLikes == false) {
                                  mostLikes = true;
                                  order = 'mostLikes';
                                }
                              });
                            },
                          )),
                      ListTile(
                          title: Text(AppLocalizations.of(context).leastLikes),
                          trailing: Checkbox(
                            checkColor: Consts.appBarColor,
                            value: leastLikes,
                            onChanged: (value) {
                              _orderlay.setState(() {
                                leastLikes = value!;
                                if (leastLikes == true) {
                                  mostCommments = false;
                                  mostLikes = false;
                                  order = 'leastLikes';
                                }
                                if (mostLikes == false &&
                                    mostCommments == false &&
                                    leastLikes == false) {
                                  mostLikes = true;
                                  order = 'mostLikes';
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
                            color: Consts.backGroundColor,
                          ),
                          backgroundColor: Consts.appBarColor),
                    ])),
              ),
            ));
  }

  getMyfriends() async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(widget.currentUserUid)
        .collection('friends')
        .get()
        .then((snapshot) {
      for (var element in snapshot.docs) {
        String friend = element['userId'];
        friends.add(friend);
      }
    });
  }
}
