import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageFileToStorage(File image) async {
  String downloadURL;
  String postId = const Uuid().v4();
  Reference ref = FirebaseStorage.instance
      .ref()
      .child("profile_image")
      .child("post_$postId.jpg");
  await ref.putFile(image);
  downloadURL = await ref.getDownloadURL();
  return downloadURL;
}
