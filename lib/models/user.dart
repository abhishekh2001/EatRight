import 'package:eatright/services/data/user_service.dart';
import 'dart:developer' as devtools show log;

class MinUser {
  final String uid;
  final String displayName;
  final String photoUrl;
  Set<String>? commits;

  MinUser(this.uid, this.displayName, this.photoUrl);
  MinUser.fromJson(Map<String, dynamic> m)
      : uid = m['uid'],
        displayName = m['displayName'],
        photoUrl = m['photoUrl'];

  Future<void> fillCommits() async {
    commits = await getAllRepCommitsByUser(uid);
    devtools.log('got ${commits?.length} commits');
  }
}
