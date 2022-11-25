import 'dart:io';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:memomi/helper/firbase_helper.dart';
import 'package:memomi/helper/interests.dart';
import 'package:memomi/helper/my_friends_interests.dart';
import 'package:memomi/widgets/const.dart';
import 'package:memomi/widgets/custom_button.dart';
import 'package:memomi/widgets/custom_input.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  //List<XFile>? imagefiles;
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final configs = ImagePickerConfigs();
  final formKey = GlobalKey<FormState>();
  bool visibil = false;
  int val = 1;
  bool isLoading = false;
  List<MyFriends>? selectedUserList = [];
  List<MyInterests>? selectedItems = [];
  List<String> selectInterests = [];
  List<ImageObject> _imgObjs = [];
  String subject = '';
  String story = '';
  List showMode = [];
  String userName = '';
  String imageProfile = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    configs.appBarTextColor = Consts.backGroundColor;
    configs.appBarBackgroundColor = Consts.appBarColor;
    //////////
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'external_image_editor_1',
        icon: Icons.edit_rounded,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'external_image_editor_2',
        icon: Icons.edit_attributes,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
        DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75)
      ];
    };
    configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return 'Cloud dummy ocr text';
      } else {
        return 'Dummy ocr text';
      }
    };
    // Example about custom stickers
    configs.customStickerOnly = true;
    configs.customStickers = [
      'assets/icon/cus1.png',
      'assets/icon/cus2.png',
      'assets/icon/cus3.png',
      'assets/icon/cus4.png',
      'assets/icon/cus5.png'
    ];
    /////////
    configs.translateFunc = (name, value) => Intl.message(value, name: name);

    return Scaffold(
      backgroundColor: Consts.backGroundColor,
      appBar: Consts.appBar,
      body: SafeArea(
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInput(
                    hinttext: AppLocalizations.of(context).subject,
                    onChanged: (value) {
                      subject = value;
                    },
                    checkPassword: false,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 50,
                  ),
                  Column(
                    children: [
                      TextButton.icon(
                        // textColor: Theme.of(context).primaryColor,
                        onPressed: () async {
                          // Get max 5 images
                          final List<ImageObject>? objects =
                              await Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation, __) {
                            return const ImagePicker(maxCount: 5);
                          }));

                          if ((objects?.length ?? 0) > 0) {
                            setState(() {
                              _imgObjs = objects!;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Consts.appBarColor,
                        ),
                        label: Text(
                          AppLocalizations.of(context).addImage,
                          style: const TextStyle(
                            color: Consts.appBarColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imgObjs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(
                                File(_imgObjs[index].modifiedPath),
                                fit: BoxFit.cover,
                                width: Get.width / 5.5,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: _openFilterDialog,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Consts.backGroundColor, width: 2),
                          borderRadius: BorderRadius.circular(13),
                          color: Consts.appBarColor),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 25,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).yourInterests,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Consts.backGroundColor),
                        ),
                      ),
                    ),
                  ),
                  CustomInput(
                      hinttext: AppLocalizations.of(context).yourStory,
                      onChanged: (value) {
                        story = value;
                      },
                      checkPassword: false,
                      keyboardType: TextInputType.multiline,
                      maxLength: 3000,
                      maxLines: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context).showForAll),
                        leading: Radio(
                            activeColor: Consts.appBarColor,
                            value: 1,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                if (value == 1) {
                                  val = 1;
                                  showMode.clear();
                                  showMode.add('showForAll');
                                }
                              });
                            }),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context).showJustForMe),
                        leading: Radio(
                            activeColor: Consts.appBarColor,
                            value: 2,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                if (value == 2) {
                                  val = 2;
                                  showMode.clear();
                                  showMode.add('showJustForMe');
                                }
                              });
                            }),
                      ),
                      ListTile(
                        title:
                            Text(AppLocalizations.of(context).showForMyFriends),
                        leading: Radio(
                            activeColor: Consts.appBarColor,
                            value: 3,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                if (value == 3) {
                                  val = 3;
                                  showMode.clear();
                                  showMode.add('showForMyFriends');
                                }
                              });
                            }),
                      ),
                      ListTile(
                        title:
                            Text(AppLocalizations.of(context).showFor + ' ...'),
                        leading: Radio(
                            activeColor: Consts.appBarColor,
                            value: 4,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                if (value == 4) {
                                  val = 4;
                                  openFilterDelegate();
                                  //showMode.clear();
                                  //showMode.add('showJustForMe');
                                }
                              });
                            }),
                      ),
                    ],
                  ),
                  CustomButton(
                      text: AppLocalizations.of(context).send,
                      onTap: () {
                        if (story != '') {
                          _trySubmit();
                        } else {
                          Get.snackbar(
                              AppLocalizations.of(context).warning,
                              AppLocalizations.of(context)
                                  .pleaseWriteYourStory);
                        }
                      },
                      mode: false,
                      loading: isLoading)
                ],
              ),
            )),
      ),
    );
  }

  Future<void> openFilterDelegate() async {
    await FilterListDelegate.show<MyFriends>(
      context: context,
      list: userList,
      selectedListData: selectedUserList,
      theme: FilterListDelegateThemeData(
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Consts.backGroundColor,
          selectedColor: Consts.appBarColor,
          selectedTileColor: Consts.appBarColor.withOpacity(.5),
          textColor: Consts.appBarColor,
        ),
      ),
      // enableOnlySingleSelection: true,
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      //tileLabel: (user) => user!.name,
      emptySearchChild: const Center(child: Text('No user found')),
      searchFieldHint: 'search',
      suggestionBuilder: (context, user, isSelected) {
        return ListTile(
          title: Text(user.name!),
          leading: CircleAvatar(
            //backgroundColor: Colors.blue,
            child: Image.asset(
              user.avatar!,
              fit: BoxFit.cover,
            ),
          ),
          selectedColor: Consts.appBarColor,
          selectedTileColor: Consts.backGroundColor,
          selected: isSelected,
        );
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = list;
          showMode.clear();
          showMode.add(selectedUserList);
        });
      },
    );
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<MyInterests>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: AppLocalizations.of(context).selectInterests,
      height: 500,
      listData: [
        MyInterests(interests: AppLocalizations.of(context).animals),
        MyInterests(
            interests: AppLocalizations.of(context).playingaMusicalInstrument),
        MyInterests(interests: AppLocalizations.of(context).reading),
        MyInterests(interests: AppLocalizations.of(context).writing),
        MyInterests(interests: AppLocalizations.of(context).sketching),
        MyInterests(interests: AppLocalizations.of(context).photography),
        MyInterests(interests: AppLocalizations.of(context).design),
        MyInterests(interests: AppLocalizations.of(context).painting),
        MyInterests(interests: AppLocalizations.of(context).games),
        MyInterests(interests: AppLocalizations.of(context).languages),
        MyInterests(interests: AppLocalizations.of(context).sport),
        MyInterests(interests: AppLocalizations.of(context).programming),
        MyInterests(interests: AppLocalizations.of(context).universe),
        MyInterests(interests: AppLocalizations.of(context).sex),
        MyInterests(interests: AppLocalizations.of(context).family),
        MyInterests(interests: AppLocalizations.of(context).friends),
        MyInterests(interests: AppLocalizations.of(context).religion),
        MyInterests(interests: AppLocalizations.of(context).philosophy)
      ],
      selectedListData: selectedItems,
      choiceChipLabel: (item) => item!.interests,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ContolButtonType.All, ContolButtonType.Reset],
      applyButtonText: AppLocalizations.of(context).apply,
      allButtonText: AppLocalizations.of(context).all,
      resetButtonText: AppLocalizations.of(context).reset,
      selectedItemsText: AppLocalizations.of(context).selectedItems,
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.interests!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedItems = List.from(list!);

          int conter = List.from(list).length;
          for (int i = 0; i < conter; i++) {
            if (selectedItems![i].interests ==
                AppLocalizations.of(context).animals) {
              selectInterests.add('Animals');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).playingaMusicalInstrument) {
              selectInterests.add('Playing a musical instrument');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).reading) {
              selectInterests.add('Reading');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).writing) {
              selectInterests.add('Writing');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).sketching) {
              selectInterests.add('Sketching');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).photography) {
              selectInterests.add('Photography');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).design) {
              selectInterests.add('Design');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).painting) {
              selectInterests.add('Painting');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).games) {
              selectInterests.add('Games');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).languages) {
              selectInterests.add('Languages');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).sport) {
              selectInterests.add('Sport');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).programming) {
              selectInterests.add('Programming');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).universe) {
              selectInterests.add('Universe');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).sex) {
              selectInterests.add('Sex');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).family) {
              selectInterests.add('Family');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).friends) {
              selectInterests.add('Friends');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).religion) {
              selectInterests.add('Religion');
            } else if (selectedItems![i].interests ==
                AppLocalizations.of(context).philosophy) {
              selectInterests.add('Philosophy');
            }
          }
        });
        Navigator.pop(context);
      },
    );
  }

  void _trySubmit() async {
    String postId = const Uuid().v4();
    Map<String, dynamic> objectData = {
      'subject': subject,
      'postId': postId,
      'ownerId': currentUserUid,
      'userName': userName,
      'imageProfile': imageProfile,
      'select_Interests': selectInterests,
      'story': story,
      'showMode': showMode,
      'favorit': {},
      'unFavorit': {},
      'countFavorit': '0',
      'countUnFavorit': '0',
      'countComment': '0',
      'date': Timestamp.fromDate(DateTime.now()),
    };
    setState(() {
      isLoading = true;
    });
    String firestoreRef = await FirebaseHelper.addPost(
        currentUserUid, postId, objectData, _imgObjs);
    if (firestoreRef == postId) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(AppLocalizations.of(context).successful,
          AppLocalizations.of(context).newPostCreated,
          icon: const Icon(Icons.check_circle),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(AppLocalizations.of(context).warning,
          AppLocalizations.of(context).noNewPostWasCreated,
          icon: const Icon(Icons.warning), snackPosition: SnackPosition.BOTTOM);
    }
  }

  getUserName() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? user;
        user = documentSnapshot.data() as Map<String, dynamic>?;
        userName = user!['username'];
        imageProfile = user['image_url'];
      }
    });
  }

  getFriends() {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUserUid)
        .collection('friends')
        .get()
        .then((snapshot) {
      // cunterFriends = snapshot.data()!.length;
      for (var element in snapshot.docs) {
        if (element['request'] == 'yes') {
          setState(() {
            // ignore: unused_local_variable
            List<MyFriends> userList = [
              MyFriends(name: element['name'], avatar: element['d'])
            ];
          });
        }
      }
    });
  }
}
