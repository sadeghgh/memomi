import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/helper/firbase_helper.dart';
import 'package:memomi/screen/show_screen/show_screen.dart';
import 'package:memomi/widgets/const.dart';
import 'package:memomi/widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ShowOtherProfile extends StatefulWidget {
  String ownerId;
  ShowOtherProfile(this.ownerId, {Key? key}) : super(key: key);
  @override
  State<ShowOtherProfile> createState() => _ShowOtherProfileState();
}

class _ShowOtherProfileState extends State<ShowOtherProfile> {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;
  Map<String, dynamic> user = {};
  Map<String, dynamic> mustLike = {};
  int cunterMustLike = 0;
  Map<String, dynamic> mustDislike = {};
  int cunterMustDislike = 0;
  Map<String, dynamic> mustComment = {};
  int cunterComment = 0;
  int cunterFriends = 0;
  List<String> interests = [];
  String friendMode = '';
  String buttonText = '';
  Map<String, dynamic> friend = {};
  Map<String, dynamic> setFriends = {};
  Map<String, dynamic> setMe = {};
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUser();
    getMyFriends();
    getFriends();
    getMostLike();
    getMostDislike();
    getMostComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Consts.appBar,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
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
                child:
                    (user['image_url'] != null && user['image_url'].isNotEmpty)
                        ? Image.network(
                            user['image_url'],
                            fit: BoxFit.cover,
                            //width: 100,height: 100,
                          )
                        : Image.asset(
                            'assets/images/img.jpg',
                            fit: BoxFit.cover,
                          ),
              ),
            ),
            Center(child: Text(user['username'])),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                AppLocalizations.of(context).interests,
                style: Consts.textStyleOne,
              ),
            ),
            ListView.builder(
                itemCount: interests.length,
                itemBuilder: ((context, index) => Text(interests[index]))),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                AppLocalizations.of(context).numberofFriends +
                    cunterFriends.toString(),
                style: Consts.textStyleOne,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Get.to(ShowScreen(mustLike));
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
                Get.to(ShowScreen(mustDislike));
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
                Get.to(ShowScreen(mustComment));
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
            CustomButton(
                text: buttonText,
                onTap: () {
                  if (friendMode == 'yes') {
                    Get.defaultDialog(
                        title: AppLocalizations.of(context)
                            .doYouWantToEndYourFriendship,
                        backgroundColor: Consts.backGroundColor,
                        textCancel: AppLocalizations.of(context).cancel,
                        onCancel: () {
                          //
                        },
                        textConfirm: AppLocalizations.of(context).confirm,
                        onConfirm: () {
                          deleteFriendsship();
                        },
                        buttonColor: Consts.appBarColor);
                  } else if (friendMode == 'req') {
                    Get.defaultDialog(
                        title: AppLocalizations.of(context)
                            .doYouWantToCancelYourFriendRequest,
                        backgroundColor: Consts.backGroundColor,
                        textCancel: AppLocalizations.of(context).cancel,
                        onCancel: () {
                          //
                        },
                        textConfirm: AppLocalizations.of(context).confirm,
                        onConfirm: () {
                          deleteFriendsship();
                        },
                        buttonColor: Consts.appBarColor);
                  } else {
                    Get.defaultDialog(
                        title: AppLocalizations.of(context)
                            .doYouWantToSendaFriendRequest,
                        backgroundColor: Consts.backGroundColor,
                        textCancel: AppLocalizations.of(context).cancel,
                        onCancel: () {
                          //
                        },
                        textConfirm: AppLocalizations.of(context).confirm,
                        onConfirm: () {
                          requestFriendsship();
                        },
                        buttonColor: Consts.appBarColor);
                  }
                },
                mode: false,
                loading: isLoading)
          ],
        ),
      ),
    );
  }

  getUser() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.ownerId)
        .get()
        .then((snapshot) {
      setState(() {
        user = snapshot.data()!;
        interests = user['select_Interests'];
        setMe = {
          'username': user['userName'],
          'image_url': user['image_url'],
          'request': 'req',
          'ownerId': currentUserUid,
          'friendId': widget.ownerId
        };
      });
    });
  }

  getFriends() async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(widget.ownerId)
        .get()
        .then((snapshot) {
      setState(() {
        cunterFriends = snapshot.data()!.length;
      });
    });
  }

  getMostLike() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.ownerId)
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
        .doc(widget.ownerId)
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
        .doc(widget.ownerId)
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

  getMyFriends() async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUserUid)
        .collection('friends')
        .doc(widget.ownerId)
        .get()
        .then((snapshot) {
      setState(() {
        if (snapshot.exists) {
          friend = snapshot.data()!;
          friendMode = friend['request'];
          if (friendMode == 'yes') {
            buttonText = AppLocalizations.of(context).remove;
          } else if (friendMode == 'req' || friendMode == 'request') {
            buttonText = AppLocalizations.of(context).cancelRequest;
          }
        } else {
          friendMode = 'not';
          buttonText = AppLocalizations.of(context).friendRequest;
        }
      });
    });
  }

  deleteFriendsship() async {
    setState(() {
      isLoading = true;
    });
    String ok =
        await FirebaseHelper.deleteFriends(widget.ownerId, currentUserUid);
    if (ok == "ok") {
      setState(() {
        isLoading = false;
        buttonText = AppLocalizations.of(context).friendRequest;
      });
      Get.snackbar(AppLocalizations.of(context).successful,
          AppLocalizations.of(context).friendshipCanceled,
          icon: const Icon(Icons.check_circle),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(AppLocalizations.of(context).warning,
          AppLocalizations.of(context).friendshipWasNotCanceled,
          icon: const Icon(Icons.warning), snackPosition: SnackPosition.BOTTOM);
    }
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
        String userName = data!['username'];
        String imageProfile = data['image_url'];
        setFriends = {
          'username': userName,
          'image_url': imageProfile,
          'request': 'request',
          'ownerId': currentUserUid,
          'friendId': widget.ownerId
        };
      }
    });
  }

  requestFriendsship() async {
    setState(() {
      isLoading = true;
    });
    String ok = await FirebaseHelper.setFriends(
        currentUserUid, widget.ownerId, setFriends, setMe);
    if (ok == "ok") {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(AppLocalizations.of(context).successful,
          AppLocalizations.of(context).theRequestWasSent,
          icon: const Icon(Icons.check_circle),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      setState(() {
        isLoading = false;
        buttonText = AppLocalizations.of(context).cancelRequest;
      });
      Get.snackbar(AppLocalizations.of(context).warning,
          AppLocalizations.of(context).theRequestWasNotSent,
          icon: const Icon(Icons.warning), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
