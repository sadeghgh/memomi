import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyFriends {
  final String? name;
  final String? avatar;
  final String? id;
  MyFriends({this.name, this.avatar, this.id});
}

List<MyFriends> userList = [];
getData() {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance
      .collection('friends')
      .doc(currentUserUid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Map<String, dynamic>? user;
      user = documentSnapshot.data() as Map<String, dynamic>?;
      if (user!['request'] == 'yes') {
        userList = [
          MyFriends(
              name: user['userName'],
              avatar: user['image_url'],
              id: user['friendId'])
        ];
      }
    }
  });
}
