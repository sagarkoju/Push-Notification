import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/green_page.dart';
import 'package:push_notification/red_page.dart';
import 'package:push_notification/service/local_notification_service.dart';

// recieve message when app is in background soln for messgae
Future<void> backgroundHandler(RemoteMessage messgae) async {
  // ignore: avoid_print
  print(messgae.data.toString());
  // ignore: avoid_print
  print(messgae.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
      routes: {
        "red": (_) => const RedPage(),
        "green": (_) => const GreenPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    /// gives you the message on which user taps and its open the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    /// work on the foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        // ignore: avoid_print
        print(message.notification!.body);
        // ignore: avoid_print
        print(message.notification!.title);
      }
      LocalNotificationService.display(message);
    });

    /// when the app is in background but opened and  user tap on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      Navigator.of(context).pushNamed(routeFromMessage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Text(
            'You will receive message  very soon',
            style: TextStyle(fontSize: 34),
          ),
        ),
      ),
    );
  }
}
