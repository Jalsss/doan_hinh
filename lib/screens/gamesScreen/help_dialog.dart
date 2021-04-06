import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpDialog extends StatefulWidget {
  final String openCharacter;
  final String openAnswer;
  final String disableWrongCharacter;
  final Function() openCharacterF;
  final Function() openAnswerF;
  final Function() disableWrongCharacterF;
  HelpDialog({Key key,
    this.openCharacter,
    this.openAnswer,
    this.disableWrongCharacter,
    this.openCharacterF,
    this.disableWrongCharacterF,
    this.openAnswerF}) : super(key: key);

  @override
  _HelpDialog createState() {
    return _HelpDialog();
  }
}

class _HelpDialog extends State<HelpDialog> {
  openAnswer() {
    var openAnswerF = widget.openAnswerF;
    openAnswerF();
    Navigator.of(context, rootNavigator: true).pop();
  }

  openCharacter() {
    var openCharacterF = widget.openCharacterF;
    openCharacterF();
    Navigator.of(context, rootNavigator: true).pop();
  }


  disableWrongCharacter() {
    var disableWrongCharacterF = widget.disableWrongCharacterF;
    disableWrongCharacterF();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Center(child: Text('Gợi ý'),),
        content: Container(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 15,),
                  Text('Mở một chữ cái'),
                  Container(height: 25,),
                  Text('Loại bỏ chữ cái sai'),
                  Container(height: 30,),
                  Text('Đáp án'),
                ],
              ),
              Container(width: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppButton(
                    widget.openCharacter + '  ',
                    type:ButtonType.outline,
                    icon: Icon(Icons.attach_money),
                    onPressed: () {
                      openCharacter();
                    },
                  ),
                  AppButton(
                    widget.disableWrongCharacter,
                    type:ButtonType.outline,
                    icon: Icon(Icons.attach_money),
                    onPressed: () {
                      disableWrongCharacter();
                    },
                  ),
                  AppButton(
                    widget.openAnswer,
                    type:ButtonType.outline,
                    icon: Icon(Icons.attach_money),
                    onPressed: () {
                      openAnswer();
                    },
                  )
                ],
              ),

            ],
          ),
        )
    );
  }
}
