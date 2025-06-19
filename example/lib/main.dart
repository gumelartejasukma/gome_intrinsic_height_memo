import 'package:flutter/material.dart';
import 'package:gome_intrinsic_height_memo/gome_intrinsic_height_memo.dart';

void main() {
  runApp(const MaterialApp(home: ExamplePage()));
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IntrinsicHeightMemo Example')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return IntrinsicHeightMemo(
            index: index,
            child: Card(
              color: Colors.primaries[index % Colors.primaries.length],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Item ke-$index\n' * (index + 1)),
              ),
            ),
          );
        },
      ),
    );
  }
}
