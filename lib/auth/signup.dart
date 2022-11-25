import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:memomi/helper/interests.dart';
import 'package:memomi/widgets/custom_input_password.dart';
import '../widgets/const.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import 'login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:filter_list/filter_list.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Future<void> advanceAlertDialog(String message) {
    return Get.defaultDialog(
        title: AppLocalizations.of(context).invalidInput,
        content: Text(message),
        actions: [
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Consts.appBarColor),
              onPressed: () => Get.back(),
              child: Text(AppLocalizations.of(context).ok,
                  style: const TextStyle(color: Consts.backGroundColor)))
        ],
        contentPadding: const EdgeInsets.all(15));
  }

  Future<String?> signInMethod() async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: takeEmail, password: takePassword);
      final ref = FirebaseStorage.instance
          .ref()
          .child('acounts_image')
          .child(authResult.user!.uid)
          .child(authResult.user!.uid + '-logo.jpg');

      await ref.putFile(File(image!.path));

      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(authResult.user!.uid)
          .set({
        'username': username,
        'email': takeEmail,
        'image_url': url,
        'phone': phoneNr,
        'token': token,
        'gender': selectGender,
        'select_Interests': selectInterests,
        'birth_Date': birthDate,
        'ownerId': authResult.user!.uid,
        'startTime': Timestamp.fromDate(DateTime.now()),
      });
      return 'Ok';
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        return 'The password is too weak';
      } else if (error.code == 'email-already-in-use') {
        return 'The account with this email is already exsist !';
      }
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    String? result = await signInMethod();
    if (result != 'Ok') {
      advanceAlertDialog(result!);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Get.to(const LoginPage());
      Get.snackbar(AppLocalizations.of(context).successful,
          AppLocalizations.of(context).createNewAccont,
          icon: const Icon(Icons.check_circle),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  final ImagePicker imagePicker = ImagePicker();
  bool visibil = false;
  bool isLoading = false;
  String takeEmail = '';
  String username = '';
  String takePassword = '';
  String takeRipPassword = '';
  PickedFile? image;
  List<MyInterests>? selectedUserList = [];
  List gender = ["Male", "Female", "Other"];
  List<String> selectInterests = [];
  String selectGender = '';
  var phoneNr = '';
  String token = '';
  DateTime birthDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Consts.backGroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      AppLocalizations.of(context).editAccount,
                      style: Consts.headingTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      Column(
                        children: <Widget>[
                          Visibility(
                            visible: visibil,
                            child: image != null
                                ? CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey,
                                    // ignore: unnecessary_null_comparison

                                    backgroundImage:
                                        FileImage(File(image!.path)),
                                  )
                                : const SizedBox(),
                          ),
                          TextButton.icon(
                            // textColor: Theme.of(context).primaryColor,
                            onPressed: _pickImage,
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
                        ],
                      ),
                      CustomInput(
                        keyboardType: TextInputType.text,
                        checkPassword: false,
                        onChanged: (value) {
                          username = value;
                        },
                        hinttext: AppLocalizations.of(context).username,
                        maxLength: 20,
                        maxLines: 1,
                      ),
                      CustomInput(
                        keyboardType: TextInputType.emailAddress,
                        checkPassword: false,
                        onChanged: (value) {
                          takeEmail = value;
                        },
                        hinttext: AppLocalizations.of(context).email,
                        maxLength: 50,
                        maxLines: 1,
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
                      CustomInputPassword(
                        onChanged: (value) {
                          takePassword = value;
                        },
                      ),
                      CustomInputPassword(
                        onChanged: (value) {
                          takeRipPassword = value;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        decoration: BoxDecoration(
                            color: Consts.backGroundColor,
                            borderRadius: BorderRadius.circular(13)),
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 5),
                            border: InputBorder.none,
                            labelText: AppLocalizations.of(context).phoneNr,
                            // border: OutlineInputBorder(
                            //   borderSide: BorderSide(),
                            // ),
                          ),
                          //initialCountryCode: 'TR',
                          onChanged: (value) {
                            phoneNr = value.completeNumber;
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                              AppLocalizations.of(context)
                                  .pleaseSelectYourDateOfBirth,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "${birthDate.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      getWidget(true, true),
                      //Divider(),
                      CustomButton(
                        text: AppLocalizations.of(context).createNewAccount,
                        onTap: () {
                          final today = DateTime.now();
                          final eighteenY = DateTime(
                              today.year - 18, today.month, today.day + 1);
                          if (birthDate.isBefore(eighteenY) == true) {
                            signIn();
                          } else {
                            Get.snackbar(
                                AppLocalizations.of(context).warning,
                                AppLocalizations.of(context)
                                    .youArenot18YearsOld);
                          }
                        },
                        mode: false,
                        loading: isLoading,
                      )
                    ],
                  ),
                  CustomButton(
                    text: AppLocalizations.of(context).backToLogin,
                    onTap: () => Get.back(),
                    mode: true,
                    loading: isLoading,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate, // Refer step 1
      firstDate: DateTime(1945),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      errorFormatText: AppLocalizations.of(context).enterValidDate,
      errorInvalidText: AppLocalizations.of(context).enterdateinvalidrange,
      fieldLabelText: AppLocalizations.of(context).bookingdate,
      fieldHintText: AppLocalizations.of(context).monthDateYear,
    );
    if (picked != null && picked != birthDate)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        birthDate = picked;
      });
  }

  Widget getWidget(bool showOtherGender, bool alignVertical) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: GenderPickerWithImage(
        showOtherGender: showOtherGender,
        verticalAlignedText: alignVertical,

        // to show what's selected on app opens, but by default it's Male
        selectedGender: Gender.Male,
        selectedGenderTextStyle: const TextStyle(
            color: Consts.appBarColor, fontWeight: FontWeight.bold),
        unSelectedGenderTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        maleText: AppLocalizations.of(context).male,
        femaleText: AppLocalizations.of(context).female,
        otherGenderText: AppLocalizations.of(context).other,
        onChanged: (Gender? gender) {
          if (gender == Gender.Male) {
            selectGender = 'Male';
          } else if (gender == Gender.Female) {
            selectGender = 'Female';
          } else if (gender == Gender.Others) {
            selectGender = 'Others';
          }
        },
        //Alignment between icons
        equallyAligned: true,

        animationDuration: const Duration(milliseconds: 300),
        isCircular: true,
        // default : true,
        opacityOfGradient: 0.4,
        padding: const EdgeInsets.all(3),
        size: 50, //default : 40
      ),
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
      selectedListData: selectedUserList,
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
          selectedUserList = List.from(list!);

          int conter = List.from(list).length;
          for (int i = 0; i < conter; i++) {
            if (selectedUserList![i].interests ==
                AppLocalizations.of(context).animals) {
              selectInterests.add('Animals');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).playingaMusicalInstrument) {
              selectInterests.add('Playing a musical instrument');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).reading) {
              selectInterests.add('Reading');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).writing) {
              selectInterests.add('Writing');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).sketching) {
              selectInterests.add('Sketching');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).photography) {
              selectInterests.add('Photography');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).design) {
              selectInterests.add('Design');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).painting) {
              selectInterests.add('Painting');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).games) {
              selectInterests.add('Games');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).languages) {
              selectInterests.add('Languages');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).sport) {
              selectInterests.add('Sport');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).programming) {
              selectInterests.add('Programming');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).universe) {
              selectInterests.add('Universe');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).sex) {
              selectInterests.add('Sex');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).family) {
              selectInterests.add('Family');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).friends) {
              selectInterests.add('Friends');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).religion) {
              selectInterests.add('Religion');
            } else if (selectedUserList![i].interests ==
                AppLocalizations.of(context).philosophy) {
              selectInterests.add('Philosophy');
            }
          }
        });
        Navigator.pop(context);
      },
    );
  }

  getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    token = (await messaging.getToken())!;
  }

  void _pickImage() async {
    // ignore: deprecated_member_use
    final pickedImageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );
    if (pickedImageFile != null) {
      setState(() {
        image = pickedImageFile;
        visibil = true;
      });
    }
  }
}
