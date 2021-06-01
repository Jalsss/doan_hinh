import 'package:doan_hinh/screens/gamesScreen/update_dialog.dart';
import 'package:doan_hinh/screens/home/home.dart';
import 'package:doan_hinh/screens/home/loading_screen.dart';
import 'package:doan_hinh/screens/signin/signin.dart';
import 'package:doan_hinh/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'configs/routes.dart';
import 'main.dart';

final _storage = new LocalStorage();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final route = Routes();

  var isSignIn;
  var loading = false;

  @override
  void initState() {
    super.initState();
    getSign();
  }

  getSign() async {
    var data = await _storage.readValue('isSignIn');
    setState(() {
      isSignIn = data;
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (isVersion) {
            if (isSignIn == null) {
              return MaterialApp(
                onGenerateRoute: route.generateRoute,
                home: SignIn(),
                debugShowCheckedModeBanner: false,
              );
            } else {
              return MaterialApp(
                onGenerateRoute: route.generateRoute,
                home: Home(),
                debugShowCheckedModeBanner: false,
              );
            }
          } else {
            return MaterialApp(home: MyDialog());
          }
        });
  }
}
