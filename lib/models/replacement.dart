import 'package:eatright/models/user.dart';
import 'package:eatright/services/data/user_service.dart';
import 'package:uuid/uuid.dart';

class Replacement {
  String id;
  String uid;
  late MinUser author;
  Map<String, dynamic>? oldProduct;
  Map<String, dynamic>? newProduct;
  int numCommits;
  int numComments;

  List comments;
  List commits;

  Replacement(
    this.uid,
    this.author,
    this.oldProduct,
    this.newProduct,
    this.numCommits,
    this.numComments,
  )   : id = const Uuid().v4(),
        comments = [],
        commits = [];

  Replacement.fromJson(Map<String, dynamic?> m)
      : id = m['id'],
        uid = m['uid'],
        oldProduct = m['oldProduct'],
        newProduct = m['newProduct'],
        numCommits = m['numCommits'],
        numComments = m['numComments'],
        comments = [],
        commits = [];

  Future<void> loadAuthor() async {
    author = await getMinUserFromUid(uid);
  }

  Future<void> loadComments() async {}
  Future<void> loadCommits() async {}

  Future<void> addAndPushComment() async {}
  Future<void> addAndPushCommit() async {}
}
