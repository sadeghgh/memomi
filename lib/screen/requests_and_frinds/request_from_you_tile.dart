import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/helper/firbase_helper.dart';
import 'package:memomi/screen/show_screen/show_other_profile.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class RequestFromYouListTile extends StatefulWidget {
  Map<String, dynamic> data;
  RequestFromYouListTile(this.data, {Key? key}) : super(key: key);

  @override
  State<RequestFromYouListTile> createState() => _RequestFromYouListTileState();
}

class _RequestFromYouListTileState extends State<RequestFromYouListTile> {
  @override
  Widget build(BuildContext context) {
    return widget.data['request'] == 'request'
        ? myCard()
        : Container(
            height: 0,
          );
  }

  myCard() {
    Card(
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
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: (widget.data['image_url'] != null &&
                        widget.data['image_url'].isNotEmpty)
                    ? Image.network(
                        widget.data['image_url'],
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
                  widget.data['username'],
                  style: const TextStyle(color: Consts.appBarColor),
                ),
                onPressed: () {
                  Get.to(ShowOtherProfile(widget.data['friendId']));
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Consts.appBarColor),
                  onPressed: () async {
                    String ok = await FirebaseHelper.acceptFriends(
                        widget.data['ownerId'], widget.data['friendId']);
                    if (ok == 'ok') {
                      Get.snackbar(AppLocalizations.of(context).successful,
                          AppLocalizations.of(context).newPostCreated,
                          icon: const Icon(Icons.check_circle),
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      Get.snackbar(AppLocalizations.of(context).warning,
                          AppLocalizations.of(context).noNewPostWasCreated,
                          icon: const Icon(Icons.warning),
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: Text(AppLocalizations.of(context).accept,
                      style: const TextStyle(color: Consts.backGroundColor))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Consts.appBarColor),
                  onPressed: () async {
                    String ok = await FirebaseHelper.deleteFriends(
                        widget.data['friendId'], widget.data['ownerId']);
                    if (ok == "ok") {
                      Get.snackbar(AppLocalizations.of(context).successful,
                          AppLocalizations.of(context).friendshipCanceled,
                          icon: const Icon(Icons.check_circle),
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      Get.snackbar(AppLocalizations.of(context).warning,
                          AppLocalizations.of(context).friendshipWasNotCanceled,
                          icon: const Icon(Icons.warning),
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: Text(AppLocalizations.of(context).remove,
                      style: const TextStyle(color: Consts.backGroundColor))),
            ],
          ),
        ],
      ),
    );
  }
}
