import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:snapkit/snapkit.dart';
import 'package:unknown/Providers/theme_provider.dart';
import 'package:unknown/Screens/NewSnapScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Mainscreen.dart';

class HomeScreen extends StatefulWidget {
  SnapchatUser snapchatUser;
  HomeScreen({@required this.snapchatUser});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd myBanner;
  List messages = [];
  int indexx = 0;
  bool white = true;
  ScreenshotController screenshotController = ScreenshotController();
  //File images;
  Snapkit snapkit = new Snapkit();
  List<Widget> themes = [
    Image.asset(
      "Assets/Images/1.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/2.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/3.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/4.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/5.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/6.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/7.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/8.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/9.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/10.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/11.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/12.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/13.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/14.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
    Image.asset(
      "Assets/Images/15.jpg",
      height: 200,
      fit: BoxFit.cover,
    ),
  ];

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-3940256099942544/6300978111",
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    )..load();
  }

  gettingmessages() {
    print(widget.snapchatUser.externalId);
    FirebaseFirestore.instance
        .collection("messages")
        .orderBy("date", descending: true)
        .get()
        .then((value) {
      print(value.docs.length);
      for (var data in value.docs) {
        if (data["id"] == widget.snapchatUser.externalId) messages.add(data);
      }
      setState(() {});
    });
  }

  remove(String message, String user, int index) {
    messages.removeAt(index);
    setState(() {});
    FirebaseFirestore.instance
        .collection('messages')
        .where('message', isEqualTo: message)
        .where('id', isEqualTo: user)
        .get()
        .then((querySnapshot) {
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((documentSnapshot) {
        documentSnapshot.reference.delete();
      });
    });
  }

  gettingtoken() async {
    FirebaseMessaging.instance.getToken().then((String token) async {
      print("gettingtoken");

      FirebaseFirestore.instance
          .collection("tokens")
          .doc(widget.snapchatUser.externalId)
          .set({"token": token, "user": widget.snapchatUser.externalId});
    });
  }

  @override
  void initState() {
    gettingmessages();
    gettingtoken();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    var providerfunc = Provider.of<ThemeProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        return SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: provider.dark ? Colors.black : Color(0xffe6e6e6),
        appBar: AppBar(
          backgroundColor: Color(0xffFCFE35),
          centerTitle: true,
          shadowColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 270,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              // height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(children: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await launch("https://www.unknownapp.net");
                                  },
                                  child: Text(
                                    "✍️ Your Suggestions",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Divider(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "👻 Refresh Bitmoji",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Divider(),
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("tokens")
                                        .doc(widget.snapchatUser.externalId)
                                        .delete()
                                        .then((value) {
                                      snapkit.logout();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()));
                                    });
                                  },
                                  child: Text(
                                    "🌙 Logout",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              // height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          ]),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.transparent,
              );
            },
            child: Image.network(
              widget.snapchatUser.bitmojiUrl,
              height: 70,
            ),
          ),
          title: Text(
            widget.snapchatUser.displayName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {
            //     /// print("Hello");
            //     snapkit.logout();
            //     Navigator.pop(context);
            //     // providerfunc.toggleTheme(provider.dark ? false : true);
            //   },
            //   icon: Icon(
            //     Icons.logout_outlined,
            //     size: 30,
            //     color: Colors.black,
            //   ),
            // ),
            IconButton(
              onPressed: () {
                providerfunc.toggleTheme(provider.dark ? false : true);
              },
              icon: Icon(
                provider.dark ? CupertinoIcons.sun_min : CupertinoIcons.moon,
                size: 35,
                color: Colors.black,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xffFCFE35),
          shape: CircularNotchedRectangle(),
          notchMargin: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewSnapScreen(
                  snapchatUser: widget.snapchatUser,
                ),
              ),
            );
          },
          child: Image.asset(
            "Assets/Images/plus.png",
            height: 90,
          ),
        ),
        // backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [],
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffFCFE35),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
                      child: messages.length != 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 20,
                                right: 20,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.transparent,
                                    child: AdWidget(ad: myBanner),
                                    height: 50,
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          color: provider.dark
                                              ? Colors.white
                                              : Colors.black,
                                        );
                                      },
                                      itemCount: messages.length,

                                      // crossAxisSpacing: 15,
                                      // mainAxisSpacing: 15,
                                      itemBuilder: (context, index) {
                                        return Dismissible(
                                          key: UniqueKey(),
                                          direction:
                                              DismissDirection.endToStart,
                                          background: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFF7575),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              children: [
                                                Spacer(),
                                                Icon(Icons.delete)
                                              ],
                                            ),
                                          ),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            remove(messages[index]["message"],
                                                messages[index]["id"], index);
                                          },
                                          child: ListTile(
                                            title: Text(
                                              messages[index]["message"],
                                              style: TextStyle(
                                                  color: provider.dark
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            subtitle: Text(
                                              DateFormat("yyyy-MM-dd hh:mm a")
                                                  .format(DateTime.parse(
                                                      messages[index]["date"])),
                                              style: TextStyle(
                                                  color: provider.dark
                                                      ? Colors.white
                                                      : Colors.grey),
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0))),
                                                        child: Stack(
                                                          overflow:
                                                              Overflow.visible,
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Positioned(
                                                              top: -25,
                                                              left: 0,
                                                              child: Container(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3,
                                                                      left: 3,
                                                                      right: 3,
                                                                      bottom:
                                                                          30),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Anonymous message sent to ",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      Image
                                                                          .network(
                                                                        widget
                                                                            .snapchatUser
                                                                            .bitmojiUrl,
                                                                        height:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Screenshot(
                                                              controller:
                                                                  screenshotController,
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  // Container(
                                                                  //   height: 300,
                                                                  // ),
                                                                  Container(
                                                                    height: 250,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      color: Colors
                                                                          .yellow,
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      child: themes[
                                                                          indexx],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 10,
                                                                    right: 10,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                            messages[index][
                                                                                "message"],
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                            )),
                                                                        Divider(
                                                                          thickness:
                                                                              2,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        TextField(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(color: white ? Colors.white : Colors.black),
                                                                          cursorColor: white
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                          decoration: InputDecoration(
                                                                              border: InputBorder.none,
                                                                              hintText: "Write Here",
                                                                              hintStyle: TextStyle(
                                                                                color: white ? Colors.white : Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 0,
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  print(
                                                                      "Capturing");
                                                                  screenshotController
                                                                      .capture()
                                                                      .then((Uint8List
                                                                          image) async {
                                                                    final directory =
                                                                        await getApplicationDocumentsDirectory();
                                                                    final imagePath =
                                                                        await File('${directory.path}.png')
                                                                            .create();
                                                                    final Uint8List
                                                                        pngBytes =
                                                                        image
                                                                            .buffer
                                                                            .asUint8List();
                                                                    await imagePath
                                                                        .writeAsBytes(
                                                                            pngBytes);

                                                                    snapkit
                                                                        .share(
                                                                      SnapchatMediaType
                                                                          .NONE,
                                                                      // image: NetworkImage(
                                                                      //     'https://picsum.photos/${(this.context.size.width.round())}/${this.context.size.height.round()}.jpg'),

                                                                      sticker:
                                                                          SnapchatSticker(
                                                                              image: FileImage(
                                                                        File(imagePath
                                                                            .path),
                                                                      )),
                                                                      caption:
                                                                          "",
                                                                      attachmentUrl:
                                                                          "https://www.unknownapp.net",
                                                                    );
                                                                  }).catchError(
                                                                          (onError) {
                                                                    print(
                                                                        onError);
                                                                  });
                                                                },
                                                                child: Text(
                                                                    "Replay",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: -30,
                                                              left: 0,
                                                              right: 0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor: provider.dark
                                                                            ? Colors.black
                                                                            : Color(0xffe6e6e6),
                                                                        radius:
                                                                            31,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          //print("Hello");
                                                                          if (indexx ==
                                                                              themes.length - 1) {
                                                                            indexx =
                                                                                0;
                                                                          } else {
                                                                            indexx =
                                                                                indexx + 1;
                                                                          }
                                                                          // print(index);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: Image
                                                                            .asset(
                                                                          "Assets/Images/theme.png",
                                                                          height:
                                                                              80,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // SizedBox(
                                                                  //     width: 20),

                                                                  SizedBox(
                                                                      width:
                                                                          20),
                                                                  Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor: provider.dark
                                                                            ? Colors.black
                                                                            : Color(0xffe6e6e6),
                                                                        radius:
                                                                            30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          white =
                                                                              !white;
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: Image
                                                                            .asset(
                                                                          "Assets/Images/color.png",
                                                                          height:
                                                                              80,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: RotatedBox(
                                                quarterTurns: 3,
                                                child: Image.asset(
                                                  "Assets/Images/arrowd.png",
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.asset(
                                  provider.dark
                                      ? "Assets/Images/messaged.png"
                                      : "Assets/Images/message.png",
                                  height: 300,
                                ),
                                Text(
                                  "There are no messages",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: provider.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewSnapScreen(
                                          snapchatUser: widget.snapchatUser,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Start receiving messages now",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      decoration: BoxDecoration(
                          color:
                              provider.dark ? Colors.black : Color(0xffe6e6e6),
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(80))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
