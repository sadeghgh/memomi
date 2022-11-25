import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/show_screen/show_other_profile.dart';
import 'package:memomi/widgets/const.dart';

// ignore: must_be_immutable
class UnFavorMyPostTile extends StatefulWidget {
  Map<String, dynamic> unFavorit;
  UnFavorMyPostTile(this.unFavorit, {Key? key}) : super(key: key);

  @override
  State<UnFavorMyPostTile> createState() => _UnFavorMyPostTileState();
}

class _UnFavorMyPostTileState extends State<UnFavorMyPostTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                child: (widget.unFavorit['imageProfile'] != null &&
                        widget.unFavorit['imageProfile'].isNotEmpty)
                    ? Image.network(
                        widget.unFavorit['imageProfile'],
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
                  widget.unFavorit['userName'],
                  style: const TextStyle(color: Consts.appBarColor),
                ),
                onPressed: () {
                  Get.to(ShowOtherProfile(widget.unFavorit['ownerId']));
                },
              ),
              const Icon(
                Icons.favorite_border,
                color: Colors.black,
              )
            ],
          ),
        ],
      ),
    );
  }
}
