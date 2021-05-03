import 'dart:io';

import 'package:doan_hinh/constant/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreen createState() {
    return _LoadingScreen();
  }
}

class _LoadingScreen extends State<LoadingScreen> {
  double percent = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading();
  }

  loading() async {
    setState(() {
      percent = 0;
    });
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      percent = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-loading.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Image.asset('assets/images/giphy.gif',width: MediaQuery.of(context).size.width * 0.8,),
            )));
  }
}
