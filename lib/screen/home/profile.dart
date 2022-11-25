import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memomi/root.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:memomi/auth/edit_profile_screen.dart';
import 'package:memomi/screen/home/profile_list.dart';
import 'package:memomi/screen/posts/my_post.dart';
import 'package:memomi/screen/requests_and_frinds/friends.dart';
import 'package:memomi/screen/requests_and_frinds/request_from_you.dart';
import 'package:memomi/screen/requests_and_frinds/your_requests.dart';
import 'package:memomi/screen/save_post/save_page.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  String currentUserUid;

  ProfileScreen(this.currentUserUid, {Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  Map<String, dynamic>? user;
  int counterPost = 0;
  int counterFreinds = 0;
  int counterRequests = 0;
  int counterMyRequests = 0;
  String version = '';
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    giveVersionNumber();
    giveProfiles();
    giveMyPosts();
    giveMyfriends();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Consts.appBarColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Consts.appBarColor,
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    color: Consts.backGroundColor,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: ProfileList(widget.currentUserUid),
      ),
      drawer: SafeArea(
        child: SizedBox(
          child: ListTileTheme(
            textColor: Consts.backGroundColor,
            iconColor: Consts.backGroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                  child: (user!['image_url'] != null &&
                          user!['image_url'].isNotEmpty)
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
                ListTile(
                  onTap: () {
                    Get.to(EditProfileScreen(widget.currentUserUid, user!));
                  },
                  leading: const Icon(
                    Icons.account_circle_rounded,
                    color: Consts.backGroundColor,
                  ),
                  title: Text(
                    AppLocalizations.of(context).editProfile,
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(MyPost(widget.currentUserUid));
                  },
                  leading:
                      const Icon(Icons.post_add, color: Consts.backGroundColor),
                  title: Text(
                    AppLocalizations.of(context).posts,
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                  subtitle: Text(
                    counterPost.toString(),
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(Friends(widget.currentUserUid));
                  },
                  leading:
                      const Icon(Icons.person, color: Consts.backGroundColor),
                  title: Text(
                    AppLocalizations.of(context).friends,
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                  subtitle: Text(
                    counterFreinds.toString(),
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(YourRequests(widget.currentUserUid));
                  },
                  leading: const Icon(Icons.outbond_outlined,
                      color: Consts.backGroundColor),
                  title: Text(
                    AppLocalizations.of(context).yourRequests,
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                  subtitle: Text(
                    counterRequests.toString(),
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(RequestFromYou(widget.currentUserUid));
                  },
                  leading: const Icon(Icons.close_fullscreen,
                      color: Consts.backGroundColor),
                  title: Text(
                    AppLocalizations.of(context).requestFromYou,
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                  subtitle: Text(
                    counterMyRequests.toString(),
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(SavePage(widget.currentUserUid));
                  },
                  leading:
                      const Icon(Icons.save_alt, color: Consts.backGroundColor),
                  title: Text(
                    AppLocalizations.of(context).saved,
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Get.off(Root());
                  },
                  leading:
                      const Icon(Icons.logout, color: Consts.backGroundColor),
                  title: Text(
                    AppLocalizations.of(context).signOut,
                    style: const TextStyle(color: Consts.backGroundColor),
                  ),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 12, color: Consts.backGroundColor),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 56.0,
                    ),
                    child: Text(AppLocalizations.of(context).version + version),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  giveVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
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
        } else if (element['request'] == 'request') {
          setState(() {
            counterRequests++;
          });
        } else if (element['request'] == 'req') {
          setState(() {
            counterMyRequests++;
          });
        }
      }
    });
  }
}
