import 'package:flutter/material.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/show_screen/show_other_profile.dart';

// ignore: must_be_immutable
class CommentsListTile extends StatefulWidget {
  Map<String, dynamic> data;
  CommentsListTile(this.data, {Key? key}) : super(key: key);

  @override
  State<CommentsListTile> createState() => _CommentsListTileState();
}

class _CommentsListTileState extends State<CommentsListTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Consts.backGroundColor,
          elevation: 3,
          shadowColor: Consts.appBarColor,
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(
                            top: 5.0, bottom: 5.0, left: 5.0),
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
                          Get.to(ShowOtherProfile(widget.data['userId']));
                        },
                      ),
                    ],
                  ),
                  Text(widget.data['comment'] != null
                      ? (widget.data['comment'])
                      : AppLocalizations.of(context).notadded)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
