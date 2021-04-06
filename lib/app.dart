import 'package:doan_hinh/screens/home/home.dart';
import 'package:doan_hinh/screens/signin/signin.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'configs/routes.dart';

final _storage = new LocalStorage();
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final route = Routes();

  var isSignIn;
  @override
  void initState() {
    super.initState();
    getSign();
  }

  getSign() async {
    isSignIn = await _storage.readValue('isSignIn');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if(isSignIn == null) {
            return MaterialApp(
                onGenerateRoute: route.generateRoute,
                home : SignIn());
          } else {
                return MaterialApp(
                onGenerateRoute: route.generateRoute,
                home : Home());
          }
    });
  }
}
