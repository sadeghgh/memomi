import 'package:flutter/material.dart';
import 'package:memomi/screen/favor_and_unfavor/favor_my_post_tile.dart';
import 'package:memomi/widgets/const.dart';

// ignore: must_be_immutable
class FavoritMyPost extends StatefulWidget {
  Map<String, dynamic> favorit;
  FavoritMyPost(this.favorit, {Key? key}) : super(key: key);

  @override
  State<FavoritMyPost> createState() => _FavoritMyPostState();
}

class _FavoritMyPostState extends State<FavoritMyPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Consts.appBar,
      body: SafeArea(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => FavorMyPostTile(widget.favorit)),
      ),
    );
  }
}
