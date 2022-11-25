import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static Future<String> addPost(String currentUserId, String postId,
      Map<String, dynamic> data, List objectImages) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(currentUserId)
        .collection('userPosts')
        .doc(postId)
        .set(data);
    addImagesToPost(objectImages, postId, currentUserId);
    return postId;
  }

  static Future addImagesToPost(
      List images, String id, String currentUserId) async {
    var urls = <dynamic>[];
    for (final element in images) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('post_images')
          .child("posts")
          .child(id)
          .child(
              id + DateTime.now().microsecondsSinceEpoch.toString() + '.jpg');
      await ref.putFile(element);

      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(currentUserId)
        .collection('userPosts')
        .doc(id)
        .update({
      'image_urls': urls,
    });
  }

  static Future<String> addComment(
      String postId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(postId)
        .collection('comments')
        .add(data);
    return 'ok';
  }

  static Future<void> counterComment(
      String postId, String currentUserId, counter) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(currentUserId)
        .collection('userPosts')
        .doc(postId)
        .update({
      'countComment': counter,
    });
  }

  static Future<String> typeNotification(
      String currentUserId, String postId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('feed')
        .doc(currentUserId)
        .collection('feedItems')
        .doc(postId)
        .set(data);
    return 'ok';
  }

  static Future<void> updateNotification(
      String currentUserId, String postId) async {
    await FirebaseFirestore.instance
        .collection('feed')
        .doc(currentUserId)
        .collection('feedItems')
        .doc(postId)
        .update({'seen': '1'});
  }

  static Future<String> setFriends(
      String currentUserId,
      String currentMyFriendId,
      Map<String, dynamic> setFriends,
      Map<String, dynamic> setMe) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUserId)
        .collection('friends')
        .doc(currentMyFriendId)
        .set(setFriends);

    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentMyFriendId)
        .collection('friends')
        .doc(currentUserId)
        .set(setMe);
    return 'ok';
  }

  static Future<String> acceptFriends(
      String currentUserId, String currentMyFriendId) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUserId)
        .collection('friends')
        .doc(currentMyFriendId)
        .update({'request': 'yes'});

    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentMyFriendId)
        .collection('friends')
        .doc(currentUserId)
        .update({'request': 'yes'});
    return 'ok';
  }

  static Future<String> deleteFriends(
      String currentMyFriendId, String currentUserId) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUserId)
        .collection('friends')
        .doc(currentMyFriendId)
        .delete();
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(currentMyFriendId)
        .collection('friends')
        .doc(currentUserId)
        .delete();
    return 'ok';
  }
}
