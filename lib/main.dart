import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:unknown/Providers/theme_provider.dart';
import 'package:unknown/Screens/Mainscreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => Unknown(), // Wrap your app
    ),
  );
}

class Unknown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Unknown',
          home: MainScreen(),
          // themeMode: ThemeMode.light,
          //theme: MyThemes.lightTheme,
          //darkTheme: MyThemes.darkTheme,
        );
      },
    );
  }
}
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState
//     extends State<MyApp> /* implements SnapchatAuthStateListener */ {
//   GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>();

//   String _platformVersion = 'Unknown';
//   SnapchatUser? _snapchatUser;
//   Snapkit _snapkit = Snapkit();

//   TextEditingController _regionController = TextEditingController(text: 'US');
//   TextEditingController _phoneController =
//       TextEditingController(text: '0001234567');

//   late StreamSubscription<SnapchatUser?> subscription;

//   bool _isSnackOpen = false;

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();

  //   // _snapkit.addAuthStateListener(this);

  //   subscription = _snapkit.onAuthStateChanged.listen((SnapchatUser? user) {
  //     setState(() {
  //       _snapchatUser = user;
  //     });
  //   });
  // }

//   @override
//   void dispose() {
//     super.dispose();
//     subscription.cancel();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await Snapkit.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

  // Future<void> loginUser() async {
  //   //  print("Logging in");
  //   try {
  //     bool installed = await _snapkit.isSnapchatInstalled;
  //     if (installed) {
  //       //    print("Logging in");
  //       try {
  //         await _snapkit.login();
  //       } on PlatformException catch (exception) {
  //         print(exception);
  //       }
  //     } else if (!_isSnackOpen) {
  //       _isSnackOpen = true;
  //       _scaffoldMessengerKey.currentState!
  //           .showSnackBar(
  //               SnackBar(content: Text('Snapchat App not Installed.')))
  //           .closed
  //           .then((_) {
  //         _isSnackOpen = false;
  //       });
  //     }
  //   } on PlatformException catch (exception) {
  //     print(exception);
  //   }
  // }

//   Future<void> logoutUser() async {
//     try {
//       await _snapkit.logout();
//     } on PlatformException catch (exception) {
//       print(exception);
//     }

//     setState(() {
//       _snapchatUser = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: ScaffoldMessenger(
//       key: _scaffoldMessengerKey,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Snapkit Example App'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_snapchatUser != null)
//                 Container(
//                     width: 50,
//                     height: 50,
//                     margin: EdgeInsets.all(15),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.lightBlue,
//                       foregroundImage: NetworkImage(_snapchatUser!.bitmojiUrl),
//                     )),
//               if (_snapchatUser != null) Text(_snapchatUser!.displayName),
//               if (_snapchatUser != null)
//                 Text(_snapchatUser!.externalId,
//                     style: TextStyle(color: Colors.grey, fontSize: 9.0)),
//               Text('Running on: $_platformVersion\n'),
//               if (_snapchatUser == null)
//                 TextButton(
//                     onPressed: () {
//                       loginUser();
//                     },
//                     child: Text("Login")),
//               // Container(
//               //   padding: EdgeInsets.only(left: 8.0, right: 8.0),
//               //   child: _snapkit.snapchatButton,
//               // ),
//               if (_snapchatUser != null)
//                 TextButton(
//                     onPressed: () => logoutUser(), child: Text('Logout')),
//               Container(
//                 margin: EdgeInsets.only(top: 16.0),
//                 child: Row(
//                   children: [
//                     Spacer(),
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: 25),
//                       child: TextField(
//                         controller: _regionController,
//                         keyboardType: TextInputType.text,
//                       ),
//                     ),
//                     Spacer(),
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: 150),
//                       child: TextField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                       ),
//                     ),
//                     Spacer(),
//                     TextButton(
//                       onPressed: () => _snapkit
//                           .verifyPhoneNumber(
//                             _regionController.text,
//                             _phoneController.text,
//                           )
//                           .then((isVerified) => _scaffoldMessengerKey
//                               .currentState
//                               ?.showSnackBar(SnackBar(
//                                   content: Text(
//                                       'Phone Number is ${isVerified ? '' : 'not '}verified'))))
//                           .catchError((error, StackTrace stacktrace) {
//                         _scaffoldMessengerKey.currentState?.showSnackBar(
//                             SnackBar(
//                                 content: Text(
//                                     (error as PlatformException).details)));
//                       }),
//                       child: Text('Verify'),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
            // _snapkit.share(SnapchatMediaType.PHOTO,
            //     image: NetworkImage(
            //         'https://picsum.photos/${(this.context.size!.width.round())}/${this.context.size!.height.round()}.jpg'),
            //     sticker: SnapchatSticker(
            //         image: Image.asset('images/icon-256x256.png').image),
            //     caption: 'Snapkit Example Caption!',
            //     attachmentUrl: 'https://JacobBrasil.com/');
//           },
//           child: Icon(Icons.camera),
//         ),
//       ),
//     ));
//   }

//   // @override
//   // void onLogin(SnapchatUser user) {
//   //   setState(() {
//   //     _snapchatUser = user;
//   //   });
//   // }

//   // @override
//   // void onLogout() {
//   //   setState(() {
//   //     _snapchatUser = null;
//   //   });
//   // }
// }
