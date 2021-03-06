import 'package:device_info/device_info.dart';
import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game_screen.dart';

class ArmorialDialog extends StatefulWidget {
  final List<Achievements> achievementsDiamond;
  final List<Achievements> achievementsGold;
  final List<Achievements> achievementsSilver;

  ArmorialDialog({
    Key key,
    this.achievementsDiamond,
    this.achievementsGold,
    this.achievementsSilver
  }) : super(key: key);

  @override
  _ArmorialDialog createState() {
    return _ArmorialDialog();
  }
}

class _ArmorialDialog extends State<ArmorialDialog> {
  closeDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget ListItems(List<Achievements> achievements) {
    List<Widget> list = List.generate(achievements.length, (index) {
      return ItemsInside(
          achievements[index].imagePath,
          achievements[index].name,
          achievements[index].level,
          achievements[index].coin,
          achievements[index].armorial);
    });

    return SingleChildScrollView(
      child: Stack(
          children: <Widget>[
      new Column(children: [
        Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: list,
      ),
    )])]));
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
  Widget ItemsInside(String imagePath, String name, String level, String coin,int armorial) {
    return Container(
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Image.asset(
          'assets/images/box-1.png',
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.75,
          height: isIpad ? MediaQuery.of(context).size.width *
              0.13:75,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      child: Stack(
                          alignment: armorial == 1 ? AlignmentDirectional.bottomCenter : AlignmentDirectional.center,
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: imagePath != null
                                    ? Image.network(imagePath,
                                    width: armorial == 1 ? MediaQuery.of(context).size.width *
                                        0.18 : MediaQuery.of(context).size.width * 0.20,
                                    height: MediaQuery.of(context).size.width *
                                        0.20,
                                    fit: BoxFit.fill)
                                    : Image.asset(
                                  'assets/images/meme-3.jpeg',
                                  width: MediaQuery.of(context).size.width *
                                      0.20,
                                )),
                                armorial == 1 ? Image.asset('assets/images/silver.png',width: MediaQuery.of(context).size.width *
                                    0.24,
                                    height: MediaQuery.of(context).size.width *
                                        0.23,
                                    fit: BoxFit.fill) : (
                                    armorial == 2 ? Image.asset('assets/images/gold.png',width: MediaQuery.of(context).size.width *
                                        0.23,
                                        height: MediaQuery.of(context).size.width *
                                            0.24,
                                        fit: BoxFit.fill ): (
                                        armorial == 3 ? Image.asset('assets/images/diamond.png',width: MediaQuery.of(context).size.width *
                                            0.23,
                                            height: MediaQuery.of(context).size.width *
                                                0.24,
                                            fit: BoxFit.fill) : Container()
                                    )
                                )

                          ])),
                  Container(
                    width: 2,
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
                              fontWeight: FontWeight.bold),
                          textWidthBasis: TextWidthBasis.parent),
                      Text('Level ' + level,
                          style: TextStyle(
                              fontSize: isIpad == true ? MediaQuery.of(context).size.width * 0.03 :18,
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
                width: isIpad ? MediaQuery.of(context).size.width *
                    0.1:70,
                height: isIpad ? MediaQuery.of(context).size.width *
                    0.13:80,
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
        //title: Center(child: Text('G???i ??'),),
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Image.asset('assets/images/box-2.png',
              height: isIpad ? MediaQuery.of(context).size.height *
                  0.65 :500,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.fill),
          Container(
            height: isIpad ? MediaQuery.of(context).size.height *
                0.75 :590,
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.topRight, children: <Widget>[
                    Stack(alignment: Alignment.topCenter, children: <Widget>[
                      Image.asset('assets/images/ribbon-popup.png',
                          fit: BoxFit.fill),
                      Text('Huy hi???u',
                          style: TextStyle(
                              fontSize: isIpad == true ? MediaQuery.of(context).size.width * 0.07 :35,
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
                  _tabSection(context)
                ]),
          )
        ]));
  }

  Widget _tabSection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(decoration: BoxDecoration(
              //This is for background color
                color: Colors.white.withOpacity(0.0),
                //This is for bottom border that is needed
                border: Border(bottom: BorderSide(color:HexColor.fromHex('#be784c'), width:1))),
                child: TabBar(
                  tabs: [
                    Tab(text: "Kim c????ng"),
                    Tab(text: "V??ng"),
                    Tab(text: "B???c"),
                  ],
                  indicatorColor: HexColor.fromHex('#e00000'),
                  labelColor: HexColor.fromHex('#e00000'),
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: isIpad == true ? MediaQuery.of(context).size.width * 0.03 :19,
                      fontFamily: 'Chalkboard SE',
                      fontWeight: FontWeight.bold),

                )
                ) ,


            Container(
              //Add this to give height
              height: isIpad == true ? MediaQuery.of(context).size.height * 0.38 :300,
              child: TabBarView(children: [
                ListItems(widget.achievementsDiamond),
                ListItems(widget.achievementsGold),
                ListItems(widget.achievementsSilver),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
