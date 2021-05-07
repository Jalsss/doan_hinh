import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatefulWidget {
  final Function() closeDialog;
  final String content;

  NotificationDialog({Key key, this.closeDialog, this.content})
      : super(key: key);

  @override
  _NotificationDialog createState() {
    return _NotificationDialog();
  }
}

class _NotificationDialog extends State<NotificationDialog> {

  closeDialog() {
    var closeDialog = widget.closeDialog;
    closeDialog();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        //title: Center(child: Text('Gợi ý'),),
        content: Stack(alignment: Alignment.center, children: <Widget>[
          Image.asset('assets/images/box-2.png',
              height: 300,
              width: MediaQuery.of(context).size.width * 1,
              fit: BoxFit.fill),
          Container(
            height: 360,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.topRight, children: <Widget>[
                    Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[Container()]),
                    SizedBox(
                        width: 30,
                        child: TextButton(
                          child: Image.asset(
                            'assets/images/close-popup.png',
                            width: 40,
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              padding: MaterialStateProperty.resolveWith(
                                  (states) => EdgeInsets.fromLTRB(0, 0, 0, 0)),
                              shadowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent)),
                          onPressed: () => {closeDialog()},
                        )),
                  ]),
                  Container(
                    height: 30,
                  ),
                  Text(
                        'Chúc mừng bạn đã nhận được huy hiệu '+ widget.content + '!',
                    style: TextStyle(
                      fontFamily: 'Chalkboard SE',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: HexColor.fromHex('#832400'),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 30,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: TextButton(
                        child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset('assets/images/chiase.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  fit: BoxFit.fill),
                              Center(
                                  child: Container(
                                      child: Text('OK',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              fontFamily: 'Chalkboard SE')),
                                      margin: EdgeInsets.fromLTRB(6, 0, 6, 0))),
                            ]),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        ),
                        onPressed: () => {closeDialog()},
                      )),
                ]),
          )
        ]));
  }
}
