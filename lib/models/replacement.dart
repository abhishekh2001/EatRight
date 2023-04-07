import 'package:eatright/models/user.dart';
import 'package:uuid/uuid.dart';

class Replacement {
  String id;
  late MinUser author;
  Map<String, String?> oldProduct;
  Map<String, String?> newProduct;
  int numCommits;
  int numComments;

  List comments;
  List commits;

  Replacement(
    this.author,
    this.oldProduct,
    this.newProduct,
    this.numCommits,
    this.numComments,
  )   : id = const Uuid().v4(),
        comments = [],
        commits = [];

  Replacement.fromJson(Map<String, dynamic> m)
      : id = m['id'],
        oldProduct = m['oldProduct'],
        newProduct = m['newProduct'],
        numCommits = m['numCommits'],
        numComments = m['numComments'],
        comments = [],
        commits = [];

  Future<void> loadComments() async {}
  Future<void> loadCommits() async {}

  Future<void> addAndPushComment() async {}
  Future<void> addAndPushCommit() async {}

  Future<void> pushToFirestore() async {}
}
