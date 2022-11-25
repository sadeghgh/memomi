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
class SearchTileAcount extends StatefulWidget {
  Map<String, dynamic> data;
  SearchTileAcount(this.data, {Key? key}) : super(key: key);

  @override
  State<SearchTileAcount> createState() => _SearchTileAcountState();
}

class _SearchTileAcountState extends State<SearchTileAcount> {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  bool friend = true;
  String userName = '';
  String imageProfile = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    giveMyfriends(widget.data['ownerId']);
    giveProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(ShowScreen(widget.data));
        },
        child: Card(
          color: Consts.backGroundColor,
          elevation: 3,
          shadowColor: Colors.black38,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      Get.to(ShowOtherProfile(widget.data['ownerId']));
                    },
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Consts.appBarColor),
                      onPressed: () {
                        if (friend == false) {
                          FirebaseHelper.deleteFriends(
                              widget.data['ownerId'], currentUserUid);
                        } else {
                          Map<String, dynamic> setFriends = {
                            'username': userName,
                            'image_url': imageProfile,
                            'request': 'request',
                            'ownerId': currentUserUid,
                            'friendId': widget.data['ownerId']
                          };
                          Map<String, dynamic> setMe = {
                            'username': widget.data['userName'],
                            'image_url': widget.data['image_url'],
                            'request': 'req',
                            'ownerId': currentUserUid,
                            'friendId': widget.data['ownerId']
                          };
                          FirebaseHelper.setFriends(currentUserUid,
                              widget.data['ownerId'], setFriends, setMe);
                        }
                      },
                      child: friend == true
                          ? Text(AppLocalizations.of(context).friendRequest,
                              style: const TextStyle(
                                  color: Consts.backGroundColor))
                          : Text(AppLocalizations.of(context).remove,
                              style: const TextStyle(
                                  color: Consts.backGroundColor)))
                ],
              ),
            ],
          ),
        ));
  }

  giveProfiles() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        userName = data!['username'];
        imageProfile = data['image_url'];
      }
    });
  }

  giveMyfriends(String ownerId) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUserUid)
        .collection('friends')
        .doc(ownerId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? user =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (user!['request'] == 'yes') {
          setState(() {
            friend = false;
          });
        } else if (user['request'] == 'request' || user['request'] == 'req') {
          setState(() {
            friend = true;
          });
        }
      }
    });
  }
}
