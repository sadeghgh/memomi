import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memomi/auth/signup.dart';
import 'package:memomi/screen/main_screen.dart';
import 'package:memomi/widgets/custom_input_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/const.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void resetPassword() async {
    if (takeEmail.isEmpty) {
      Get.snackbar(AppLocalizations.of(context).warning,
          AppLocalizations.of(context).putYourEmailPlease);
    } else {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: takeEmail.trim());
      Get.snackbar(AppLocalizations.of(context).send,
          AppLocalizations.of(context).checkYourEmailPlease);
    }
  }

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

  Future<String?> logInMethod() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: takeEmail, password: takePassword);
      return AppLocalizations.of(context).ok;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        return AppLocalizations.of(context).noUserFoundForThatEmail;
      } else if (error.code == 'wrong-password') {
        return AppLocalizations.of(context).wrongPasswordProvidedForThatUser;
      }
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    String? result = await logInMethod();
    if (result != 'Ok') {
      advanceAlertDialog(result!);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Get.to(const MainScreen());
      Get.snackbar(AppLocalizations.of(context).successful,
          AppLocalizations.of(context).youAreLogined,
          //backgroundColor: Colors.greenAccent,
          icon: const Icon(Icons.check_circle),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  bool isLoading = false;
  String takeEmail = '';
  String takePassword = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Consts.appBar,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    AppLocalizations.of(context).welcomeToTheMeMoMi,
                    style: Consts.headingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: [
                    CustomInput(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        takeEmail = value;
                      },
                      checkPassword: false,
                      hinttext: AppLocalizations.of(context).email,
                      maxLength: 50,
                      maxLines: 1,
                    ),
                    CustomInputPassword(
                      onChanged: (value) {
                        takePassword = value;
                      },
                    ),
                    CustomButton(
                      text: AppLocalizations.of(context).login,
                      onTap: () {
                        login();
                      },
                      mode: false,
                      loading: isLoading,
                    ),
                    TextButton(
                        onPressed: resetPassword,
                        child: Text(
                          AppLocalizations.of(context).forgetPassword,
                          style: const TextStyle(color: Consts.appBarColor),
                        ))
                  ],
                ),
                CustomButton(
                  text: AppLocalizations.of(context).createNewAccont,
                  onTap: () => Get.to(() => const Signup()),
                  mode: true,
                  loading: false,
                )
              ],
            ),
          ),
        ));
  }
}
