import 'dart:io';

import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginDialog extends StatefulWidget {
  final Function() loginFacebook;
  final Function() loginApple;

  LoginDialog({Key key, this.loginFacebook, this.loginApple}) : super(key: key);

  @override
  _LoginDialogState createState() {
    return _LoginDialogState();
  }
}

class _LoginDialogState extends State<LoginDialog> {
  bool loading = true;

  loginWithApple() {
    setState(() {
      loading = true;
    });
    var loginAp = widget.loginApple();
    loginAp();

    setState(() {
      loading = false;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  login() {
    setState(() {
      loading = false;
    });
    var loginFb = widget.loginFacebook();
    loginFb();
    setState(() {
      loading = true;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  closeDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            //title: Center(child: Text('Gợi ý'),),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              Image.asset('assets/images/box-2.png',
                  height: 300,
                  width: MediaQuery.of(context).size.width * 0.95,
                  fit: BoxFit.fill),
              Container(
                  width: MediaQuery.of(context).size.width * 0.95,
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
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                    padding: MaterialStateProperty.resolveWith(
                                        (states) =>
                                            EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                    shadowColor: MaterialStateColor.resolveWith(
                                        (states) => Colors.transparent),
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent)),
                                onPressed: () => {closeDialog()},
                              )),
                        ]),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                                'Vui lòng đăng nhập để thực hiện chức năng này',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.brown.shade800,
                                    fontSize: 20,
                                    fontFamily: 'Chalkboard SE',
                                    fontWeight: FontWeight.bold))),
                        Container(
                          height: 30,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextButton(
                              child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/login-fb.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        fit: BoxFit.fill),
                                    Center(
                                        child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Ionicons.logo_facebook,
                                                  color: HexColor.fromHex(
                                                      '#ffffff'),
                                                ),
                                                Text(' Đăng nhập Facebook',
                                                    style: TextStyle(
                                                        color: HexColor.fromHex(
                                                            '#ffffff'),
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'Chalkboard SE')),
                                              ],
                                            ),
                                            margin: EdgeInsets.fromLTRB(
                                                6, 0, 6, 0))),
                                  ]),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              ),
                              onPressed: () => {login()},
                            )),
                        Container(
                          height: 30,
                        ),
                        !Platform.isAndroid
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextButton(
                                  child: Stack(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      children: <Widget>[
                                        Image.asset(
                                            'assets/images/login-app.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            fit: BoxFit.fill),
                                        Center(
                                            child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Ionicons.logo_apple,
                                                      color: HexColor.fromHex(
                                                          '#501c07'),
                                                    ),
                                                    Text(' Đăng nhập Apple',
                                                        style: TextStyle(
                                                            color: HexColor
                                                                .fromHex(
                                                                    '#501c07'),
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Chalkboard SE')),
                                                  ],
                                                ),
                                                margin: EdgeInsets.fromLTRB(
                                                    6, 0, 6, 10))),
                                      ]),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  ),
                                  onPressed: () => {loginWithApple()},
                                ))
                            : Container(),
                      ]))
            ]))
        : Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()]));
  }
}
