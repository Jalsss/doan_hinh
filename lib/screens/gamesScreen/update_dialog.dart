
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_appstore/open_appstore.dart';

import '../../main.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool backgroundMusic = true;
  bool talkMusic = true;
  var value = null;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Thông báo'),
        content: Text(
            'Đã có phiên bản cập nhật mới. Vui lòng cập nhật trước khi tiếp tục!'),
        actions: [
          TextButton(
              onPressed: () {
                OpenAppstore.launch(
                    androidAppId: linkup,
                    iOSAppId: linkup);
              },
              child: Text('Cập nhật'))
        ]);
  }
}