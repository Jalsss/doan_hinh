import 'package:doan_hinh/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpDialog extends StatefulWidget {
  final String openCharacter;
  final String openAnswer;
  final String disableWrongCharacter;
  final bool isDisableWrongCharacter;
  final Function() openCharacterF;
  final Function() openAnswerF;
  final Function() disableWrongCharacterF;
  final Function() shareOnFaceBook;

  HelpDialog(
      {Key key,
      this.openCharacter,
      this.openAnswer,
      this.disableWrongCharacter,
      this.openCharacterF,
      this.disableWrongCharacterF,
      this.openAnswerF,
      this.isDisableWrongCharacter,
      this.shareOnFaceBook})
      : super(key: key);

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
  shareOnFaceBook() {
    var shareOnFaceBook = widget.shareOnFaceBook;
    shareOnFaceBook();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))
    ),
        //title: Center(child: Text('Gợi ý'),),
        content: Stack(
            alignment: Alignment.center, children: <Widget>[
          Image.asset('assets/images/box-2.png',
              height: 300,
              width:MediaQuery.of(context).size.width *
                  1,
              fit: BoxFit.fill),
          Container(
            height: 400,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.topRight, children: <Widget>[
                    Stack(alignment: Alignment.topCenter, children: <Widget>[
                      Image.asset('assets/images/ribbon-popup.png',
                          fit: BoxFit.fill),
                      Text('Gợi ý',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Chalkboard SE',
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ]),
                    SizedBox(
                        width: 40,
                        child: TextButton(
                          child: Image.asset('assets/images/close-popup.png',
                            width: 40,),
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
                          Navigator.of(context, rootNavigator: true).pop()
                          },
                        )),
                  ]),
                  Container(height: 10,),
                  Stack(alignment: Alignment.topCenter, children: <Widget>[
                    Image.asset('assets/images/box-1.png', fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width *
                      0.75,height: 45,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mở một chữ cái',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Chalkboard SE',
                                  color: Colors.brown.shade900,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: TextButton(
                                child: Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/button-popup.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                      ),
                                      Center(
                                          child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                      widget.disableWrongCharacter
                                                              .toString() +
                                                          " xu ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'Chalkboard SE')),
                                                  Image.asset(
                                                    'assets/images/coin-popup.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  )
                                                ],
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 6, 0))),
                                    ]),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                ),
                                onPressed: () => {disableWrongCharacter()},
                              )),
                        ],
                      ),
                    )
                  ]),
                  Container(height: 10,),
                  Stack(alignment: Alignment.topCenter, children: <Widget>[
                    Image.asset('assets/images/box-1.png', fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width *
                        0.75,height: 45,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Loại bỏ chữ cái sai',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Chalkboard SE',
                                  color: Colors.brown.shade900,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: TextButton(
                                child: Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/button-popup.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                      ),
                                      Center(
                                          child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                      widget.openCharacter
                                                              .toString() +
                                                          " xu ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'Chalkboard SE')),
                                                  Image.asset(
                                                    'assets/images/coin-popup.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  )
                                                ],
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 6, 0))),
                                    ]),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                ),
                                onPressed: () => {openCharacter()},
                              )),
                        ],
                      ),
                    )
                  ]),
                  Container(height: 10,),
                  Stack(alignment: Alignment.topCenter, children: <Widget>[
                    Image.asset('assets/images/box-1.png', fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width *
                          0.75,height: 45,),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Đáp án',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Chalkboard SE',
                                    color: Colors.brown.shade900,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.21,
                                child: TextButton(
                                  child: Stack(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/images/button-popup.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                        ),
                                        Center(
                                            child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        widget.openAnswer
                                                                .toString() +
                                                            " xu ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Chalkboard SE')),
                                                    Image.asset(
                                                      'assets/images/coin-popup.png',
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    )
                                                  ],
                                                ),
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 6, 0))),
                                      ]),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  ),
                                  onPressed: () => {openAnswer()},
                                )),
                          ],
                        )
                    )
                  ]
                  ),
                  Container(height: 10,),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.21,
                      child: TextButton(
                        child: Stack(
                            alignment:
                            AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/nut.png',
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.30,
                              ),
                              Center(
                                  child: Container(
                                      child:
                                          Text('Chia sẻ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19,
                                                  fontFamily:
                                                  'Chalkboard SE')),
                                      margin: EdgeInsets.fromLTRB(
                                          6, 0, 6, 0))),
                            ]),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        ),
                        onPressed: () => {
                          shareOnFaceBook()
                        },
                      ))
                ]
            ),
          )
        ]));
  }
}
