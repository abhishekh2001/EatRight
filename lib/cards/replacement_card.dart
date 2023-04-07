import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatright/models/comment.dart';
import 'package:eatright/models/replacement.dart';
import 'package:eatright/services/auth/auth_service.dart';
import 'package:eatright/services/data/replacement_service.dart';
import 'package:eatright/services/data/user_service.dart';
import 'dart:developer' as devtools show log;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ReplacementCard extends StatefulWidget {
  final Replacement replacement;
  final Function(List<Comment>) onTap;
  const ReplacementCard({
    super.key,
    required this.replacement,
    required this.onTap,
  });

  @override
  State<ReplacementCard> createState() => _ReplacementCardState();
}

class _ReplacementCardState extends State<ReplacementCard> {
  bool _isCommentInputVisible = false;
  final _commentController = TextEditingController();
  late Replacement replacement;

  @override
  void initState() {
    super.initState();
    replacement = widget.replacement;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<Replacement> _updateCurrentRepState() async {
    final updatedRep = await getReplacementFromId(replacement.id);
    devtools
        .log('updating rep state... numComments: ${updatedRep.numComments}');
    return updatedRep;
  }

  Future<void> _retrieveAndPushCommentToOnTap() async {
    final comments = await getAllCommentsOnRep(replacement.id);
    widget.onTap(comments);
  }

  Future<void> _submitComment() async {
    final String content = _commentController.text;
    final String? uid = AuthService.firebase().currentUser?.uid;

    if (uid != null) {
      await createCommentOnRep(
        uid,
        replacement.id,
        content,
      );
    }
    Replacement updatedRep = await _updateCurrentRepState();
    setState(() {
      _isCommentInputVisible = false;
      replacement = updatedRep;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                    replacement.author.photoUrl,
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  replacement.author.displayName,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            ),
            const SizedBox(height: 17.0),
            Row(
              children: [
                ProductMinDisplay(
                  product: replacement.oldProduct as Map<String, dynamic>,
                  isOld: true,
                ),
                const Icon(Icons.arrow_right),
                ProductMinDisplay(
                  product: replacement.newProduct as Map<String, dynamic>,
                  isOld: false,
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isCommentInputVisible = true;
                    });
                  },
                  child: const Text('Comment'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Commit!'),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('${replacement.numCommits} commits'),
                ),
                const SizedBox(width: 25),
                TextButton(
                  onPressed: _retrieveAndPushCommentToOnTap,
                  child: Text('${replacement.numComments} comments'),
                ),
              ],
            ),
            if (_isCommentInputVisible)
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Enter some text',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        // cancel button
                        onPressed: () {
                          setState(() {
                            _isCommentInputVisible = false;
                          });
                        },
                        icon: const Icon(Icons.cancel_rounded),
                      ),
                      IconButton(
                        // submit button
                        onPressed: _submitComment,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ProductMinDisplay extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isOld;

  const ProductMinDisplay(
      {super.key, required this.product, required this.isOld});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Image.network(
                product['productImageUrl'],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product['productName']),
                Icon(isOld ? Icons.cancel : Icons.check)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
