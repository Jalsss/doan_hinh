import 'dart:async';
import 'dart:convert';

import 'package:doan_hinh/constant/constant.dart';
import 'package:doan_hinh/lib/pin_code_text_field.dart';
import 'package:doan_hinh/screens/home/home.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

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
  TextEditingController controller = TextEditingController(text: "");
  TextEditingController controller2 = TextEditingController(text: "");
  String currentText = '';
  String currentText2 = '';
  String moDapAn = '';
  String moChuCai = '';
  String boChuCai = '';
  Map<int,String> arraysBk = new Map();
  bool hasError = false;
  int idx = 0;
  var data = [];
  var dataBk = [];
  var length1 = 0;
  var length2 = 0;
  var imgPath = '';
  var isLoaded = false;
  var isTwoLine = false;
  var questionTitle = '';
  var answer = '';
  var answerVI = '';
  var isCorrect = false;
  var levelInt = 1;
  @override
  void initState() {
    super.initState();
    processAPI();
  }

  processAPI () async {
    var level = await _storage.readValue('level');
    if(level == null) {
      await _storage.writeValue(level, levelInt.toString());
      getQuestion();
    } else {

    }
  }

  getQuestion () async {
    var appID = await _storage.readValue('appID');
    String dataAPI = '?mID=12&appID=' + appID + '&level=' + levelInt.toString();
    final res = await get(Constant.apiAdress + '/api/mobile/game.asmx/gameImgGet' + dataAPI);
    if(res.statusCode == 200) {
      var resultData = [];
      var datajson = json.decode(res.body)['data'];
      var result = datajson['dapAnEN'].toString();
      var resultVI = datajson['dapAnVI'].toString();
      for(int i=0; i<result.length ; i++) {
        resultData.add(result.substring(i,i+1));
      }
      var exampleData = [];
      var example = datajson['phimNhap'].toString();
      for(int i=0; i<example.length ; i++) {
        exampleData.add(example.substring(i,i+1));
      }
      var length1Json = int.parse(datajson['dong1'].toString());
      var length2Json = int.parse(datajson['dong2'].toString());
      var imgPathJson = datajson['hinhAnh'].toString();
      var questionTitleJson = datajson['tenCauHoi'].toString();
      var moDapAnJson = datajson['moDapAn'].toString();
      var moChuCaiJson = datajson['moChuCai'].toString();
      var boChuCaiJson = datajson['boChuCai'].toString();
      this.setState(() {
        answer = result;
        answerVI = resultVI;
        data = resultData;
        dataBk = exampleData;
        length1 = length1Json;
        length2 = length2Json;
        imgPath = imgPathJson;
        isLoaded = true;
        questionTitle = questionTitleJson;
        moDapAn = moDapAnJson;
        moChuCai = moChuCaiJson;
        boChuCai = boChuCaiJson;
      });
    }
  }
  PinBoxDecoration defaultPinBoxDecoration = (
      Color borderColor,
      Color pinBoxColor, {
        double borderWidth = 2.0,
        double radius = 5.0,
      }) {
    return BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        color: pinBoxColor,
        borderRadius: BorderRadius.circular(radius));
  };

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
  press (int i) {
    if(length2 == 0) {
      if (currentText
          .replaceAll(new RegExp(r"\s+"), "")
          .length >= length1) {

      } else {
        inputFirstLine(i);
        if(currentText.replaceAll(new RegExp(r"\s+"), "").length == length1) {
          if(currentText == answer) {
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
      }
    } else {
      if (currentText.replaceAll(new RegExp(r"\s+"), "").length >= length1) {
        if (currentText2.replaceAll(new RegExp(r"\s+"), "").length >= length2) {

        } else {
          if (controller2.value.text.length == currentText2
              .replaceAll(new RegExp(r"\s+"), "")
              .length) {
            setState(() {
              currentText2 += '${dataBk[i]}';
            });
            arraysBk[i] = dataBk[i];
            dataBk.replaceRange(i, i+1, [' ']);
            controller2.value = TextEditingValue(text: currentText2);
            if(currentText.replaceAll(new RegExp(r"\s+"), "").length + currentText2.replaceAll(new RegExp(r"\s+"), "").length == length1 + length2) {
              if(currentText + currentText2 == answer) {
                setState(() {
                  isCorrect = true;
                });
              } else {
                setState(() {
                  hasError = true;
                });
              }
            }
          } else {
            var text = currentText2.replaceFirst(' ', '${dataBk[i]}');
            setState(() {
              currentText2 = text;
            });
            arraysBk[i] = dataBk[i];
            dataBk.replaceRange(i, i+1, [' ']);
            controller2.value = TextEditingValue(text: text);
            if(currentText.replaceAll(new RegExp(r"\s+"), "").length + currentText2.replaceAll(new RegExp(r"\s+"), "").length == length1 + length2) {
              if(currentText + currentText2 == answer) {
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
      } else {
        inputFirstLine(i);
      }
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: !isCorrect ? [
            Padding(padding: EdgeInsets.all(10)),
            Row(),
            Text(questionTitle),
            isLoaded? Image.network(imgPath,height: 300,) : Container(),
            PinCodeTextField(
              autofocus: false,
              controller: controller,
              hideCharacter: false,
              highlight: true,
              pinBoxHeight:40,
              pinBoxWidth: 40,
              defaultBorderColor: CupertinoColors.black,
              maxLength: length1,
              hasError: hasError,
              isCupertino: false,
              wrapAlignment: WrapAlignment.end,
              pinTextStyle: TextStyle(fontSize: 10.0),
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
            Text(''),
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
              pinTextStyle: TextStyle(fontSize: 10.0),
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
                        disableWrongCharacter: boChuCai,);
                    })
                  },
                ),
                Container(width: 50,),
                AppButton(
                  'Chia sẻ',
                  icon: Icon(Icons.reply),
                  onPressed: () => {
                    // start(Routes.gameScreen)
                  },
                )
              ],)
          ] : [
            Padding(padding: EdgeInsets.all(10)),
            Row(),
            Text(questionTitle),
            isLoaded? Image.network(imgPath,height: 300,) : Container(),
            Text(answerVI),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppButton(
                  'Tiếp tục',
                  icon: Icon(Icons.ac_unit),
                  onPressed: () => {
                    //start(Routes.gameScreen)
                  },
                ),
                Container(width: 50,),
                AppButton(
                  'Chia sẻ',
                  icon: Icon(Icons.ac_unit),
                  onPressed: () => {
                    // start(Routes.gameScreen)
                  },
                )
              ],)
          ],
        ),
      ),
    );
  }
}
