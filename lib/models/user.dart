class MinUser {
  final String uid;
  final String displayName;
  final String photoUrl;

  MinUser(this.uid, this.displayName, this.photoUrl);
  MinUser.fromJson(Map<String, dynamic> m)
      : uid = m['uid'],
        displayName = m['displayName'],
        photoUrl = m['photoUrl'];
}
