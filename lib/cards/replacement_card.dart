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
                  onPressed: () {},
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
                  onPressed: () {},
                  child: Text('${replacement.numComments} comments'),
                ),
              ],
            ),
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
