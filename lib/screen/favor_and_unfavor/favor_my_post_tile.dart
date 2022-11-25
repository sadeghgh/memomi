import 'package:flutter/material.dart';
import 'package:memomi/widgets/const.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/show_screen/show_other_profile.dart';

// ignore: must_be_immutable
class FavorMyPostTile extends StatefulWidget {
  Map<String, dynamic> favorit;
  FavorMyPostTile(this.favorit, {Key? key}) : super(key: key);

  @override
  State<FavorMyPostTile> createState() => _FavorMyPostTileState();
}

class _FavorMyPostTileState extends State<FavorMyPostTile> {
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
                child: (widget.favorit['imageProfile'] != null &&
                        widget.favorit['imageProfile'].isNotEmpty)
                    ? Image.network(
                        widget.favorit['imageProfile'],
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
                  widget.favorit['userName'],
                  style: const TextStyle(color: Consts.appBarColor),
                ),
                onPressed: () {
                  Get.to(ShowOtherProfile(widget.favorit['ownerId']));
                },
              ),
              const Icon(
                Icons.favorite,
                color: Colors.red,
              )
            ],
          ),
        ],
      ),
    );
  }
}
