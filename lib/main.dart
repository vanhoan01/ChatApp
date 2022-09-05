import 'package:camera/camera.dart';
import 'package:chatapp/Screens/CameraScreen.dart';
import 'package:chatapp/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primaryColor: Color(0xFF075E54),
        // colorScheme:
        //     ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF128C7E)),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF075E54),
          onPrimary: Colors.white,
          secondary: Color(0xFF128C7E),
          onSecondary: Colors.white,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.white,
          error: Colors.white,
          onError: Colors.white,
        ),
      ),
      home: LoginScreen(),
    );
  }
}
