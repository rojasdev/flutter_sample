import 'package:flutter/material.dart';

void main() {
  runApp(LayoutDemo());
}

class LayoutDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Constraints & Layout Example')),
        body: Center(
          child: Container(
            width: 200,  // Parent sets constraints
            height: 200,
            color: Colors.blue[100],
            child: Column(
              children: [
                Container(
                  color: Colors.orange,
                  width: 100,  // Child chooses size within constraints
                  height: 50,
                  child: Center(child: Text('Child 1')),
                ),
                Container(
                  color: Colors.green,
                  width: double.infinity,  // Fills width within parent constraint
                  height: 50,
                  child: Center(child: Text('Child 2')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
