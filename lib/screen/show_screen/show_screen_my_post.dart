import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memomi/screen/comment/comments.dart';
import 'package:memomi/screen/favor_and_unfavor/favor_my_post.dart';
import 'package:memomi/screen/favor_and_unfavor/un_favor_my_post.dart';
import 'package:memomi/widgets/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ShowScreenMyPost extends StatefulWidget {
  Map<String, dynamic> data;
  ShowScreenMyPost(this.data, {Key? key}) : super(key: key);

  @override
  State<ShowScreenMyPost> createState() => _ShowScreenMyPostState();
}

class _ShowScreenMyPostState extends State<ShowScreenMyPost> {
  int intFav = 0;
  int intUnFav = 0;
  int intComment = 0;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    intUnFav = int.parse(widget.data['countUnFavorit']);
    intFav = int.parse(widget.data['countFavorit']);
    intComment = int.parse(widget.data['countComment']);
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: Consts.appBar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: widget.data['image_urls'].length,
                itemBuilder: ((context, index, realIndex) =>
                    (widget.data['image_urls'] != null &&
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
                          )),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  widget.data['subject'] != null
                      ? (widget.data['subject'])
                      : AppLocalizations.of(context).notadded,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                itemCount: widget.data['select_Interests'].length,
                itemBuilder: (context, index) => Text(
                  widget.data[index],
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 10),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                child: Text(
                  widget.data['story'] != null
                      ? (widget.data['story'])
                      : AppLocalizations.of(context).notadded,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        color: Colors.black54,
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          setState(() {
                            if (intUnFav > 0) {
                              Get.to(UnFavoritMyPost(widget.data['unFavorit']));
                            }
                          });
                        },
                      ),
                      Text(intUnFav.toString())
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.black54),
                        onPressed: () {
                          if (intComment > 0) {
                            Get.to(Comments(widget.data));
                          }
                        },
                      ),
                      Text(intComment.toString())
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.red),
                        onPressed: () {
                          setState(() {
                            if (intFav > 0) {
                              Get.to(FavoritMyPost(widget.data['favorit']));
                            }
                          });
                        },
                      ),
                      Text(intFav.toString())
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
