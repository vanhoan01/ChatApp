import 'dart:async';

import 'package:camera/camera.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
// import 'package:chatapp/View/CallkitIncoming/AppRoute.dart';
import 'package:chatapp/View/CallkitIncoming/NavigationService.dart';
import 'package:chatapp/View/ChatPage/Screens/VideoCallScreen.dart';
import 'package:chatapp/View/Pages/LoadingPage.dart';
import 'package:chatapp/View/Screens/CameraScreen.dart';
import 'package:chatapp/View/Screens/Homescreen.dart';
import 'package:chatapp/View/Screens/LoginScreen.dart';
import 'package:chatapp/ViewModel/Profile/UserViewModel.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_callkit_incoming/entities/entities.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//https://github.com/hiennguyen92/flutter_callkit_incoming/blob/master/example/lib/main.dart
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   showCallkitIncoming(Uuid().v4());
// }

// Future<void> showCallkitIncoming(String uuid) async {
//   final params = CallKitParams(
//     id: uuid,
//     nameCaller: 'Hien Nguyen',
//     appName: 'Callkit',
//     avatar: 'https://i.pravatar.cc/100',
//     handle: '0123456789',
//     type: 0,
//     duration: 30000,
//     textAccept: 'Accept',
//     textDecline: 'Decline',
//     textMissedCall: 'Missed call',
//     textCallback: 'Call back',
//     extra: <String, dynamic>{'userId': '1a2b3c4d'},
//     headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
//     android: AndroidParams(
//       isCustomNotification: true,
//       isShowLogo: false,
//       isShowCallback: true,
//       isShowMissedCallNotification: true,
//       ringtonePath: 'system_ringtone_default',
//       backgroundColor: '#0955fa',
//       backgroundUrl: 'assets/bg.png',
//       actionColor: '#4CAF50',
//     ),
//     ios: IOSParams(
//       // iconName: 'CallKitLogo',
//       handleType: '',
//       supportsVideo: true,
//       maximumCallGroups: 2,
//       maximumCallsPerCallGroup: 1,
//       audioSessionMode: 'default',
//       audioSessionActive: true,
//       audioSessionPreferredSampleRate: 44100.0,
//       audioSessionPreferredIOBufferDuration: 0.005,
//       supportsDTMF: true,
//       supportsHolding: true,
//       supportsGrouping: false,
//       supportsUngrouping: false,
//       ringtonePath: 'system_ringtone_default',
//     ),
//   );
//   await FlutterCallkitIncoming.showCallkitIncoming(params);
// }

///
///
///Notification
///
///

int id = 1;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

///
///
///Notification
///
///

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  // await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          defaultTargetPlatform == TargetPlatform.android
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // String initialRoute = HomePage.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
    // initialRoute = SecondPage.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    // defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget page = LoadingPage();
  final storage = const FlutterSecureStorage();
  late final Uuid _uuid;
  String? _currentUuid;

  // late final FirebaseMessaging _firebaseMessaging;
  bool _notificationsEnabled = false;
  late IO.Socket socket;

  String? caller;
  String? creceiver;

  @override
  void initState() {
    super.initState();
    checkLogin();
    _uuid = Uuid();
    // initFirebase();
    connectSocket();
    WidgetsBinding.instance.addObserver(this);
    //Check call when open app from terminated
    // checkAndNavigationCallingPage();
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      setState(() {
        _notificationsEnabled = granted ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(NavigationService
                            .instance.navigationKey.currentContext ??
                        context)
                    .push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => VideoCallScreen(
                      caller: caller ?? "",
                      creceiver: creceiver ?? "",
                      callStatus: false,
                    ),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(
              NavigationService.instance.navigationKey.currentContext ??
                  context)
          .push(MaterialPageRoute<void>(
        builder: (BuildContext context) => VideoCallScreen(
          caller: caller ?? "",
          creceiver: creceiver ?? "",
          callStatus: false,
        ),
      ));
    });
  }

  Future<void> connectSocket() async {
    UserViewModel userViewModel = UserViewModel();
    UserModel userModel = await userViewModel.getUserModel();
    socket = IO.io(AppUrl.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    // ignore: await_only_futures
    socket.connect();
    socket.emit("signin", userModel.userName);
    socket.onConnect((data) {
      // ignore: avoid_print
      print("Connected");
      socket.on("calling", (msg) async {
        // ignore: avoid_print
        print("Nhận cuộc gọi: ${msg[0]}");
        // NavigationService.instance
        //   .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
        setState(() {
          caller = msg[1];
          creceiver = msg[0];
        });
        await _showNotificationWithActions();
        // Navigator.push(
        //   NavigationService.instance.navigationKey.currentContext ?? context,
        //   MaterialPageRoute(
        //     builder: (context) => VideoCallScreen(
        //       caller: msg[1],
        //       creceiver: msg[0],
        //       callStatus: false,
        //     ),
        //   ),
        // );
      });
    });
  }

  void checkLogin() async {
    String? token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = const Homescreen();
      });
    } else {
      setState(() {
        page = const LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primaryColor: const Color(0xFF075E54),
        colorScheme: const ColorScheme(
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
      home: page,
      // onGenerateRoute: AppRoute.generateRoute,
      // initialRoute: AppRoute.homePage,
      navigatorKey: NavigationService.instance.navigationKey,
      navigatorObservers: <NavigatorObserver>[
        NavigationService.instance.routeObserver
      ],
    );
  }

  // getCurrentCall() async {
  //   //check current call from pushkit if possible
  //   var calls = await FlutterCallkitIncoming.activeCalls();
  //   if (calls is List) {
  //     if (calls.isNotEmpty) {
  //       print('DATA: $calls');
  //       _currentUuid = calls[0]['id'];
  //       return calls[0];
  //     } else {
  //       _currentUuid = "";
  //       return null;
  //     }
  //   }
  // }

  // checkAndNavigationCallingPage() async {
  //   var currentCall = await getCurrentCall();
  //   if (currentCall != null) {
  //     NavigationService.instance
  //         .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
  //   }
  // }

  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   print(state);
  //   if (state == AppLifecycleState.resumed) {
  //     //Check call when open app from background
  //     checkAndNavigationCallingPage();
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  // initFirebase() async {
  //   await Firebase.initializeApp();
  //   _firebaseMessaging = FirebaseMessaging.instance;
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print(
  //         'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
  //     _currentUuid = _uuid.v4();
  //     showCallkitIncoming(_currentUuid!);
  //   });
  //   _firebaseMessaging.getToken().then((token) {
  //     print('Device Token FCM: $token');
  //   });
  // }

  // Future<void> getDevicePushTokenVoIP() async {
  //   var devicePushTokenVoIP =
  //       await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  //   print(devicePushTokenVoIP);
  // }

  Future<void> _showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'id_channel_01',
      'name_channel_01',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          urlLaunchActionId,
          'Action 1',
          icon: DrawableResourceAndroidBitmap('food'),
          contextual: true,
        ),
        AndroidNotificationAction(
          navigationActionId,
          'Action 3',
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
          showsUserInterface: true,
          // By default, Android plugin will dismiss the notification when the
          // user tapped on a action (this mimics the behavior on iOS).
          cancelNotification: false,
        ),
      ],
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const DarwinNotificationDetails macOSNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: urlLaunchActionId,
          label: 'Action 1',
        ),
        LinuxNotificationAction(
          key: navigationActionId,
          label: 'Action 2',
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: macOSNotificationDetails,
      linux: linuxNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item z');
  }
}
// flutter pub run build_runner build
// chinh ip metwwork_handler.dart
// flutter run lib/main.dart