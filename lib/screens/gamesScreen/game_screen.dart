import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info/device_info.dart';
import 'package:doan_hinh/api/api.dart';
import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/constant/ad_state.dart';
import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:doan_hinh/lib/pin_code_text_field.dart';
import 'package:doan_hinh/notification/notification.config.dart';
import 'package:doan_hinh/screens/gamesScreen/achievements_dialog.dart';
import 'package:doan_hinh/screens/gamesScreen/menu_dialog.dart';
import 'package:doan_hinh/screens/gamesScreen/reward_dialog.dart';
import 'package:doan_hinh/screens/home/home.dart';
import 'package:doan_hinh/screens/home/loading_screen.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:doan_hinh/storage/process_image.dart';
import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../main.dart';
import 'armorial_dialog.dart';
import 'help_dialog.dart';
import 'login_dialog.dart';
import 'notification_dialog.dart';

final _storage = new LocalStorage();

void audioPlayerHandler(AudioPlayerState value) => null;

class GameScreen extends StatefulWidget {

  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreen createState() {
    return _GameScreen();
  }
}

class _GameScreen extends State<GameScreen> {

  final facebookLogin = FacebookLogin();
  BannerAd banner;
  RewardedAd myRewarded;
  TextEditingController controller = TextEditingController(text: "");
  TextEditingController controller2 = TextEditingController(text: "");
  String currentText = '';
  String currentText2 = '';
  Map<int, String> arraysBk = new Map();
  bool hasError = false;
  int idx = 0;
  var appIDState;
  var data = [];
  var dataBk = [];
  var localData = [];
  var length1 = 0;
  var length2 = 0;
  var imgPath = '';
  var isLoaded = false;
  var isTwoLine = false;
  var questionTitle = '';
  var answer = '';
  var answerVI = '';
  var moDapAn = '';
  var moChuCai = '';
  var boChuCai = '';
  var isCorrect = false;
  var wrongCharacter;
  bool isLogin = false;
  var levelInt;
  var adPointInt;
  var pointAQuestion;
  var isDisableWrongCharacter = false;
  List<CharacterOpened> listOpened = new List();
  AudioCache audioCache = AudioCache();
  AudioPlayer player = new AudioPlayer();
  bool onAudio;
  List<Achievements> achievements = [];
  List<Achievements> achievementsDiamond = [];
  List<Achievements> achievementsGold = [];
  List<Achievements> achievementsSilver = [];
  AdListener listener;

