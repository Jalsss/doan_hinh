import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:flutter/material.dart';


class EndQuestion extends StatefulWidget {
  @override
  _EndQuestion createState() => _EndQuestion();
}

class _EndQuestion extends State<EndQuestion> {
  final route = Routes();

  var isSignIn;

  @override
  void initState() {
    super.initState();
  }

  back(String routes) {
    Navigator.pushReplacementNamed(context, routes);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/bg-main.png"),
    fit: BoxFit.cover,
    ),
    ),
    child:Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Center(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                        'Chúc mừng bạn đã vượt qua tất cả các câu hỏi, vui lòng chờ bản cập nhật mới của chúng tôi!',
                          textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontFamily: 'Chalkboard SE'),),
                    Container(height: 40,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: TextButton(
                          child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/button2-popup.png',
                                  width:
                                  MediaQuery.of(context).size.width * 0.6,
                                  fit: BoxFit.fill,
                                ),
                                Center(
                                    child: Container(
                                        child: Text('Trang chủ',
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    '#ffffff'),
                                                fontSize:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.06,
                                                fontFamily: 'Chalkboard SE',
                                                fontWeight: FontWeight.w500)),
                                        margin:
                                        EdgeInsets.fromLTRB(6, 0, 6, 0))),
                              ]),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          onPressed: () async => {
                            back(Routes.home)
                          },
                        )),
                  ],
    ))))
    )   ;
  }
}
