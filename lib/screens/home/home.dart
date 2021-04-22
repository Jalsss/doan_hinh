import 'dart:convert';

import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/screens/gamesScreen/game_screen.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doan_hinh/widgets/app_button.dart';
import 'package:http/http.dart';

final _storage = new LocalStorage();

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  bool isLoading = false;

  _HomeState();

  @override
  void initState() {
    super.initState();
  }

  start(String routes) async {
    setState(() {
      isLoading = true;
    });
    var appID = await _storage.readValue('appID');
    String data = "?mID=12&appID=" + appID.toString();
    final res = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/gameImgAdd' + data);
    print(res.body);

    await Navigator.pushReplacementNamed(context, Routes.gameScreen);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
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
                              TextButton(
                                child: Image.asset(
                                  'assets/images/play-button.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
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
                                onPressed: () => {start(Routes.gameScreen)},
                              ),
                              Container(height: 20,),
                              TextButton(
                                child: Image.asset(
                                  'assets/images/huyhieu-button.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
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
                                onPressed: () => {start(Routes.gameScreen)},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: Image.asset(
                            'assets/images/gift-home.png',
                            width:
                            MediaQuery.of(context).size.width * 0.15,
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
                          onPressed: () => {start(Routes.gameScreen)},
                        ),
                        Container(width: MediaQuery.of(context).size.width * 0.59,),
                        TextButton(
                          child: Image.asset(
                            'assets/images/volum-home.png',
                            width:
                            MediaQuery.of(context).size.width * 0.15,
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
                          onPressed: () => {start(Routes.gameScreen)},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
