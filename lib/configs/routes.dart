import 'package:doan_hinh/screens/gamesScreen/end_question.dart';
import 'package:doan_hinh/screens/gamesScreen/game_screen.dart';
import 'package:doan_hinh/screens/home/home.dart';
import 'package:doan_hinh/screens/home/loading_screen.dart';
import 'package:doan_hinh/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = "/home";
  static const String signIn = "/signIn";
  static const String gameScreen = "/game_screen";
  static const String endQuestion = "/end_question";
  static const String loadingScreen = "/loading_screen";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn();
          },
          fullscreenDialog: true,
        );
      case home:
        return MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        );
      case gameScreen:
        return MaterialPageRoute(
          builder: (context) {
            return GameScreen();
          },
        );
      case endQuestion:
        return MaterialPageRoute(
          builder: (context) {
            return EndQuestion();
          },
        );

      case loadingScreen:
        return MaterialPageRoute(
          builder: (context) {
            return LoadingScreen();
          },
        );
      // case themeSetting:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return ThemeSetting();
      //     },
      //   );
      // case setting:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return Setting();
      //     },
      //   );
      // case fontSetting:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return FontSetting();
      //     },
      //   );
      //
      // case pickerScreen:
      //   final picker = settings.arguments;
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return PickerScreen(picker: picker);
      //     },
      //     fullscreenDialog: true,
      //   );
      //
      // case webView:
      //   final web = settings.arguments;
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return WebViewPage(
      //         web: web,
      //       );
      //     },
      //     fullscreenDialog: true,
      //   );

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for '),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
