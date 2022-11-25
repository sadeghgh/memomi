import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/show_screen/show_screen_my_post.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class MyPostListTile extends StatefulWidget {
  Map<String, dynamic> data;
  MyPostListTile(this.data, {Key? key}) : super(key: key);

  @override
  State<MyPostListTile> createState() => _MyPostListTileState();
}

class _MyPostListTileState extends State<MyPostListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(ShowScreenMyPost(widget.data));
        },
        child: Card(
          color: Consts.backGroundColor,
          elevation: 3,
          shadowColor: Colors.black38,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin:
                        const EdgeInsets.only(right: 15, bottom: 5, left: 5),
                    child: (widget.data['image_urls'] != null &&
                            widget.data['image_urls'].isNotEmpty)
                        ? Image.network(
                            widget.data['image_urls'][0],
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 100.0,
                          )
                        : Image.asset(
                            'assets/images/img.jpg',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['subject'] != null
                              ? (widget.data['subject'])
                              : AppLocalizations.of(context).notadded,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.data['story'] != null
                              ? (widget.data['story'].length > 25
                                  ? widget.data['story'].substring(0, 22) +
                                      '...'
                                  : widget.data['story'])
                              : AppLocalizations.of(context).notadded,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.black54,
                      ),
                      Text(widget.data['countUnFavorit'])
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.comment,
                        color: Colors.black54,
                      ),
                      Text(widget.data['countComment'])
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                      Text(widget.data['countFavorit'])
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
