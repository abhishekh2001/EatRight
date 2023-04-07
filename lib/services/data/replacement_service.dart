import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as devtools show log;

import 'package:eatright/services/data/user_service.dart';

Future<void> createNewReplacement(Map<String, dynamic> m) async {
  final docRef = FirebaseFirestore.instance.collection('test').doc(m['id']);
  await docRef.set(m);
  await createCommit(m['uid'], m['id']);

  devtools.log('added replacement ${docRef.path}, ${docRef.id}');
}
