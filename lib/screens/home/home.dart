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
    final res = await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgAdd' + data);
    print(res.body);

    await Navigator.pushReplacementNamed(context, Routes.gameScreen);
    setState(() {
      isLoading = false;
    });
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
                              padding: EdgeInsets.all(24),
                              child: AppButton(
                                'Bắt đầu',
                                icon: Icon(Icons.ac_unit),
                                onPressed: () => {
                                  start(Routes.gameScreen)
                                },
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
    );
  }
}

