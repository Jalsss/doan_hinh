import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  MyDialog(@required this.content);
  String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Thông báo'),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'))
        ]);
  }
}