import 'package:chatapp/View/CallkitIncoming/CallingPage.dart';
import 'package:chatapp/View/CallkitIncoming/HomePage.dart';
import 'package:chatapp/View/ChatPage/Screens/VideoCallScreen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const homePage = '/home_page';

  static const callingPage = '/calling_page';

  static const videoCallScreen = '/videoCallScreen';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
            builder: (_) => HomePage(), settings: settings);
      case callingPage:
        return MaterialPageRoute(
            builder: (_) => CallingPage(), settings: settings);
      // case videoCallScreen:
      //   return MaterialPageRoute(
      //       builder: (_) => VideoCallScreen(callStatus: false, caller: ), settings: settings);
      default:
        return null;
    }
  }
}
