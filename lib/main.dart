import 'dart:convert';
import 'dart:io';

import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/screens/gamesScreen/game_screen.dart';
import 'package:doan_hinh/screens/signin/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'api/api.dart';
import 'constant/ad_state.dart';

import 'app.dart';

String bannerAdUnitId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/6300978111'
    : 'ca-app-pub-3940256099942544/2934735716';
var version = Platform.isAndroid ? '1.2' : '1.0';
bool isVersion = true;
var linkup = '';
void main() {
  GestureBinding.instance?.resamplingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  check().then((intenet) async {
    if (intenet != null && intenet) {
      var res = await get(Constant.apiAdress + '/api/mobile/game.asmx/portalGet?mID=12');
      if (res.statusCode == 200) {
        // bannerAdUnitId = Platform.isAndroid
        //     ? json.decode(res.body)['data']['a_BieuNgu']
        //     : json.decode(res.body)['data']['i_BieuNgu'];
        var dataVs = Platform.isAndroid
            ? json.decode(res.body)['data']['a_Version']
            : json.decode(res.body)['data']['i_Version'];
        linkup =
        Platform.isAndroid ? json.decode(res.body)['data']['a_LinkUp'] : json
            .decode(res.body)['data']['i_LinkUp'];
        if (version != dataVs) {
          isVersion = false;
        }
      }
      await Firebase.initializeApp();
      runApp(Provider.value(
        value: adState,
        builder: (context, child) => App(),
      ));
    } else {
      runApp(Provider.value(
        value: adState,
        builder: (context, child) => App(),
      ));
    }
  });
}

