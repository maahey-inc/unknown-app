import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapkit/snapkit.dart';
import 'package:unknown/Providers/theme_provider.dart';
import 'package:unknown/Screens/HomeScreen.dart';
import 'package:unknown/Services/local_notification_service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Snapkit _snapkit = Snapkit();
  SnapchatUser _snapchatUser;
  StreamSubscription<SnapchatUser> subscription;

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print(message);
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(snapchatUser: _snapchatUser)));
        print(message.notification.body);
        print(message.notification.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(snapchatUser: _snapchatUser)));
    });
    checktheme();
    //initPlatformState();

    // _snapkit.addAuthStateListener(this);

    subscription = _snapkit.onAuthStateChanged.listen((SnapchatUser user) {
      setState(() {
        _snapchatUser = user;
      });
      if (_snapchatUser != null) {
        FirebaseFirestore.instance
            .collection("user")
            .doc(_snapchatUser.externalId)
            .set({
          "name": _snapchatUser.displayName,
          "id": _snapchatUser.externalId,
          "image": _snapchatUser.bitmojiUrl
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              snapchatUser: _snapchatUser,
            ),
          ),
        );
      }
    });
  }

  checktheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("dark")) {
      Provider.of<ThemeProvider>(context, listen: false)
          .toggleTheme(prefs.getBool("dark"));
    }
  }

  Future<void> loginUser() async {
    //  print("Logging in");
    try {
      bool installed = await _snapkit.isSnapchatInstalled;
      if (installed) {
        await _snapkit.login();
        print("Loggin in");
        if (_snapchatUser != null) {
          print(_snapchatUser.externalId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                snapchatUser: _snapchatUser,
              ),
            ),
          );
        }
        //    print("Logging in");
        // try {

        // } on PlatformException catch (exception) {
        //   print(exception);
        // }
      } else {
        print("App not Installed");
        // _isSnackOpen = true;
        // _scaffoldMessengerKey.currentState!
        //     .showSnackBar(
        //         SnackBar(content: Text('Snapchat App not Installed.')))
        //     .closed
        //     .then((_) {
        //   _isSnackOpen = false;
        // });
      }
    } on PlatformException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Color(0xffFCFE35),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "Assets/Images/logo.png",

                      // height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        loginUser();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HomeScreen(),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Text(
                              "Login with Snapchat",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Image.asset(
                              "Assets/Images/snap.png",
                              height: 50,
                            )
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        //elevation: 5.0,

                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xffFCFE35)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(width: 6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "By Registration to the application, you agree to the terms and conditions and privacy policy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
