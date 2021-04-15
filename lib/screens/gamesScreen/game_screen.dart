import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:doan_hinh/api/api.dart';
import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/constant/ad_state.dart';
import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/lib/pin_code_text_field.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:doan_hinh/storage/process_image.dart';
import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';

import '../../main.dart';
import 'help_dialog.dart';

final _storage = new LocalStorage();
class GameScreen extends StatefulWidget {

  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreen createState() {
    return _GameScreen();
  }
}
class _GameScreen extends State<GameScreen> {
  BannerAd banner;
  TextEditingController controller = TextEditingController(text: "");
  TextEditingController controller2 = TextEditingController(text: "");
  String currentText = '';
  String currentText2 = '';
  Map<int,String> arraysBk = new Map();
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
  var wrongCharacter ;
  var levelInt;
  var adPointInt;
  var pointAQuestion;
  var isDisableWrongCharacter = false;
  List<CharacterOpened> listOpened = new List();
  @override
  void initState() {
    super.initState();
    getQuestion();
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
          });
        });
      }
    });
  }
  getQuestion () async {
    var appID = await _storage.readValue('appID');
    setState(() {
      appIDState = appID;
      isCorrect = false;
    });
    controller.value = TextEditingValue(text: '');
    await getLevelAndPoint();
    String dataAPI = '?mID=12&appID=' + appID + '&level=' + levelInt.toString();
    final res = await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgGet' + dataAPI);
    if(res.statusCode == 200) {

      print(res.body);
      var resultData = [];
      if(json.decode(res.body)['data']['iD'] != 0) {
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
        });
      } else {
        Navigator.pushReplacementNamed(context, Routes.endQuestion);
      }
    }
  }

  getLevelAndPoint () async {
    String dataGet = "?mID=12&appID=" + appIDState.toString();
    final response = await get(Constant.apiAdress + '/api/mobile/game.asmx/getLevel' + dataGet);
    var level = json.decode(response.body)['data']['isLevel'].toString();
    var adPoint = json.decode(response.body)['data']['adPoint'].toString();
    setState(() {
      levelInt = level;
      adPointInt = adPoint;
    });
  }

  inputFirstLine (int i) {
    if (controller.value.text.length == currentText
        .replaceAll(new RegExp(r"\s+"), "")
        .length) {
      setState(() {
        currentText += '${dataBk[i]}';
      });
      arraysBk[i] = dataBk[i];
      dataBk.replaceRange(i, i+1, [' ']);
      controller.value = TextEditingValue(text: currentText);
    } else {
      var text = currentText.replaceFirst(' ', '${dataBk[i]}');
      setState(() {
        currentText = text;
      });
      arraysBk[i] = dataBk[i];
      dataBk.replaceRange(i, i+1, [' ']);
      controller.value = TextEditingValue(text: text);
    }
  }

  checkAnswer() async {
    if(length2 == 0) {
      if (currentText
          .replaceAll(new RegExp(r"\s+"), "")
          .length == length1) {
        if (currentText == answer) {
          String data = '?mID=12&appID=' + appIDState + '&isLevel=' +
              (int.parse(levelInt) + 1).toString() + '&adPoint=' +
              pointAQuestion;
          await get(
              Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpLevel' +
                  data);
          setState(() {
            isCorrect = true;
          });
        } else {
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
      if(currentText.replaceAll(new RegExp(r"\s+"), "").length + currentText2.replaceAll(new RegExp(r"\s+"), "").length == length1 + length2) {
        if(currentText + currentText2 == answer) {
          String data = '?mID=12&appID=' + appIDState + '&isLevel='+ (int.parse(levelInt) + 1).toString() + '&adPoint=' + pointAQuestion;
          await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpLevel' + data);
          setState(() {
            isCorrect = true;
          });
        } else {
          setState(() {
            hasError = true;
          });
        }
      }
    }
  }

  press (int i) async {
    if(dataBk[i] != ' ') {
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
                .length) {
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
    String data = '?mID=12&appID=' + appIDState + '&isLevel='+ (int.parse(levelInt) + 1).toString() + '&adPoint=0' ;
    await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpLevel' + data);
    String dataAPI  = '?mID=12&appID=' + appIDState + '&dePoint=' + moDapAn;
    var res = await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpDePoint' + dataAPI);
    if(res.statusCode == 200) {
      setState(() {
        adPointInt = 0;
        isCorrect = true;
      });

    }
  }

  addCharacterLineOne() {
    if (controller.value.text.length == currentText
        .replaceAll(new RegExp(r"\s+"), "")
        .length) {

      var index = controller.value.text.length  + Random().nextInt(answer.length - controller.value.text.length);
      String character = answer[index];
      var i = 0;
      for(int j = 0 ; j< dataBk.length ; j ++) {
        if(dataBk[j] == character) {
          i = j;
          break;
        }
      }
      CharacterOpened characterOpened = new CharacterOpened(index,i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacter(i);


    } else {
      var dataSpace = [];
      for(int i = 0; i< currentText.length; i ++) {
        List<CharacterOpened> check = [];
        check = listOpened.where((element) => element.indexText == i).toList();
        if(check.length == 0) {
          dataSpace.add(i);
        }
      }
      var rand = Random().nextInt(dataSpace.length);
      var character = answer[dataSpace[rand]];
      var i = 0;
      for(int j = 0 ; j< dataBk.length ; j ++) {
        if(dataBk[j] == character) {
          i = j;
          break;
        }
      }
      CharacterOpened characterOpened = new CharacterOpened(dataSpace[rand],i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacter(i);
    }
  }

  addBackupCharacter(int indexArrays) {
    var text = '';
    for(int i = 0; i< length1 ; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText == i).toList();
      if(check.length == 0) {
        text += ' ';
      } else {
        text += check.elementAt(0).character;
      }
    }

    setState(() {
      currentText = text;
    });

    arraysBk[indexArrays] = dataBk[indexArrays];
    dataBk.replaceRange(indexArrays, indexArrays+1, [' ']);

    controller.value = TextEditingValue(text: text);
    checkAnswer();
  }

  addBackupCharacterTwoLines(int indexArrays) {
    var text1 = '';
    var text2 = '';
    for(int i = 0; i< length1 ; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText == i).toList();
      if(check.length == 0) {
        text1 += ' ';
      } else {
        text1 += check.elementAt(0).character;
      }
    }
    for(int i = 0; i< length2 ; i++) {
      List<CharacterOpened> check = [];
      check = listOpened.where((element) => element.indexText - length1  == i).toList();
      if(check.length == 0) {
        text2 += ' ';
      } else {
        text2 += check.elementAt(0).character;
      }
    }
    setState(() {
      currentText = text1;
      currentText2 = text2;
    });

    arraysBk[indexArrays] = dataBk[indexArrays];
    dataBk.replaceRange(indexArrays, indexArrays+1, [' ']);

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
      var index = controller.value.text.length + controller2.value.text.length  + Random().nextInt(answer.length - controller.value.text.length - controller2.value.text.length);
      String character = answer[index];
      var i = 0;
      for(int j = 0 ; j< dataBk.length ; j ++) {
        if(dataBk[j] == character) {
          i = j;
          break;
        }
      }

      CharacterOpened characterOpened = new CharacterOpened(index,i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacterTwoLines(i);
    } else {
      var dataSpace = [];
      for(int i = 0; i< currentText.length; i ++) {
        List<CharacterOpened> check = [];
        check = listOpened.where((element) => element.indexText == i).toList();
        if(check.length == 0) {
          dataSpace.add(i);
        }
      }
      for(int i = 0; i< currentText2.length; i ++) {
          List<CharacterOpened> check = [];
          check = listOpened.where((element) => element.indexText == i + length1 ).toList();
        if(check.length == 0) {
          dataSpace.add(i + length1);
        }
      }
      var rand = Random().nextInt(dataSpace.length);
      var character = answer[dataSpace[rand]];
      var i = 0;
      for(int j = 0 ; j< dataBk.length ; j ++) {
        if(dataBk[j] == character) {
          i = j;
          break;
        }
      }
      CharacterOpened characterOpened = new CharacterOpened(dataSpace[rand],i, dataBk[i]);
      listOpened.add(characterOpened);
      addBackupCharacterTwoLines(i);
    }
  }

  openCharacterF() async {
    String dataAPI  = '?mID=12&appID=' + appIDState + '&dePoint=' + moChuCai;
    var res = await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpDePoint' + dataAPI);
    if(res.statusCode == 200) {
      controller.value = TextEditingValue(text: '');
      controller2.value = TextEditingValue(text: '');
      var databk = [];
      for (int i = 0; i < localData.length; i ++) {
        List<CharacterOpened> check = [];
        check = listOpened.where((element) => element.indexArray == i).toList();
        if (check.length == 0) {
          databk.add(localData[i]);
        } else {
          databk.add(' ');
        }
      }
      setState(() {
        dataBk = databk;
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

  }

  disableWrongCharacterF() async {
    String dataAPI  = '?mID=12&appID=' + appIDState + '&dePoint=' + boChuCai;
    var res = await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgUpDePoint' + dataAPI);
    if(res.statusCode == 200) {
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
  }

  back (String routes) {
    Navigator.pushReplacementNamed(context, routes);
  }

  shareToFacebook() async {
    String path = await ProcessImage().filePath(imgPath);

    final text = 'Mọi người giúp mình với';
    final RenderBox box = context.findRenderObject();
    Share.shareFiles([path],subject : text,text: text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: !isCorrect ? [
            Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                TextButton(
                  child: Icon(Icons.home),
                  onPressed: () => {
                    back(Routes.home)
                  },
                ),
                Container(width: 70,),
                Column(
                  children: [
                    Text('Level'),
                    Text(levelInt.toString())
                  ],
                ),
                Container(width: 170,),
                Column(
                  children: [
                    Text('Điểm'),
                    Text(adPointInt.toString())
                  ],
                )
              ]
            ),
            Container(height: 20,),
            Text(questionTitle),
            isLoaded? Image.network(imgPath,height: 300,) : Container(),
            PinCodeTextField(
              autofocus: false,
              controller: controller,
              hideCharacter: false,
              highlight: true,
              pinBoxHeight: length1 >= 10 ? 30 :40,
              pinBoxWidth: length1 >= 10 ? 30 :40,
              defaultBorderColor: CupertinoColors.black,
              maxLength: length1,
              hasError: hasError,
              isCupertino: false,
              wrapAlignment: WrapAlignment.end,
              pinTextStyle: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: 15.0),
              pinBoxBorderWidth: 0.5,
              removeFromResult: (i,text) {
                var index = arraysBk.keys.firstWhere(
                        (k) => arraysBk[k] == text, orElse: () => null);
                if(index != null) {
                  setState(() {
                    dataBk.replaceRange(index, index+1, [text]);
                    arraysBk.remove(index);
                  });
                }
                setState(() {
                  currentText = currentText.replaceRange(i, i+1, ' ');
                  hasError = false;
                });
              },
              hideDefaultKeyboard: true,
            ),
            length2 > 0 ? Expanded (
              flex : 0,
              child: SizedBox(height: 10),
            ): Container(),
            PinCodeTextField(
              autofocus: false,
              controller: controller2,
              hideCharacter: false,
              highlight: true,
              pinBoxHeight:40,
              pinBoxWidth: 40,
              defaultBorderColor: CupertinoColors.black,
              maxLength: length2,
              hasError: hasError,
              isCupertino: false,
              wrapAlignment: WrapAlignment.end,
              pinTextStyle: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: 15.0),
              pinBoxBorderWidth: 0.5,
              removeFromResult: (i,text) {
                var index = arraysBk.keys.firstWhere(
                        (k) => arraysBk[k] == text, orElse: () => null);
                if(index != null) {
                  setState(() {
                    dataBk.replaceRange(index, index+1, [text]);
                    arraysBk.remove(index);
                  });
                }
                setState(() {
                  currentText2 = currentText2.replaceRange(i, i+1, ' ');
                  hasError = false;
                });
              },
              hideDefaultKeyboard: true,
            ),
            Wrap(
              children : List.generate(dataBk.length,(int i) {
                return TextButton(
                  child: Text('${dataBk[i]}'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                  ),
                  onPressed: () {
                    this.press(i);
                  },
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppButton(
                  'Trợ giúp',
                  icon: Icon(Icons.live_help_outlined),
                  onPressed: () => {
                    showDialog<void>(context: context, builder: (builder){
                      return HelpDialog(
                        openAnswer: moDapAn ,
                        openCharacter: moChuCai,
                        disableWrongCharacter: boChuCai,

                        openAnswerF: () {
                          openAnswerF();
                        },
                        openCharacterF: () {
                          openCharacterF();
                        },
                        disableWrongCharacterF: () {
                          disableWrongCharacterF();
                        },
                        isDisableWrongCharacter: isDisableWrongCharacter,);
                    })
                  },
                ),
                Container(width: 50,),
                AppButton(
                  'Chia sẻ',
                  icon: Icon(Icons.reply),
                  onPressed: () {
                    shareToFacebook();
                  },
                )
              ],),
            Expanded (
                flex : 1,
                child: SizedBox(height: 140),
              ),
                if (banner == null)
                  SizedBox(height: 50)
                else
                  Container(
                    height: 50,
                    child: AdWidget(ad: banner),
                  )
          ] : [
            Padding(padding: EdgeInsets.all(10)),
            Row(),
            Text(questionTitle),
            isLoaded? Image.network(imgPath,height: 300,) : Container(),
            Text(answerVI),
            Text("+ " + pointAQuestion + " điểm"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppButton(
                  'Tiếp tục',
                  icon: Icon(Icons.ac_unit),
                  onPressed: () {
                    this.getQuestion();
                  },
                ),
                Container(width: 50,),
                AppButton(
                  'Chia sẻ',
                  icon: Icon(Icons.ac_unit),
                  onPressed: () {
                    shareToFacebook();
                  },
                )
              ],),
                Expanded (
                  flex : 1,
                  child: SizedBox(height: 140),
                ),
                if (banner == null)
                  SizedBox(height: 50)
                else
                  Container(
                    height: 50,
                    child: AdWidget(ad: banner),
                  )

          ],
        )
        ,
      ),
    );
  }
}

class CharacterOpened {
  int indexText;
  int indexArray;
  String character;

  CharacterOpened(this.indexText,this.indexArray,this.character);
}
