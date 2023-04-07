import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatright/constants/defaults.dart';
import 'package:eatright/models/user.dart';
import 'dart:developer' as devtools show log;

import 'package:uuid/uuid.dart';

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

  devtools.log('added userDetails ${docRef.path}, ${docRef.id}');
}

Future<MinUser> getMinUserFromUid(String? uid) async {
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

Future<void> createCommitOnRep(String uid, String repId) async {
  Map<String, dynamic> commitDetails = {
    'createdAt': FieldValue.serverTimestamp(),
    'uid': uid,
    'repId': repId,
  };

  final commitId = const Uuid().v4();
  final docRef = FirebaseFirestore.instance.collection('commits').doc(commitId);
  await docRef.set(commitDetails);
  devtools.log('added commit ${docRef.path}, ${docRef.id}');
}

Future<void> createCommentOnRep(
  String uid,
  String repId,
  String content,
) async {
  final commentData = {
    'uid': uid,
    'repId': repId,
    'content': content,
    'createAt': FieldValue.serverTimestamp(),
  };

  final commentRef = FirebaseFirestore.instance.collection('comments');
  await commentRef.add(commentData);

  // update number of comments by +1
  final repRef = FirebaseFirestore.instance.collection('test').doc(repId);
  final repSnap = await repRef.get();

  var d = repSnap.data();
  int? numComments = d == null ? null : d['numComments'];
  if (numComments != null) {
    await repRef.update({
      'numComments': numComments + 1,
    });
  } else {
    devtools.log('ERROR: NUMCOMMENTS IS NUL repId: $repId');
  }
}
