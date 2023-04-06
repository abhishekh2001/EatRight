import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatright/constants/defaults.dart';
import 'package:eatright/models/user.dart';
import 'dart:developer' as devtools show log;
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserDetails({
  required String uid,
  required String displayName,
  String? photoUrl,
}) async {
  final userDetails = <String, dynamic>{
    "uid": uid,
    "displayName": displayName,
  };

  if (photoUrl != null) {
    userDetails["photoUrl"] = photoUrl;
  }

  final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
  await docRef.set(userDetails);

  devtools.log('added ${docRef.path}, ${docRef.id}');
}

Future<MinUser> getMinUserFromUid({
  String? uid,
}) async {
  if (uid != null) {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    final docSnapshot = await userRef.get();

    if (docSnapshot.exists) {
      final userData = docSnapshot.data();
      if (userData != null) return MinUser.fromJson(userData);
    }
  }

  return MinUser('-', 'Anon', defaultProfileUrl);
}
