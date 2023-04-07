import 'package:eatright/models/replacement.dart';
import 'package:flutter/material.dart';

class ReplacementCard extends StatelessWidget {
  final Replacement replacement;

  const ReplacementCard({super.key, required this.replacement});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    child: Text('test 1'),
                  ),
                ),
              ),
              const Icon(Icons.arrow_right),
              Expanded(
                child: Center(
                  child: Container(
                    child: Text('test 2'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
