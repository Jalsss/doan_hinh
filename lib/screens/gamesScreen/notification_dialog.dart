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
    String assetArmorial = widget.content == 'Kim cương' ? 'assets/images/huyhieu_kimcuong.png' : (widget.content == 'Vàng' ? 'assets/images/huyhieu_vang.png': 'assets/images/huyhieu_bac.png');

    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        //title: Center(child: Text('Gợi ý'),),
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Image.asset('assets/images/box-2.png',
              height: 350,
              width: MediaQuery.of(context).size.width * 0.92,
              fit: BoxFit.fill),
          Container(
            height: 460,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.topRight, children: <Widget>[
                    Stack(alignment: Alignment.topCenter, children: <Widget>[
                      Image.asset('assets/images/ribbon-popup.png',
                          fit: BoxFit.fill),
                      Text('Gợi ý',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Chalkboard SE',
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ]),
                    SizedBox(
                        width: 40,
                        child: TextButton(
                          child: Image.asset('assets/images/close-popup.png',
                            width: 40,),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor
                                  .resolveWith((states) =>
                              Colors.transparent),
                              padding: MaterialStateProperty.resolveWith((
                                  states) => EdgeInsets.fromLTRB(0, 0, 0, 0)),
                              shadowColor: MaterialStateColor.resolveWith((
                                  states) => Colors.transparent),
                              overlayColor: MaterialStateColor.resolveWith((
                                  states) => Colors.transparent)
                          ),
                          onPressed: () =>
                          {
                            closeDialog()
                          },
                        )),
                  ]),
                  Text(
                        'Chúc mừng bạn được nâng cấp lên huy hiệu',
                    style: TextStyle(
                      fontFamily: 'Chalkboard SE',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HexColor.fromHex('#832400'),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(widget.content,
                    style: TextStyle(
                    fontFamily: 'Chalkboard SE',
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: HexColor.fromHex('#d61817'),
                  )),
                  Container(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Image.asset(assetArmorial),)
                ]),
          )
        ]));
  }
}
