import 'package:doan_hinh/configs/routes.dart';
import 'package:doan_hinh/screens/home/home.dart';
import 'package:doan_hinh/screens/signin/signin.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:flutter/material.dart';

final _storage = new LocalStorage();

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
    return Scaffold(
        body: SafeArea(
            child: Center(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                        'Chúc mừng bạn đã vượt qua tất cả các câu hỏi, vui lòng chờ bản cập nhật mới của chúng tôi',
                          textAlign: TextAlign.center,style: TextStyle(fontSize: 17),),
                    TextButton(
                      child: Icon(Icons.home,size: 50,),
                      onPressed: () => {back(Routes.home)},
                    ),
                  ],
    ))));
  }
}
