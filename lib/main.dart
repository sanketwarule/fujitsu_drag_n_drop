import 'package:flutter/material.dart';
import 'package:fujitsu_drag_n_drop/fujitsu_drag_n_drop_board.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fujitsu Drag and Drop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Fujitsu Drag and Drop"),),
        body: FujitsuDragNDropBoard(),),
    );
  }
}