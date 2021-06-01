import 'dart:convert';
import 'dart:io';

import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:doan_hinh/notification/notification.config.dart';
import 'package:doan_hinh/screens/home/loading_screen.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _storage = new LocalStorage();
var client = http.Client();

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  final facebookLogin = FacebookLogin();



  playNow(String route) async{
    setState(() {
      isLoading = true;
    });
          String appSystem = Platform.isAndroid ? "0" : "1";
          String data = "?mID=12&appID=''" +
              "&avatar=''" +
              "&hoVaTen=Guests" +
              "&appSystem=" +
              appSystem;

          final res = await get(
              'http://api.keng.com.vn/api/mobile/fbAdd.asmx/fbAdd' + data);
          if (res.statusCode == 200) {
            String appID = json.decode(res.body)['data'];
            String dataFcm = "?mID=12&appID=" +
                json.decode(res.body)['data'] +
                "&token=" +
                json.decode(res.body)['data'] +
                "&appSystem=" +
                appSystem;
            await get(
                Constant.apiAdress + '/api/mobile/game.asmx/fcmAdd' + dataFcm);
            _storage.writeValue('isSignIn', 'true');
            _storage.writeValue('appID', appID);
            _storage.writeValue('token', json.decode(res.body)['data']);
            Navigator.restorablePushReplacementNamed(context, route);


          setState(() {
            isLoading = false;
          });
        }

  }
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-home.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: LoadingOverlay(
                    child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        Center(
                          widthFactor: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/images/bien.png',
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child:
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextButton(
                                        child: Stack(
                                            alignment:
                                            AlignmentDirectional.center,
                                            children: <Widget>[
                                              Image.asset(
                                                  'assets/images/ketqua.png',
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.7,
                                                  fit: BoxFit.fill),
                                              Center(
                                                  child: Container(
                                                      child:
                                                          Text(
                                                              ' Chơi ngay',
                                                              style: TextStyle(
                                                                  color: HexColor
                                                                      .fromHex(
                                                                      '#ffffff'),
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                  'Chalkboard SE')),
                                                      margin:
                                                      EdgeInsets.fromLTRB(
                                                          6, 0, 6, 0))),
                                            ]),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        ),
                                        onPressed: () => {playNow(Routes.home)},
                                      ))

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                    isLoading : isLoading)));
  }
}
