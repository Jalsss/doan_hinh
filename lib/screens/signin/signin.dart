import 'dart:convert';
import 'dart:io';

import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/notification/notification.config.dart';
import 'package:doan_hinh/screens/home/loading_screen.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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
    setState(() {
      loading = true;
    });
  }
  final facebookLogin = FacebookLogin();

  login(String route) async {
    setState(() {
      isLoading = true;
    });
    final result = await facebookLogin.logIn(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await get('https://graph.facebook.com/${result.accessToken.userId}?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
        if(graphResponse.statusCode == 200) {
          String appID = json.decode(graphResponse.body)["email"] != null ? json.decode(graphResponse.body)["email"] : json.decode(graphResponse.body)["id"];
          String appSystem = Platform.isAndroid ? "0" : "1";
          String data = "?mID=12&appID=" + appID +
            "&avatar=https://graph.facebook.com/" + result.accessToken.userId + "/picture?height=200"+
            "&hoVaTen=" +json.decode(graphResponse.body)["name"]+
            "&appSystem=" + appSystem;

          final res  = await get(Constant.apiAdress + '/api/mobile/fbAdd.asmx/fbAdd'+ data);
          if(res.statusCode == 200) {
            String dataFcm = "?mID=12&appID=" + appID + "&token=" + json.decode(res.body)['data'] + "&appSystem=" + appSystem;
            await get(Constant.apiAdress + '/api/mobile/game.asmx/fcmAdd' + dataFcm);
            _storage.writeValue('isSignIn', 'true');
            _storage.writeValue('appID', appID);
            Navigator.restorablePushReplacementNamed(context, route);
          } else {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return  MyDialog('Đã xảy ra lỗi, vui lòng thử lại sau');
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
        return showDialog(context: context, builder: (builder) { return AlertDialog(title :Text('Thông báo'),content: Text('Đăng nhập thất bại'));});

        break;
      case FacebookLoginStatus.error:
        setState(() {
          isLoading = false;
        });
        print(result.errorMessage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading? Scaffold(
      body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  'Đăng nhập',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: AppButton(
                                  'Đăng nhập bằng facebook',
                                  icon: Icon(Icons.ac_unit),
                                  onPressed: () => login(Routes.home),
                                  loading: isLoading,
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            )
    ): LoadingScreen();
  }
}
