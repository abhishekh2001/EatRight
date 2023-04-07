import 'package:eatright/models/user.dart';
import 'package:eatright/services/data/user_service.dart';

class Comment {
  late final MinUser user;
  late final String content;

  static Future<Comment> initFromFirebase(String uid, String content) async {
    final author = await getMinUserFromUid(uid);
    return Comment(author, content);
  }

  Comment(this.user, this.content);
}
