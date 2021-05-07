import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:doan_hinh/api/api.dart';
import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/constant/ad_state.dart';
import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/screens/gamesScreen/achievements_dialog.dart';
import 'package:doan_hinh/screens/gamesScreen/armorial_dialog.dart';
import 'package:doan_hinh/screens/gamesScreen/game_screen.dart';
import 'package:doan_hinh/screens/gamesScreen/reward_dialog.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

final _storage = new LocalStorage();

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeScreen createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<Home> {
  bool isLoading = false;
  AudioCache audioCache = AudioCache();
  AudioPlayer player = new AudioPlayer();
  bool onAudio = true;

  _HomeScreen();

  List<Achievements> achievements = [];
  List<Achievements> achievementsDiamond = [];
  List<Achievements> achievementsGold = [];
  List<Achievements> achievementsSilver = [];
  AdListener listener;
  var appIDState;
  RewardedAd myRewarded;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
    }
    checkIsOnAudio();
    listener = AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        ad.dispose();
        ad.load();
        print('Ad closed.');
      },
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) => print('Left application.'),
      // Called when a RewardedAd triggers a reward.
      onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) async {
        print('reward');
        String data = '?mID=12&appID=' + appIDState;
        await get(
            Constant.apiAdress + '/api/mobile/game.asmx/gameImgQC' + data);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    check().then((intenet) async {
      if (intenet != null && intenet) {
        adState.initialization.then((status) {
          setState(() {
            myRewarded = RewardedAd(
              adUnitId: 'ca-app-pub-3940256099942544/1712485313',
              request: AdRequest(),
              listener: listener,
            )..load();
          });
        });
      }
    });
  }

  checkIsOnAudio() async {
    var appID = await _storage.readValue('appID');
    setState(() {
      appIDState = appID;
    });
    var _onAudio = await _storage.readValue('backgroundMusic');
    if (_onAudio == null) {
      setState(() {
        onAudio = true;
      });
      _storage.writeValue('backgroundMusic', this.onAudio.toString());
    } else {
      setState(() {
        _onAudio == "true" ? onAudio = true : onAudio = false;
      });
    }
    String getRewardDiamond = "?mID=12&iCup=3";
    final res = await get(Constant.apiAdress +
        '/api/mobile/game.asmx/gameHuyHieu' +
        getRewardDiamond);
    List<Achievements> listDiamond = [];
    if (res.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        listDiamond.add(Achievements(
            element['appLogo'].toString(),
            element['appName'].toString(),
            element['isLevel'].toString(),
            element['adPoint'].toString(),
            3));
      });
      setState(() {
        achievementsDiamond = listDiamond;
      });
    }
    String getRewardGold = "?mID=12&iCup=2";
    final resGold = await get(Constant.apiAdress +
        '/api/mobile/game.asmx/gameHuyHieu' +
        getRewardGold);
    List<Achievements> listGold = [];
    if (resGold.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        listGold.add(Achievements(
            element['appLogo'].toString(),
            element['appName'].toString(),
            element['isLevel'].toString(),
            element['adPoint'].toString(),
            2));
      });
      setState(() {
        achievementsGold = listGold;
      });
    }
    String getRewardSilver = "?mID=12&iCup=1";
    final resSilver = await get(Constant.apiAdress +
        '/api/mobile/game.asmx/gameHuyHieu' +
        getRewardSilver);
    List<Achievements> listSilver = [];
    if (resSilver.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        listSilver.add(Achievements(
            element['appLogo'].toString(),
            element['appName'].toString(),
            element['isLevel'].toString(),
            element['adPoint'].toString(),
            1));
      });
      setState(() {
        achievementsSilver = listSilver;
      });
    }
    String getReward = "?mID=12";
    final resss = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/gameThanhTich' + getReward);
    List<Achievements> list = [];
    if (resss.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        list.add(Achievements(
            element['appLogo'].toString(),
            element['appName'].toString(),
            element['isLevel'].toString(),
            element['adPoint'].toString(),
            element['isCup']));
      });
      setState(() {
        achievements = list;
      });
    }
  }

  start(String routes) async {
    if (onAudio) {
      player = await audioCache.play('play.mp3');
    }
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
          body: Padding(
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
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Image.asset(
                            'assets/images/play-button.png',
                            width: MediaQuery.of(context).size.width * 0.6,
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
                          onPressed: () => {start(Routes.gameScreen)},
                        ),
                        Container(
                          height: 20,
                        ),
                        TextButton(
                            child: Image.asset(
                              'assets/images/huyhieu-button.png',
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                                padding: MaterialStateProperty.resolveWith(
                                    (states) =>
                                        EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                shadowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent)),
                            onPressed: () => {
                                  showDialog<void>(
                                      context: context,
                                      builder: (builder) {
                                        return ArmorialDialog(
                                          achievementsDiamond:
                                              achievementsDiamond,
                                          achievementsGold: achievementsGold,
                                          achievementsSilver:
                                              achievementsSilver,
                                        );
                                      })
                                }),
                        Container(
                          height: 20,
                        ),
                        TextButton(
                          child: Image.asset(
                            'assets/images/thanhtich.png',
                            width: MediaQuery.of(context).size.width * 0.5,
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
                          onPressed: () async => {
                            if (onAudio)
                              {player = await audioCache.play('help.mp3')},
                            showDialog<void>(
                                context: context,
                                builder: (builder) {
                                  return AchievementsDialog(
                                    achievements: achievements,
                                  );
                                })
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Image.asset(
                        'assets/images/gift-home.png',
                        width: MediaQuery.of(context).size.width * 0.15,
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
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return RewardDialog(
                                startReward: () {
                                  myRewarded.show();
                                },
                                closeDialog: () async {
                                  if (onAudio) {
                                    player = await audioCache.play('play.mp3');
                                  }
                                },
                                content:
                                    '',
                              );
                            });
                      },
                    ),
                    TextButton(
                      child: Image.asset(
                        onAudio
                            ? 'assets/images/volum-home.png'
                            : 'assets/images/loa-mo.png',
                        width: MediaQuery.of(context).size.width * 0.15,
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
                      onPressed: () async => {
                        this.setState(() {
                          onAudio = !onAudio;
                        }),
                        if (onAudio)
                          {player = await audioCache.play('play.mp3')},
                        _storage.deleteValue('backgroundMusic'),
                        _storage.writeValue(
                            'backgroundMusic', this.onAudio.toString()),
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
