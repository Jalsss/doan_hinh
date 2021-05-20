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

  login(String route) async {
    setState(() {
      isLoading = true;
    });
    final result = await facebookLogin.logIn(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await get(
            'https://graph.facebook.com/${result.accessToken.userId}?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
        if (graphResponse.statusCode == 200) {
          String appID = json.decode(graphResponse.body)["email"] != null
              ? json.decode(graphResponse.body)["email"]
              : json.decode(graphResponse.body)["id"];
          String appSystem = Platform.isAndroid ? "0" : "1";
          String data = "?mID=12&appID=" +
              appID +
              "&avatar=https://graph.facebook.com/" +
              result.accessToken.userId +
              "/picture?height=200" +
              "&hoVaTen=" +
              json.decode(graphResponse.body)["name"] +
              "&appSystem=" +
              appSystem;

          final res = await get(
              'http://api.keng.com.vn/api/mobile/fbAdd.asmx/fbAdd' + data);
          if (res.statusCode == 200) {
            String dataFcm = "?mID=12&appID=" +
                appID +
                "&token=" +
                json.decode(res.body)['data'] +
                "&appSystem=" +
                appSystem;
            await get(
                Constant.apiAdress + '/api/mobile/game.asmx/fcmAdd' + dataFcm);
            _storage.writeValue('isSignIn', 'true');
            _storage.writeValue('appID', appID);
            Navigator.restorablePushReplacementNamed(context, route);
          } else {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return MyDialog('Đã xảy ra lỗi, vui lòng thử lại sau');
              },
            );
          }

          setState(() {
            isLoading = false;
          });
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                  title: Text('Thông báo'),
                  content: Text('Đăng nhập thất bại'));
            });

        break;
      case FacebookLoginStatus.error:
        setState(() {
          isLoading = false;
        });
        print(result.errorMessage);
        break;
    }
  }

  loginWithApple(String route) async {
    setState(() {
      isLoading = true;
    });
    var credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } catch (Exception) {
      setState(() {
        isLoading = false;
      });
    }
    if (credential.userIdentifier != null) {
      String appSystem = Platform.isAndroid ? "0" : "1";
      String appID = credential.userIdentifier;
      String data = "?mID=12&appID=" +
          appID +
          "&avatar=''" +
          "&hoVaTen=" +
          credential.givenName +
          "&appSystem=" +
          appSystem;
      final res = await get(
          'http://api.keng.com.vn/api/mobile/fbAdd.asmx/fbAdd' + data);
      if (res.statusCode == 200) {
        String dataFcm = "?mID=12&appID=" +
            appID +
            "&token=" +
            json.decode(res.body)['data'] +
            "&appSystem=" +
            appSystem;
        await get(
            Constant.apiAdress + '/api/mobile/game.asmx/fcmAdd' + dataFcm);
        _storage.writeValue('isSignIn', 'true');
        _storage.writeValue('appID', appID);
        setState(() {
          isLoading = false;
        });
        Navigator.restorablePushReplacementNamed(context, route);
      } else {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog('Đã xảy ra lỗi, vui lòng thử lại sau');
          },
        );
      }

      setState(() {
        isLoading = false;
      });
      print(credential);
    } else {
      return showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
                title: Text('Thông báo'), content: Text('Đăng nhập thất bại'));
          });
    }
    // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
    // after they have been validated with Apple (see `Integration` section for more information on how to do this)
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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                          color: Colors.brown.shade800,
                                          fontSize: 50,
                                          fontFamily: 'Chalkboard SE',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextButton(
                                        child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: <Widget>[
                                              Image.asset(
                                                  'assets/images/login-fb.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  fit: BoxFit.fill),
                                              Center(
                                                  child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Ionicons
                                                                .logo_facebook,
                                                            color: HexColor
                                                                .fromHex(
                                                                    '#ffffff'),
                                                          ),
                                                          Text(
                                                              ' Đăng nhập Facebook',
                                                              style: TextStyle(
                                                                  color: HexColor
                                                                      .fromHex(
                                                                          '#ffffff'),
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Chalkboard SE')),
                                                        ],
                                                      ),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              6, 0, 6, 0))),
                                            ]),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        ),
                                        onPressed: () => {login(Routes.home)},
                                      )),
                                  Container(
                                    height: 70,
                                  ),
                                  !Platform.isAndroid
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: TextButton(
                                            child: Stack(
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                children: <Widget>[
                                                  Image.asset(
                                                      'assets/images/login-app.png',
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      fit: BoxFit.fill),
                                                  Center(
                                                      child: Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Ionicons
                                                                    .logo_apple,
                                                                color: HexColor
                                                                    .fromHex(
                                                                        '#501c07'),
                                                              ),
                                                              Text(
                                                                  ' Đăng nhập Apple',
                                                                  style: TextStyle(
                                                                      color: HexColor
                                                                          .fromHex(
                                                                              '#501c07'),
                                                                      fontSize:
                                                                          20,
                                                                      fontFamily:
                                                                          'Chalkboard SE')),
                                                            ],
                                                          ),
                                                          margin: EdgeInsets
                                                              .fromLTRB(6, 0, 6,
                                                                  10))),
                                                ]),
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                            ),
                                            onPressed: () =>
                                                {loginWithApple(Routes.home)},
                                          ))
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                    isLoading : isLoading)));
  }
}
