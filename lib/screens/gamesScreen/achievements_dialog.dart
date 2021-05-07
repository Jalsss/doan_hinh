import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game_screen.dart';

class AchievementsDialog extends StatefulWidget {
  final List<Achievements> achievements;

  AchievementsDialog({
    Key key,
    this.achievements,
  }) : super(key: key);

  @override
  _AchievementsDialog createState() {
    return _AchievementsDialog();
  }
}

class _AchievementsDialog extends State<AchievementsDialog> {
  closeDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget ListItems() {
    List<Widget> list = List.generate(widget.achievements.length, (index) {
      return ItemsInside(
          widget.achievements[index].imagePath,
          widget.achievements[index].name,
          widget.achievements[index].level,
          widget.achievements[index].coin,
          widget.achievements[index].armorial);
    });

    return Column(
      children: list,
    );
  }

  Widget ItemsInside(String imagePath, String name, String level, String coin,
      int armorial) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Image.asset(
          'assets/images/box-1.png',
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.75,
          height: 75,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(armorial >= 50 ? 0 : 7, 0, 12, 00),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      child: Stack(
                          alignment: armorial == 50 ? AlignmentDirectional.bottomCenter : AlignmentDirectional.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: imagePath != null
                                  ? Image.network(imagePath,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      height: MediaQuery.of(context).size.width *
                                          0.20,
                                      fit: BoxFit.fill)
                                  : Image.asset(
                                      'assets/images/meme-3.jpeg',
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                    )),
                            armorial < 50 ? Container() : (
                                armorial == 50 ? Image.asset('assets/images/silver.png',width: MediaQuery.of(context).size.width *
                                    0.26,
                                    height: MediaQuery.of(context).size.width *
                                        0.23,
                                    fit: BoxFit.fill) : (
                                    armorial == 150 ? Image.asset('assets/images/gold.png',width: MediaQuery.of(context).size.width *
                                        0.23,
                                        height: MediaQuery.of(context).size.width *
                                            0.24,
                                        fit: BoxFit.fill ): (
                                        armorial == 250 ? Image.asset('assets/images/diamond.png',width: MediaQuery.of(context).size.width *
                                            0.23,
                                            height: MediaQuery.of(context).size.width *
                                                0.24,
                                            fit: BoxFit.fill) : Container()
                                    )
                                )
                            )
                      ])),
                  Container(
                    width: 6,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05,
                              fontFamily: 'Chalkboard SE',
                              color: HexColor.fromHex('#884619'),
                              fontWeight: FontWeight.bold)),
                      Text('Level ' + level,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Chalkboard SE',
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(coin,
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Chalkboard SE',
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    Image.asset(
                      'assets/images/coin-popup.png',
                      width: MediaQuery.of(context).size.width * 0.05,
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)),
                  color: HexColor.fromHex('#b5b39a'),
                  boxShadow: [
                    BoxShadow(
                        color: HexColor.fromHex('#e8d6d0'), spreadRadius: 5),
                  ],
                ),
                width: 70,
                height: 80,
              ),
            ],
          ),
        )
      ]),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    );
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
              height: 440,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.fill),
          Container(
              height: 530,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.topRight, children: <Widget>[
                      Stack(alignment: Alignment.topCenter, children: <Widget>[
                        Image.asset('assets/images/ribbon-popup.png',
                            fit: BoxFit.fill),
                        Text('Thành tích',
                            style: TextStyle(
                                fontSize: 35,
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
                                    (states) =>
                                        EdgeInsets.fromLTRB(0, 0, 0, 0)),
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
                    Container(
                        height: 290,
                        child: SingleChildScrollView(
                            child: Stack(children: <Widget>[
                          new Column(children: [
                            ListItems(),
                          ])
                        ]))),
                  ]))
        ]));
  }
}
