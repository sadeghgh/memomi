import 'package:flutter/material.dart';
import 'package:memomi/screen/favor_and_unfavor/un_favor_my_post_tile.dart';
import 'package:memomi/widgets/const.dart';

// ignore: must_be_immutable
class UnFavoritMyPost extends StatefulWidget {
  Map<String, dynamic> unFavorit;
  UnFavoritMyPost(this.unFavorit, {Key? key}) : super(key: key);

  @override
  State<UnFavoritMyPost> createState() => _UnFavoritMyPostState();
}

class _UnFavoritMyPostState extends State<UnFavoritMyPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Consts.appBar,
      body: SafeArea(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) =>
                UnFavorMyPostTile(widget.unFavorit)),
      ),
    );
  }
}
