import 'dart:convert';

import 'package:doan_hinh/configs/media.dart';
import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

var client = http.Client();
class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    super.initState();
  }
  final facebookLogin = FacebookLogin();

  login() async {
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await get('https://graph.facebook.com/${result.accessToken.userId}?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');

        break;
      case FacebookLoginStatus.cancelledByUser:
        return AlertDialog(title :Text('Thông báo'),content: Text('Đăng nhập thất bại'));
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  onPressed: () => login(),
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
    );
  }
}
