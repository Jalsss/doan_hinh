
import 'package:doan_hinh/screens/signin/signin.dart';
import 'package:flutter/material.dart';

import 'configs/routes.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final route = Routes();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
       // future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          return MaterialApp(home : SignIn());
    });
  }
}
