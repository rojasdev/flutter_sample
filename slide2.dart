import 'package:flutter/material.dart';

void main() {
  runApp(LayoutDemo());
}

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Constraints & Layout Example')),
        body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // aligns children at top
        crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
        children: [
          Container(
            //width: 200,
            height: 300,
            color: Colors.blue[100],
            child: Column(
                children: [
                  // First child
                  Container(
                    color: Colors.orange,
                    width: 100,
                    height: 50,
                    child: Center(child: Text('Child 1')),
                  ),
                  // Second child
                  Container(
                    color: Colors.green,
                    width: double.infinity,
                    height: 50,
                    child: Center(child: Text('Child 2')),
                  ),
                  // Third child: Row with 3 elements
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
