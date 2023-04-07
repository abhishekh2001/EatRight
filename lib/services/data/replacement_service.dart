import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatright/models/replacement.dart';
import 'dart:developer' as devtools show log;
import 'package:eatright/services/data/user_service.dart';

Future<void> createNewReplacement(Map<String, dynamic> m) async {
  final docRef = FirebaseFirestore.instance.collection('test').doc(m['id']);
  await docRef.set(m);
  await createCommit(m['uid'], m['id']);

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
  return [];
}
