import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuDialog extends StatefulWidget {
  final Function() tutorial;
  final Function() armorial;
  final Function() achievements;
  final Function() shareOnFaceBook;
  final Function() closeDialog;
  final Function() voteGames;

  MenuDialog(
      {Key key,
      this.tutorial,
      this.achievements,
      this.armorial,
      this.shareOnFaceBook,
      this.closeDialog,
      this.voteGames})
      : super(key: key);

  @override
  _MenuDialog createState() {
    return _MenuDialog();
  }
}

class _MenuDialog extends State<MenuDialog> {
  tutorial() {
    var tutorial = widget.tutorial;
    tutorial();
    Navigator.of(context, rootNavigator: true).pop();
  }

  armorial() {
    var armorial = widget.armorial;
    armorial();
    Navigator.of(context, rootNavigator: true).pop();
  }

  achievements() {
    var achievements = widget.achievements;
    achievements();
    Navigator.of(context, rootNavigator: true).pop();
  }

  voteGames() {
    var voteGames = widget.voteGames;
    voteGames();
    Navigator.of(context, rootNavigator: true).pop();
  }

  shareOnFaceBook() {
    var shareOnFaceBook = widget.shareOnFaceBook;
    shareOnFaceBook();
  }

  closeDialog() {
    var closeDialog = widget.closeDialog;
    closeDialog();
    Navigator.of(context, rootNavigator: true).pop();
  }

  bool isIpad = false;

  @override
  void initState() {
    super.initState();
    getPlatform();
  }

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        //title: Center(child: Text('Gợi ý'),),
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Image.asset('assets/images/box-2.png',
              height: isIpad ? MediaQuery.of(context).size.height * 0.55 : 350,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.fill),
          Container(
            height: isIpad ? MediaQuery.of(context).size.height * 0.7 : 460,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.topRight, children: <Widget>[
                    Stack(alignment: Alignment.topCenter, children: <Widget>[
                      Image.asset('assets/images/ribbon-popup.png',
                          fit: BoxFit.fill),
                      Text('Menu',
                          style: TextStyle(
                              fontSize: isIpad == true
                                  ? MediaQuery.of(context).size.width * 0.07
                                  : 30,
                              fontFamily: 'Chalkboard SE',
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ]),
                    SizedBox(
                        width: 40,
                        child: TextButton(
                          child: Image.asset(
                            'assets/images/close-popup.png',
                            width: 40,
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
                          onPressed: () => {closeDialog()},
                        )),
                  ]),
                  Container(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height:
                          isIpad ? MediaQuery.of(context).size.width * 0.1 : 50,
                      child: TextButton(
                        child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/box-1.png',
                                width: MediaQuery.of(context).size.width * 0.80,
                                fit: BoxFit.fill,
                                height: isIpad
                                    ? MediaQuery.of(context).size.width * 0.08
                                    : 70,
                              ),
                              Center(
                                  child:  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                      Image.asset('assets/images/heraldic.png'),
                                  Container(
                                      child: Text('Huy hiệu',
                                          style: TextStyle(
                                              color: Colors.brown.shade900,
                                              fontSize: isIpad
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05
                                                  : 20,
                                              fontFamily: 'Chalkboard SE')),
                                      margin: EdgeInsets.fromLTRB(6, 0, 6, 0)),
                                      Container()]
                                  )),
                            ]),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            padding: MaterialStateProperty.resolveWith(
                                (states) => EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            shadowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent)),
                        onPressed: () => {armorial()},
                      )),
                  Container(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height:
                          isIpad ? MediaQuery.of(context).size.width * 0.1 : 50,
                      child: TextButton(
                        child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/box-1.png',
                                width: MediaQuery.of(context).size.width * 0.80,
                                fit: BoxFit.fill,
                                height: isIpad
                                    ? MediaQuery.of(context).size.width * 0.08
                                    : 70,
                              ),
                              Center(
                                  child:  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                      Image.asset('assets/images/podium.png'),
                                  Container(
                                      child: Text('Bảng thành tích',
                                          style: TextStyle(
                                              color: Colors.brown.shade900,
                                              fontSize: isIpad
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05
                                                  : 20,
                                              fontFamily: 'Chalkboard SE')),
                                      margin: EdgeInsets.fromLTRB(6, 0, 6, 0)),
                                      Container()])),
                            ]),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            padding: MaterialStateProperty.resolveWith(
                                (states) => EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            shadowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent)),
                        onPressed: () => {achievements()},
                      )),
                  Container(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height:
                          isIpad ? MediaQuery.of(context).size.width * 0.1 : 50,
                      child: TextButton(
                        child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/box-1.png',
                                width: MediaQuery.of(context).size.width * 0.80,
                                fit: BoxFit.fill,
                                height: isIpad
                                    ? MediaQuery.of(context).size.width * 0.08
                                    : 70,
                              ),
                              Center(
                                  child:  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                      Image.asset('assets/images/rate.png'),
                                  Container(
                                      child: Text('Đánh giá trò chơi',
                                          style: TextStyle(
                                              color: Colors.brown.shade900,
                                              fontSize: isIpad
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05
                                                  : 20,
                                              fontFamily: 'Chalkboard SE')),
                                      margin: EdgeInsets.fromLTRB(6, 0, 6, 0)),
                              Container()
                              ])),
                            ]),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            padding: MaterialStateProperty.resolveWith(
                                (states) => EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            shadowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent)),
                        onPressed: () => {voteGames()},
                      )),
                  Container(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height:
                          isIpad ? MediaQuery.of(context).size.width * 0.1 : 50,
                      child: TextButton(
                        child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/box-1.png',
                                width: MediaQuery.of(context).size.width * 0.80,
                                fit: BoxFit.fill,
                                height: isIpad
                                    ? MediaQuery.of(context).size.width * 0.08
                                    : 70,
                              ),
                              Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('assets/images/employee.png'),
                                  Container(
                                      child: Text('Chia sẻ',
                                          style: TextStyle(
                                              color: Colors.brown.shade900,
                                              fontSize: isIpad
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05
                                                  : 20,
                                              fontFamily: 'Chalkboard SE')),
                                      margin: EdgeInsets.fromLTRB(6, 0, 6, 0)),
                                  Container()
                                ],
                              ))
                            ]),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            padding: MaterialStateProperty.resolveWith(
                                (states) => EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            shadowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent)),
                        onPressed: () => {shareOnFaceBook()},
                      )),
                ]),
          )
        ]));
  }
}
