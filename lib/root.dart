import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memomi/auth/login.dart';
import 'package:memomi/screen/main_screen.dart';
import 'package:memomi/widgets/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Root extends StatelessWidget {
  final Future<FirebaseApp> firebasetest = Firebase.initializeApp();

  Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebasetest,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
                child: Text(
              AppLocalizations.of(context).firebaseIsNotConnected,
              style: Consts.textStyleOne,
            )),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('${streamSnapshot.error}')),
                );
              }
              if (streamSnapshot.connectionState == ConnectionState.active) {
                User? user = streamSnapshot.data as User?;
                if (user == null) {
                  return const LoginPage();
                } else {
                  return const MainScreen();
                }
              }
              return const CircularProgressIndicator();
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