  String iD = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      player.monitorNotificationStateChanges(audioPlayerHandler);
    }
    getPlatform();
    getQuestion();
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
            Constant.apiAdress + '/api/mobile/game.asmx/gameImgQC' +
                data);
        await getLevelAndPoint();

        return showDialog(context: context, builder: (context) {
          return CollectDialog();
        });
      },
    );
    checkIsOnAudio();
  }

  checkIsOnAudio() async {
    var _onAudio = await _storage.readValue('backgroundMusic');
    setState(() {
      _onAudio == "true" ? onAudio = true : onAudio = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    check().then((intenet) async {
      if (intenet != null && intenet) {
        adState.initialization.then((status) {
          setState(() {
            banner = BannerAd(
              adUnitId: bannerAdUnitId,
              size: AdSize.banner,
              request: AdRequest(),
              listener: adState.adListener,
            )
              ..load();
            myRewarded = RewardedAd(
              adUnitId: rewardAdUnitId,
              request: AdRequest(),
              listener: listener,
            )
              ..load();
          });
        });
      }
    });
  }

  showArmorialDialog() async {
    String getRewardDiamond = "?mID=12&iCup=3";
    final res = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/gameHuyHieu' +
            getRewardDiamond);
    List<Achievements> listDiamond = [];
    if (res.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        listDiamond.add(Achievements(
            element['appLogo'].toString(), element['appName'].toString(),
            element['isLevel'].toString(), element['adPoint'].toString(), 3));
      });
      setState(() {
        achievementsDiamond = listDiamond;
      });
    }
    String getRewardGold = "?mID=12&iCup=2";
    final resGold = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/gameHuyHieu' +
            getRewardGold);
    List<Achievements> listGold = [];
    if (resGold.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        listGold.add(Achievements(
            element['appLogo'].toString(), element['appName'].toString(),
            element['isLevel'].toString(), element['adPoint'].toString(), 2));
      });
      setState(() {
        achievementsGold = listGold;
      });
    }
    String getRewardSilver = "?mID=12&iCup=1";
    final resSilver = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/gameHuyHieu' +
            getRewardSilver);
    List<Achievements> listSilver = [];
    if (resSilver.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        listSilver.add(Achievements(
            element['appLogo'].toString(), element['appName'].toString(),
            element['isLevel'].toString(), element['adPoint'].toString(), 1));
      });
      setState(() {
        achievementsSilver = listSilver;
      });
    }
    showDialog<void>(
        context: context, builder: (builder) {
      return ArmorialDialog(
        achievementsDiamond: achievementsDiamond,
        achievementsGold: achievementsGold,
        achievementsSilver: achievementsSilver,);
    });
  }

  getQuestion() async {
    var appID = await _storage.readValue('appID');
    var token = await _storage.readValue('token');
    if (appID == token) {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = true;
      });
    }
    setState(() {
      appIDState = appID;
      isCorrect = false;
      isLoaded = false;
      listOpened = new List();
      arraysBk = new Map();
    });
    controller.value = TextEditingValue(text: '');
    await getLevelAndPoint();
    String dataAPI = '?mID=12&appID=' + appID + '&level=' + levelInt.toString();
    final res = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/gameImgGet' + dataAPI);
    if (res.statusCode == 200) {
      print(res.body);
      var resultData = [];
      if (json.decode(res.body)['data']['iD'] != "") {
        var datajson = json.decode(res.body)['data'];
        var result = datajson['dapAnEN'].toString();
        var resultVI = datajson['dapAnVI'].toString();
        for (int i = 0; i < result.length; i++) {
          resultData.add(result.substring(i, i + 1));
        }
        var exampleData = [];
        var example = datajson['phimNhap'].toString();
        for (int i = 0; i < example.length; i++) {
          exampleData.add(example.substring(i, i + 1));
        }
        var exampleDataBK = [];
        var exampleBk = datajson['phimNhap'].toString();
        for (int i = 0; i < exampleBk.length; i++) {
          exampleDataBK.add(exampleBk.substring(i, i + 1));
        }
        var length1Json = int.parse(datajson['dong1'].toString());
        var length2Json = int.parse(datajson['dong2'].toString());
        if (length2Json != 0) {
          controller2.value = TextEditingValue(text: '');
        }
        var imgPathJson = datajson['hinhAnh'].toString();
        var questionTitleJson = datajson['tenCauHoi'].toString();
        var moDapAnJson = datajson['moDapAn'].toString();
        var moChuCaiJson = datajson['moChuCai'].toString();
        var boChuCaiJson = datajson['boChuCai'].toString();
        var point = datajson['soDiem'].toString();
        var wrongCharacterJson = datajson['kyTuSai'].toString();
        await Future.delayed(Duration(milliseconds: 300));
        this.setState(() {
          answer = result;
          answerVI = resultVI;
          data = resultData;
          dataBk = exampleData;
          localData = exampleDataBK;
          length1 = length1Json;
          length2 = length2Json;
          imgPath = imgPathJson;
          isLoaded = true;
          questionTitle = questionTitleJson;
          moDapAn = moDapAnJson;
          moChuCai = moChuCaiJson;
          boChuCai = boChuCaiJson;
          pointAQuestion = point;
          currentText = '';
          currentText2 = '';
          wrongCharacter = wrongCharacterJson;
          isDisableWrongCharacter = false;
          iD = json.decode(res.body)['data']['iD'].toString();
        });
      } else {
        Navigator.pushReplacementNamed(context, Routes.endQuestion);
      }
    }
  }

  getLevelAndPoint() async {
    String dataGet = "?mID=12&appID=" + appIDState.toString();
    final response = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/getLevel' + dataGet);
    var level = json.decode(response.body)['data']['isLevel'].toString();
    var adPoint = json.decode(response.body)['data']['adPoint'].toString();
    setState(() {
      levelInt = level;
      adPointInt = adPoint;
    });
    String getReward = "?mID=12";
    final res = await get(
        Constant.apiAdress + '/api/mobile/game.asmx/gameThanhTich' + getReward);
    List<Achievements> list = [];
    if (res.statusCode == 200) {
      List<dynamic> data = json.decode(res.body)['data'];
      data.forEach((element) {
        list.add(Achievements(element['appLogo'].toString(),
            element['appName'].toString(),
            element['isLevel'].toString(),
            element['adPoint'].toString(),
            element['isCup']
        ));
      });
      setState(() {
        achievements = list;
      });
    }
  }

  inputFirstLine(int i) {
    if (controller.value.text.length == currentText
        .replaceAll(new RegExp(r"\s+"), "")
        .length && currentText.length < length1) {
      setState(() {
        currentText += '${dataBk[i]}';
      });
      arraysBk[i] = dataBk[i];
      dataBk.replaceRange(i, i + 1, [' ']);
      controller.value = TextEditingValue(text: currentText);
    } else {
      var text = currentText.replaceFirst(' ', '${dataBk[i]}');
      setState(() {
        currentText = text;
      });
      arraysBk[i] = dataBk[i];
      dataBk.replaceRange(i, i + 1, [' ']);
      controller.value = TextEditingValue(text: text);
    }
  }

  checkAnswer() async {
    if (length2 == 0) {
      if (currentText
          .replaceAll(new RegExp(r"\s+"), "")
          .length == length1) {
        if (currentText == answer) {
          String data = '?mID=12&appID=' + appIDState + '&isLevel=' +
              (int.parse(levelInt) + 1).toString() + '&adPoint=' +
              pointAQuestion;
          var res = await get(
              Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpLevel' +
                  data);
          if (json.decode(res.body)['message'] != 'Success') {
            showDialog(context: context, builder: (builder) {
              return NotificationDialog(
                closeDialog: () async {
                  if (onAudio) {
                    player =
                    await audioCache.play('play.mp3');
                  }
                },
                content: json.decode(res.body)['message'] == 'Bac'
                    ? 'B???c'
                    : (json.decode(res.body)['message'] == 'Vang'
                    ? 'V??ng'
                    : 'Kim c????ng'),
              );
            }
            );
          }

          if (onAudio) {
            player = await audioCache.play('correct_answer.mp3');
          }
          setState(() {
            isCorrect = true;
          });
        } else {
          if (onAudio) {
            player = await audioCache.play('wrong_answer.mp3');
          }
          setState(() {
            hasError = true;
          });
        }
      } else {
        setState(() {
          hasError = false;
        });
      }
    } else {
      if (currentText
          .replaceAll(new RegExp(r"\s+"), "")
          .length + currentText2
          .replaceAll(new RegExp(r"\s+"), "")
          .length == length1 + length2) {
        if (currentText + currentText2 == answer) {
          if (onAudio) {
            player = await audioCache.play('correct_answer.mp3');
          }
          String data = '?mID=12&appID=' + appIDState + '&isLevel=' +
              (int.parse(levelInt) + 1).toString() + '&adPoint=' +
              pointAQuestion;
          var res = await get(
              Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpLevel' +
                  data);
          print(res.body);
          setState(() {
            isCorrect = true;
          });
        } else {
          if (onAudio) {
            player = await audioCache.play('wrong_answer.mp3');
          }
          setState(() {
            hasError = true;
          });
        }
      }
    }
  }

  press(int i) async {
    if (dataBk[i] != ' ') {
      if (onAudio) {
        player = await audioCache.play('touch.mp3');
      }
      if (length2 == 0) {
        if (currentText
            .replaceAll(new RegExp(r"\s+"), "")
            .length >= length1) {

        } else {
          inputFirstLine(i);
          checkAnswer();
        }
      } else {
        if (currentText
            .replaceAll(new RegExp(r"\s+"), "")
            .length >= length1) {
          if (currentText2
              .replaceAll(new RegExp(r"\s+"), "")
              .length >= length2) {

          } else {
            if (controller2.value.text.length == currentText2
                .replaceAll(new RegExp(r"\s+"), "")
                .length && currentText2.length < length2) {
              setState(() {
                currentText2 += '${dataBk[i]}';
              });
              arraysBk[i] = dataBk[i];
              dataBk.replaceRange(i, i + 1, [' ']);
              controller2.value = TextEditingValue(text: currentText2);
              checkAnswer();
            } else {
              var text = currentText2.replaceFirst(' ', '${dataBk[i]}');
              setState(() {
                currentText2 = text;
              });
              arraysBk[i] = dataBk[i];
              dataBk.replaceRange(i, i + 1, [' ']);
              controller2.value = TextEditingValue(text: text);
              checkAnswer();
            }
          }
        } else {
          inputFirstLine(i);
        }
      }
    }
  }

  openAnswerF() async {
    if (int.parse(adPointInt) - int.parse(moDapAn) > 0) {
      String data = '?mID=12&appID=' + appIDState + '&isLevel=' +
          (int.parse(levelInt) + 1).toString() + '&adPoint=0';
      await get(
          Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpLevel' + data);
      String dataAPI = '?mID=12&appID=' + appIDState + '&dePoint=' + moDapAn;
      var res = await get(
          Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpDePoint' +
              dataAPI);
      if (res.statusCode == 200) {
        if (onAudio) {
          player = await audioCache.play('correct_answer.mp3');
        }
        setState(() {
          pointAQuestion = 0;
          isCorrect = true;
        });
      }
      getLevelAndPoint();
    } else {
      await Future.delayed(Duration(milliseconds: 100));
      showDialog(context: context, builder: (builder) {
        return RewardDialog(
          startReward: () {
            myRewarded.show();
          },
          closeDialog: () async {
            if (onAudio) {
              player =
              await audioCache.play('play.mp3');
            }
          },
          content: 'S??? ti???n c???a b???n kh??ng ????? ????? d??ng tr??? gi??p, Vui l??ng ',
        );
      }
      );
    }
  }

  addCharacterLineOne() {
    if (controller.value.text.length == currentText
        .replaceAll(new RegExp(r"\s+"), "")
        .length) {
      var i = -1;
      var index;
      while (i == -1) {
        index = controller.value.text.length +
            Random().nextInt(answer.length - controller.value.text.length);
        String character = answer[index];
        for (int j = 0; j < dataBk.length; j ++) {
          if (dataBk[j] == character) {
            i = j;
            break;
          }
        }
      }
      CharacterOpened characterOpened = new CharacterOpened(
          index, i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacter(i);
    } else {
      var dataSpace = [];
      for (int i = 0; i < currentText.length; i ++) {
        List<CharacterOpened> check = [];
        check = listOpened.where((element) => element.indexText == i).toList();
        if (check.length == 0) {
          dataSpace.add(i);
        }
      }
      var rand = Random().nextInt(dataSpace.length);
      var character = answer[dataSpace[rand]];
      var i = 0;
      for (int j = 0; j < dataBk.length; j ++) {
        if (dataBk[j] == character) {
          i = j;
          break;
        }
      }
      CharacterOpened characterOpened = new CharacterOpened(
          dataSpace[rand], i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacter(i);
    }
  }

  addBackupCharacter(int indexArrays) {
    var text = '';
    for (int i = 0; i < length1; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText == i).toList();
      if (check.length == 0) {
        text += ' ';
      } else {
        text += check
            .elementAt(0)
            .character;
      }
    }

    setState(() {
      currentText = text;
    });

    arraysBk[indexArrays] = dataBk[indexArrays];
    dataBk.replaceRange(indexArrays, indexArrays + 1, [' ']);

    controller.value = TextEditingValue(text: text);
    checkAnswer();
  }

  addBackupCharacterForDisableWrong() {
    var text = '';
    for (int i = 0; i < length1; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText == i).toList();
      if (check.length == 0) {
        text += ' ';
      } else {
        text += check
            .elementAt(0)
            .character;
      }
    }

    setState(() {
      currentText = text;
    });
  }

  addBackupCharacterTwoLineForDisableWrong() {
    var text1 = '';
    var text2 = '';
    for (int i = 0; i < length1; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText == i).toList();
      if (check.length == 0) {
        text1 += ' ';
      } else {
        text1 += check
            .elementAt(0)
            .character;
      }
    }
    for (int i = 0; i < length2; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText - length1 == i)
          .toList();
      if (check.length == 0) {
        text2 += ' ';
      } else {
        text2 += check
            .elementAt(0)
            .character;
      }
    }
    setState(() {
      currentText = text1;
      currentText2 = text2;
    });
  }

  addBackupCharacterTwoLines(int indexArrays) {
    var text1 = '';
    var text2 = '';
    for (int i = 0; i < length1; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText == i).toList();
      if (check.length == 0) {
        text1 += ' ';
      } else {
        text1 += check
            .elementAt(0)
            .character;
      }
    }
    for (int i = 0; i < length2; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText - length1 == i)
          .toList();
      if (check.length == 0) {
        text2 += ' ';
      } else {
        text2 += check
            .elementAt(0)
            .character;
      }
    }
    setState(() {
      currentText = text1;
      currentText2 = text2;
    });

    arraysBk[indexArrays] = dataBk[indexArrays];
    dataBk.replaceRange(indexArrays, indexArrays + 1, [' ']);

    controller.value = TextEditingValue(text: text1);
    controller2.value = TextEditingValue(text: text2);
    checkAnswer();
  }

  addCharacterTwoLines() {
    if (controller.value.text.length + controller2.value.text.length ==
        currentText
            .replaceAll(new RegExp(r"\s+"), "")
            .length + currentText2
            .replaceAll(new RegExp(r"\s+"), "")
            .length) {
      var index = controller.value.text.length + controller2.value.text.length +
          Random().nextInt(answer.length - controller.value.text.length -
              controller2.value.text.length);
      String character = answer[index];
      var i = 0;
      for (int j = 0; j < dataBk.length; j ++) {
        if (dataBk[j] == character) {
          i = j;
          break;
        }
      }

      CharacterOpened characterOpened = new CharacterOpened(
          index, i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacterTwoLines(i);
    } else {
      var dataSpace = [];
      for (int i = 0; i < currentText.length; i ++) {
        List<CharacterOpened> check = [];
        check = listOpened.where((element) => element.indexText == i).toList();
        if (check.length == 0) {
          dataSpace.add(i);
        }
      }
      for (int i = 0; i < currentText2.length; i ++) {
        List<CharacterOpened> check = [];
        check = listOpened.where((element) => element.indexText == i + length1)
            .toList();
        if (check.length == 0) {
          dataSpace.add(i + length1);
        }
      }
      var rand = Random().nextInt(dataSpace.length);
      var character = answer[dataSpace[rand]];
      var i = 0;
      for (int j = 0; j < dataBk.length; j ++) {
        if (dataBk[j] == character) {
          i = j;
          break;
        }
      }
      CharacterOpened characterOpened = new CharacterOpened(
          dataSpace[rand], i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacterTwoLines(i);
    }
  }

  openCharacterF() async {
    if (int.parse(adPointInt) - int.parse(moChuCai) > 0) {
      String dataAPI = '?mID=12&appID=' + appIDState + '&dePoint=' + moChuCai;
      var res = await get(
          Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpDePoint' +
              dataAPI);
      if (res.statusCode == 200) {
        controller.value = TextEditingValue(text: '');
        controller2.value = TextEditingValue(text: '');
        var databk = [];
        for (int i = 0; i < localData.length; i ++) {
          List<CharacterOpened> check = [];
          check =
              listOpened.where((element) => element.indexArray == i).toList();
          if (check.length == 0) {
            databk.add(localData[i]);
          } else {
            databk.add(' ');
          }
        }
        setState(() {
          dataBk = databk;
          currentText = '';
        });
        if (length2 == 0) {
          if (currentText
              .replaceAll(new RegExp(r"\s+"), "")
              .length >= length1) {
            return;
          } else {
            addCharacterLineOne();
          }
        } else {
          if (currentText
              .replaceAll(new RegExp(r"\s+"), "")
              .length + currentText2
              .replaceAll(new RegExp(r"\s+"), "")
              .length >= length1 + length2) {
            return;
          } else {
            addCharacterTwoLines();
          }
        }
      }
      getLevelAndPoint();
    } else {
      await Future.delayed(Duration(milliseconds: 100));
      showDialog(context: context, builder: (builder) {
        return RewardDialog(
          startReward: () {
            myRewarded.show();
          },
          closeDialog: () async {
            if (onAudio) {
              player =
              await audioCache.play('play.mp3');
            }
          },
          content: 'S??? ti???n c???a b???n kh??ng ????? ????? d??ng tr??? gi??p, Vui l??ng ',
        );
      }
      );
    }
  }

  disableWrongCharacterF() async {
    if (int.parse(adPointInt) - int.parse(boChuCai) > 0) {
      var databk = [];
      for (int i = 0; i < localData.length; i ++) {
        List<CharacterOpened> check = [];
        check =
            listOpened.where((element) => element.indexArray == i).toList();
        if (check.length == 0) {
          databk.add(localData[i]);
        } else {
          databk.add(' ');
        }
      }
      setState(() {
        dataBk = databk;
        currentText = '';
        currentText2 = '';
        controller.value = TextEditingValue(text: '');
        controller2.value = TextEditingValue(text: '');
      });

      if (length2 == 0) {
        addBackupCharacterForDisableWrong();
      } else {
        addBackupCharacterTwoLineForDisableWrong();
      }

      String dataAPI = '?mID=12&appID=' + appIDState + '&dePoint=' + boChuCai;
      var res = await get(
          Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpDePoint' +
              dataAPI);
      if (res.statusCode == 200) {
        var data = dataBk;
        var arrays = localData;
        for (int i = 0; i < wrongCharacter.length; i++) {
          for (int j = 0; j < data.length; j++) {
            if (wrongCharacter[i] == dataBk[j]) {
              data.replaceRange(j, j + 1, [' ']);
              arrays.replaceRange(j, j + 1, [' ']);
              break;
            }
          }
        }
        setState(() {
          dataBk = data;
          localData = arrays;
          isDisableWrongCharacter = true;
        });
      }
      getLevelAndPoint();
    } else {
      await Future.delayed(Duration(milliseconds: 100));
      showDialog(context: context, builder: (builder) {
        return RewardDialog(
          startReward: () {
            myRewarded.show();
          },
          closeDialog: () async {
            if (onAudio) {
              player =
              await audioCache.play('play.mp3');
            }
          },
          content: 'S??? ti???n c???a b???n kh??ng ????? ????? d??ng tr??? gi??p, Vui l??ng ',
        );
      }
      );
    }
  }

  double percentWidth(double percent) {
    return Constant.percentWidth(percent, context);
  }

  double percentHeight(double percent) {
    return Constant.percentHeight(percent, context);
  }

  back(String routes) async {
    if (onAudio) {
      player = await audioCache.play('play.mp3');
    }
    await Navigator.pushReplacementNamed(context, routes);
  }

  shareToFacebook() async {
    String path = await ProcessImage().filePath(imgPath);

    final text = 'M???i ng?????i gi??p m??nh v???i';
    final RenderBox box = context.findRenderObject();
    Share.share('http://game.izilife.vn/games.aspx?v=' + iD, subject: text);
    // Share.shareFiles([path], subject: text, text: text,
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  bool isIpad = false;


  Future<bool> getPlatform() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.model.toLowerCase().contains("ipad")) {
      setState(() {
        isIpad = true;
      });
    } else {
      setState(() {
        isIpad = false;
      });
    }
  }

  login() async {
    setState(() {
      isLoading = true;
    });
    final result = await facebookLogin.logIn(['email', 'public_profile']);
    var token = await _storage.readValue('token');
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await get(
            'https://graph.facebook.com/${result.accessToken
                .userId}?fields=name,first_name,last_name,email&access_token=${result
                .accessToken.token}');
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
                token +
                "&newID=" +
                appID;
            await get(
                Constant.apiAdress + '/api/mobile/game.asmx/appChange' +
                    dataFcm);
            _storage.writeValue('isSignIn', 'true');
            _storage.writeValue('appID', appID);
            _storage.deleteValue('token');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          } else {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return MyDialog('???? x???y ra l???i, vui l??ng th??? l???i sau');
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
                  title: Text('Th??ng b??o'),
                  content: Text('????ng nh???p th???t b???i'));
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

  loginWithApple() async {
    setState(() {
      isLoading = true;
    });
    var token = await _storage.readValue('token');
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
            token +
            "&newID=" +
            appID;
        await get(
            Constant.apiAdress + '/api/mobile/game.asmx/appChange' + dataFcm);
        _storage.writeValue('isSignIn', 'true');
        _storage.writeValue('appID', appID);
        _storage.deleteValue('token');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog('???? x???y ra l???i, vui l??ng th??? l???i sau');
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
                title: Text('Th??ng b??o'), content: Text('????ng nh???p th???t b???i'));
          });
    }
    // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
    // after they have been validated with Apple (see `Integration` section for more information on how to do this)
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded ? DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-main.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: !isCorrect ? Column(
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.12,
                        child: TextButton(
                          child: Image.asset('assets/images/back-main.png',
                            width: percentWidth(10),),
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
                            back(Routes.home)
                          },
                        )),
                    Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          Image.asset('assets/images/Xu-main.png',
                            width: percentWidth(18),),
                          Center(child: Container(
                              child: Text(adPointInt.toString(),
                                  style: TextStyle(color: Colors.white,
                                      fontSize: percentWidth(4),
                                      fontFamily: 'Chalkboard SE')),
                              margin: EdgeInsets.fromLTRB(0, 0, 6, 0))),
                        ]
                    ),
                    Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: <Widget>[
                          Image.asset('assets/images/Label-level.png',
                            width: percentWidth(40),),
                          Center(child: Container(
                              child: Row(children: [
                                Text('Level ',
                                    style: TextStyle(
                                        color: Colors.brown.shade800,
                                        fontSize: percentWidth(6),
                                        fontFamily: 'Chalkboard SE',
                                        fontWeight: FontWeight.bold)),
                                Text(levelInt.toString(),
                                    style: TextStyle(
                                        color: Colors.brown.shade800,
                                        fontSize: percentWidth(8),
                                        fontFamily: 'Chalkboard SE',
                                        fontWeight: FontWeight.bold))
                              ]),
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0))),
                        ]
                    ),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.15,
                        child: TextButton(
                          child: Image.asset('assets/images/gift-main.png',
                            width: percentWidth(13),),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          onPressed: () async =>
                          {if(onAudio) {
                            player = await audioCache.play('help.mp3')
                          },
                            showDialog<void>(
                                context: context, builder: (builder) {
                              return RewardDialog(
                                  startReward: () {
                                    myRewarded.show();
                                  },
                                  closeDialog: () async {
                                    if (onAudio) {
                                      player =
                                      await audioCache.play('play.mp3');
                                    }
                                  },
                                  content: ''
                              );
                            })
                          },
                        )),

                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.15,
                        child: TextButton(
                          child: Image.asset('assets/images/menu-main.png',
                            width: percentWidth(10),),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          onPressed: () {
                            showDialog<void>(
                                context: context, builder: (builder) {
                              return MenuDialog(
                                armorial: () async {
                                  if (onAudio) {
                                    player = await audioCache.play('help.mp3');
                                  }
                                  isLogin ? showArmorialDialog() :
                                  showDialog<void>(
                                      context: context, builder: (builder) {
                                    return LoginDialog(
                                        loginFacebook: () {login();},
                                        loginApple: (){loginWithApple();},
                                    );
                                  });
                                },
                                achievements: () async {
                                  if (onAudio) {
                                    player = await audioCache.play('help.mp3');
                                  }
                                  if (isLogin) {
                                    showDialog<void>(
                                        context: context, builder: (builder) {
                                      return AchievementsDialog(
                                        achievements: achievements,
                                      );
                                    });
                                  } else {
                                    showDialog<void>(
                                        context: context, builder: (builder) {
                                      return LoginDialog(
                                          loginFacebook: (){login();},
                                          loginApple: (){loginWithApple();},
                                      );
                                    });
                                  }
                                },
                                closeDialog: () {

                                },
                                shareOnFaceBook: () {
                                  Share.share(linkup);
                                },
                                voteGames: () {
                                  OpenAppstore.launch(
                                      androidAppId: linkup,
                                      iOSAppId: linkup);
                                },
                              );
                            }
                            );
                          },
                        ))
                  ]
              ),
              Container(height: percentHeight(0.2),),

              Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Image.asset('assets/images/main-content.png',
                              width: percentWidth(100),
                              height: percentHeight(36),
                              fit: BoxFit.fill),
                          isLoaded ? Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  Text(questionTitle, style: TextStyle(
                                      fontSize: percentWidth(4),
                                      fontFamily: 'Chalkboard SE',
                                      color: Colors.brown.shade900,
                                      fontWeight: FontWeight.bold)),
                                  Container(height: 5,),
                                  Image.network(
                                      imgPath, width: percentWidth(81),
                                      height: percentHeight(27),
                                      fit: BoxFit.fill)
                                ],
                              )
                          ) : Container(),
                        ]),
                    Column(
                        children: [
                          SizedBox(
                              width: percentWidth(13),
                              child: TextButton(
                                child: Image.asset(
                                    'assets/images/ThanhTich-button.png',
                                    width: percentWidth(13)),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateColor
                                        .resolveWith((states) =>
                                    Colors.transparent),
                                    padding: MaterialStateProperty
                                        .resolveWith((states) =>
                                        EdgeInsets.fromLTRB(0, 0, 4, 0)),
                                    shadowColor: MaterialStateColor
                                        .resolveWith((states) =>
                                    Colors.transparent),
                                    overlayColor: MaterialStateColor
                                        .resolveWith((states) =>
                                    Colors.transparent)
                                ),
                                onPressed: () async
                                {
                                  if (onAudio) {
                                    player = await audioCache.play('help.mp3');
                                  }
                                  if (isLogin) {
                                    showDialog<void>(
                                        context: context, builder: (builder) {
                                      return AchievementsDialog(
                                        achievements: achievements,
                                      );
                                    });
                                  } else {
                                    showDialog<void>(
                                        context: context, builder: (builder) {
                                      return LoginDialog(
                                          loginFacebook: (){login();},
                                          loginApple: (){loginWithApple();}
                                      );
                                    });
                                  }
                                },
                              )),
                          SizedBox(
                              width: percentWidth(12),
                              child: TextButton(
                                child: Image.asset(
                                    'assets/images/question.png',
                                    width: percentWidth(11)),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateColor
                                        .resolveWith((states) =>
                                    Colors.transparent),
                                    padding: MaterialStateProperty
                                        .resolveWith((states) =>
                                        EdgeInsets.fromLTRB(0, 0, 4, 0)),
                                    shadowColor: MaterialStateColor
                                        .resolveWith((states) =>
                                    Colors.transparent),
                                    overlayColor: MaterialStateColor
                                        .resolveWith((states) =>
                                    Colors.transparent)
                                ),
                                onPressed: () async
                                {
                                  if (onAudio) {
                                    player = await audioCache.play('help.mp3');
                                  }
                                  showDialog<void>(
                                      context: context, builder: (builder) {
                                    return HelpDialog(
                                      openAnswer: moDapAn,
                                      openCharacter: moChuCai,
                                      disableWrongCharacter: boChuCai,

                                      openAnswerF: () async {
                                        if (onAudio) {
                                          player =
                                          await audioCache.play('use_coin.mp3');
                                        }
                                        openAnswerF();
                                      },
                                      openCharacterF: () async {
                                        if (onAudio) {
                                          player =
                                          await audioCache.play('use_coin.mp3');
                                        }
                                        openCharacterF();
                                      },
                                      disableWrongCharacterF: () async {
                                        if (onAudio) {
                                          player =
                                          await audioCache.play('use_coin.mp3');
                                        }
                                        disableWrongCharacterF();
                                      },
                                      isDisableWrongCharacter: isDisableWrongCharacter,
                                      shareOnFaceBook: () {
                                        shareToFacebook();
                                      },
                                      closeDialog: () async {
                                        if (onAudio) {
                                          player =
                                          await audioCache.play('play.mp3');
                                        }
                                      },);
                                  });
                                },
                              )),
                          // SizedBox(
                          //     width: percentWidth(12),
                          //     child: TextButton(
                          //       child: Image.asset(
                          //         'assets/images/back-main.png',
                          //         width: percentWidth(10),),
                          //       style: ButtonStyle(
                          //           backgroundColor: MaterialStateColor
                          //               .resolveWith((states) =>
                          //           Colors.transparent),
                          //           padding: MaterialStateProperty
                          //               .resolveWith((states) =>
                          //               EdgeInsets.fromLTRB(0, 0, 0, 0)),
                          //           shadowColor: MaterialStateColor
                          //               .resolveWith((states) =>
                          //           Colors.transparent),
                          //           overlayColor: MaterialStateColor
                          //               .resolveWith((states) =>
                          //           Colors.transparent)
                          //       ),
                          //       onPressed: () =>
                          //       {
                          //         shareToFacebook()
                          //       },
                          //     ))
                        ]
                    ),

                  ]),
              Container(height: percentHeight(0.5),),
              PinCodeTextField(
                autofocus: false,
                controller: controller,
                hideCharacter: false,
                highlight: true,
                pinBoxHeight: length1 >= 10 ? 25 : 40,
                pinBoxWidth: length1 >= 10 ? 25 : 40,
                defaultBorderColor: CupertinoColors.black,
                maxLength: length1,
                hasError: hasError,
                isCupertino: false,
                wrapAlignment: WrapAlignment.end,
                pinTextStyle: TextStyle(

                    letterSpacing: 0,
                    wordSpacing: 0,
                    fontSize: length1 >= 10 ? 22.0 : 30.0,
                    fontFamily: 'Chalkboard SE',
                    color: hasError ? Colors.red : Colors.white),
                pinBoxBorderWidth: 0.5,
                removeFromResult: (i, text) async {
                  var index = arraysBk.keys.firstWhere(
                          (k) => arraysBk[k] == text, orElse: () => null);
                  if (index != null) {
                    if (onAudio) {
                      player = await audioCache.play('touch.mp3');
                    }
                    setState(() {
                      dataBk.replaceRange(index, index + 1, [text]);
                      arraysBk.remove(index);
                    });
                  }
                  setState(() {
                    currentText = currentText.replaceRange(i, i + 1, ' ');
                    hasError = false;
                  });
                },
                hideDefaultKeyboard: true,
              ),
              // length2 > 0 ? Expanded(
              //   flex: 0,
              //   child: SizedBox(height: 5),
              // ) : Container(height: 5,),
              length2 > 0 ? PinCodeTextField(
                autofocus: false,
                controller: controller2,
                hideCharacter: false,
                highlight: true,
                pinBoxHeight: length2 >= 10 ? 30 : 40,
                pinBoxWidth: length2 >= 10 ? 30 : 40,
                defaultBorderColor: CupertinoColors.black,
                maxLength: length2,
                hasError: hasError,
                isCupertino: false,
                wrapAlignment: WrapAlignment.end,
                pinTextStyle: TextStyle(
                    letterSpacing: 0,
                    wordSpacing: 0,
                    fontSize: length2 >= 10 ? 22.0 : 30.0,
                    fontFamily: 'Chalkboard SE',
                    color: hasError ? Colors.red : Colors.white),
                pinBoxBorderWidth: 0.5,
                removeFromResult: (i, text) async {
                  var index = arraysBk.keys.firstWhere(
                          (k) => arraysBk[k] == text, orElse: () => null);
                  if (index != null) {
                    if (onAudio) {
                      player = await audioCache.play('touch.mp3');
                    }
                    setState(() {
                      dataBk.replaceRange(index, index + 1, [text]);
                      arraysBk.remove(index);
                    });
                  }
                  setState(() {
                    currentText2 = currentText2.replaceRange(i, i + 1, ' ');
                    hasError = false;
                  });
                },
                hideDefaultKeyboard: true,
              ) : Container(height: percentHeight(10),),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(dataBk.length, (int i) {
                  return Container(
                      width: percentWidth(11),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            dataBk[i] != ' ' ? Image.asset(
                              'assets/images/text-2.png',
                              height: percentWidth(14),) : Container(),
                            TextButton(
                              child: Text('${dataBk[i]}', style: TextStyle(
                                  fontSize: percentWidth(7),
                                  fontFamily: 'Chalkboard SE',
                                  color: Colors.brown.shade900,
                                  fontWeight: FontWeight.bold)),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateColor
                                      .resolveWith((states) =>
                                  Colors.transparent),
                                  padding: MaterialStateProperty.resolveWith((
                                      states) =>
                                      EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                  shadowColor: MaterialStateColor
                                      .resolveWith((states) =>
                                  Colors.transparent),
                                  overlayColor: MaterialStateColor
                                      .resolveWith((states) =>
                                  Colors.transparent)
                              ),
                              onPressed: () {
                                this.press(i);
                              },
                            )
                          ])
                  );
                }),
              ),

              Expanded(
                flex: 1,
                child: SizedBox(height: percentHeight(9)),
              ),
              if (banner == null)
                SizedBox(height: 50)
              else
                Container(
                  height: percentHeight(6),
                  child: AdWidget(ad: banner),
                )
            ],
          ) :
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              //Text(questionTitle),
              Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, percentHeight(5), 0, 0),
                      child: Stack(
                          alignment: Alignment.center, children: <Widget>[
                        Image.asset('assets/images/main-content.png',
                            width: percentWidth(100),
                            height: percentHeight(36),
                            fit: BoxFit.fill),

                        isLoaded ? Image.network(imgPath, width: percentWidth(
                            81),
                            height: percentHeight(29),
                            fit: BoxFit.fill) : Container(),
                      ]),),
                    Stack(alignment: Alignment.topCenter, children: <Widget>[
                      Image.asset('assets/images/ribbon-popup.png',
                        fit: BoxFit.fill,),
                      Container(
                        child: Text('LEVEL UP !',
                            style: TextStyle(
                                fontSize: isIpad == true ? MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.1 : 40,
                                fontFamily: 'Chalkboard SE',
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ]),
                  ]),
              Container(
                height: 50,
              ),
              Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image.asset('assets/images/ketqua.png',
                      width: percentWidth(90),),
                    Center(child: Container(
                        child: Text(answerVI,
                          style: TextStyle(fontFamily: 'Chalkboard SE',
                              fontSize: percentWidth(8),
                              color: Colors.white),),
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0))),
                  ]
              ),
              isIpad ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'B???n nh???n ???????c',
                      style: TextStyle(fontFamily: 'Chalkboard SE',
                          fontSize: percentWidth(7.5),
                          fontWeight: FontWeight.w600,
                          color: HexColor.fromHex('#832400')))
                  ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pointAQuestion.toString() + ' ',
                          style: TextStyle(
                              color: HexColor.fromHex('#501c07'),
                              fontSize: percentWidth(9.5),
                              fontFamily:
                              'Chalkboard SE',
                              fontWeight: FontWeight.w600)),
                      Text('xu ',
                          style: TextStyle(
                              color: HexColor.fromHex('#832400'),
                              fontSize: percentWidth(7),
                              fontFamily:
                              'Chalkboard SE',
                              fontWeight: FontWeight.w600)),
                      Image.asset(
                        'assets/images/coin-popup.png',
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width *
                            0.1,
                      )
                    ],
                  ),
                ],
              ) : Column(
                children: [
                  Text(
                      'B???n nh???n ???????c',
                      style: TextStyle(fontFamily: 'Chalkboard SE',
                          fontSize: percentWidth(7.5),
                          fontWeight: FontWeight.w600,
                          color: HexColor.fromHex('#832400')))
                  ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pointAQuestion.toString() + ' ',
                          style: TextStyle(
                              color: HexColor.fromHex('#501c07'),
                              fontSize: percentWidth(9.5),
                              fontFamily:
                              'Chalkboard SE',
                              fontWeight: FontWeight.w600)),
                      Text('xu ',
                          style: TextStyle(
                              color: HexColor.fromHex('#832400'),
                              fontSize: percentWidth(7),
                              fontFamily:
                              'Chalkboard SE',
                              fontWeight: FontWeight.w600)),
                      Image.asset(
                        'assets/images/coin-popup.png',
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width *
                            0.1,
                      )
                    ],
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.40,
                      child: TextButton(
                        child: Stack(
                            alignment:
                            AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/button2-popup.png',
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.6, fit: BoxFit.fill,
                              ),
                              Center(
                                  child: Container(
                                      child:
                                      Text('Ti???p t???c',
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  '#501c07'),
                                              fontSize: percentWidth(6),
                                              fontFamily:
                                              'Chalkboard SE',
                                              fontWeight: FontWeight.w500)),
                                      margin: EdgeInsets.fromLTRB(
                                          6, 0, 6, 0))),
                            ]),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        ),
                        onPressed: () async =>
                        {
                          if(onAudio) {
                            player = await audioCache.play('play.mp3')
                          },
                          this.getQuestion()
                        },
                      )),
                  SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.40,
                      child: TextButton(
                        child: Stack(
                            alignment:
                            AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset(
                                  'assets/images/chiase.png',
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.6, fit: BoxFit.fill
                              ),
                              Center(
                                  child: Container(
                                      child:
                                      Text('Chia s???',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: percentWidth(6),
                                              fontFamily:
                                              'Chalkboard SE')),
                                      margin: EdgeInsets.fromLTRB(
                                          6, 0, 6, 0))),
                            ]),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        ),
                        onPressed: () =>
                        {
                          shareToFacebook()
                        },
                      ))
                ],),
              Expanded(
                flex: 1,
                child: SizedBox(height: percentHeight(9)),
              ),
              if (banner == null)
                SizedBox(height: 50)
              else
                Container(
                  height: percentHeight(6),
                  child: AdWidget(ad: banner),
                )

            ],
          )

          ,
        ),
      ),
    ) : LoadingScreen();
  }


}


class CharacterOpened {
  int indexText;
  int indexArray;
  String character;

  CharacterOpened(this.indexText, this.indexArray, this.character);
}

class Achievements {
  int armorial;
  String imagePath;
  String name;
  String level;
  String coin;

  Achievements(this.imagePath, this.name, this.level, this.coin, this.armorial);
}