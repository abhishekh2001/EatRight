import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatright/models/comment.dart';
import 'package:eatright/models/replacement.dart';
import 'package:eatright/models/user.dart';
import 'dart:developer' as devtools show log;
import 'package:eatright/services/data/user_service.dart';

Future<void> createNewReplacement(Map<String, dynamic> m) async {
  final docRef = FirebaseFirestore.instance.collection('test').doc(m['id']);
  await docRef.set(m);
  await createCommitOnRep(m['uid'], m['id']);

  devtools.log('added replacement ${docRef.path}, ${docRef.id}');
}

Future<Replacement> getReplacementFromId(String id) async {
  final docRef = FirebaseFirestore.instance.collection('test').doc(id);
  final docSnap = await docRef.get();
  final data = docSnap.data();

  if (data != null) {
    final rep = Replacement.fromJson(data);
    await rep.loadAuthor();
    return rep;
  }

  throw Exception('data not found');
}

Future<List<Replacement>> getAllReplacementsRec() async {
  var dayInMillis = Duration(days: 1).inMilliseconds;
  final querySnap = await FirebaseFirestore.instance
      .collection('test')
      .orderBy('numCommits', descending: true)
      .get();
  List<Replacement> res = [];
  for (final doc in querySnap.docs) {
    var rep = Replacement.fromJson(doc.data());
    await rep.loadAuthor();
    res.add(rep);
  }
  devtools.log('loaded ${res.length} replacements');
  return res;
}

Future<List<MinUser>> getAllUserCommitsForRep(String repId) async {
  final userSnap = await FirebaseFirestore.instance
      .collection('commits')
      .where('repId', isEqualTo: repId)
      .get();

  List<MinUser> res = [];
  for (var doc in userSnap.docs) {
    res.add(MinUser.fromJson(doc.data()));
  }

  return res;
}

Future<List<Comment>> getAllCommentsOnRep(String repId) async {
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  final commentsSnap = await commentsRef.where('repId', isEqualTo: repId).get();
  final docsList = commentsSnap.docs;

  List<Comment> res = [];
  for (var docSnap in docsList) {
    var commentMap = docSnap.data();
    var comment = await Comment.initFromFirebase(commentMap);
    res.add(comment);
  }

  return res;
}
