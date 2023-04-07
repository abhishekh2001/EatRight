import 'package:eatright/models/user.dart';
import 'package:eatright/services/data/user_service.dart';

class Comment {
  late final MinUser user;
  late final String content;

  static Future<Comment> initFromFirebase(
    Map<String, dynamic> commentMap,
  ) async {
    final author = await getMinUserFromUid(commentMap['uid']);
    return Comment(author, commentMap['content']);
  }

  Comment(this.user, this.content);
}
