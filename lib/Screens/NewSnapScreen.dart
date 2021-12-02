import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:snapkit/snapkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unknown/Providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Mainscreen.dart';

class NewSnapScreen extends StatefulWidget {
  SnapchatUser snapchatUser;
  NewSnapScreen({@required this.snapchatUser});
  //const HomeScreen({ Key? key }) : super(key: key);

  @override
  _NewSnapScreenState createState() => _NewSnapScreenState();
}

class _NewSnapScreenState extends State<NewSnapScreen> {
  //SnapchatUser _snapchatUser;
  ScreenshotController screenshotController = ScreenshotController();
  File images;
  Snapkit snapkit = new Snapkit();
  List<Widget> themes = [
    Image.asset("Assets/Images/1.jpg"),
    Image.asset("Assets/Images/2.jpg"),
    Image.asset("Assets/Images/3.jpg"),
    Image.asset("Assets/Images/4.jpg"),
    Image.asset("Assets/Images/5.jpg"),
    Image.asset("Assets/Images/6.jpg"),
    Image.asset("Assets/Images/7.jpg"),
    Image.asset("Assets/Images/8.jpg"),
    Image.asset("Assets/Images/9.jpg"),
    Image.asset("Assets/Images/10.jpg"),
    Image.asset("Assets/Images/11.jpg"),
    Image.asset("Assets/Images/12.jpg"),
    Image.asset("Assets/Images/13.jpg"),
    Image.asset("Assets/Images/14.jpg"),
    Image.asset("Assets/Images/15.jpg"),
  ];
  Future getimage(bool camera, BuildContext context) async {
    final imagex = await ImagePicker()
        .pickImage(source: camera ? ImageSource.camera : ImageSource.gallery);
    if (imagex != null) {
      images = File(imagex.path);
      setState(() {});
    } else {
      //  ProgressHUD.of(context).dismiss();
    }
  }

  int index = 0;
  bool white = true;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    var providerfunc = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffFCFE35),
        centerTitle: true,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
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
      bottomNavigationBar: Container(
        color: Color(0xffFCFE35),
        // shape: CircularNotchedRectangle(),
        // notchMargin: 0.0,
        child: Container(
          height: 80,
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -37,
                left: 30,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: provider.dark
                                  ? Colors.black
                                  : Color(0xffe6e6e6),
                              radius: 31,
                            ),
                            InkWell(
                              onTap: () {
                                //print("Hello");
                                if (index == themes.length - 1) {
                                  index = 0;
                                } else {
                                  index = index + 1;
                                }
                                print(index);
                                setState(() {});
                              },
                              child: Image.asset(
                                "Assets/Images/theme.png",
                                height: 80,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Background",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -37,
                //right: 30,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: provider.dark
                                  ? Colors.black
                                  : Color(0xffe6e6e6),
                              radius: 30,
                            ),
                            InkWell(
                              onTap: () {
                                white = !white;
                                setState(() {});
                              },
                              child: Image.asset(
                                "Assets/Images/color.png",
                                height: 80,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Text Colors",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -30,
                right: 30,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: provider.dark
                                  ? Colors.black
                                  : Color(0xffe6e6e6),
                              radius: 30,
                            ),
                            Image.network(
                              widget.snapchatUser.bitmojiUrl,
                              height: 40,
                            ),
                            // CircleAvatar(
                            //   radius: 25,
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Bitmoji Style",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  print("Exiting");
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  provider.dark
                                      ? "Assets/Images/arrowd.png"
                                      : "Assets/Images/arrow.png",
                                  height: 50,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Screenshot(
                            controller: screenshotController,
                            child: Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: themes[index],
                                ),
                                Positioned(
                                  top: -60,
                                  child: Image.network(
                                    widget.snapchatUser.bitmojiUrl,
                                    height: 70,
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: white
                                            ? Colors.white
                                            : Colors.black),
                                    cursorColor:
                                        white ? Colors.white : Colors.black,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Write Here",
                                        hintStyle: TextStyle(
                                          color: white
                                              ? Colors.white
                                              : Colors.black,
                                        )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Image.asset(
                                      "Assets/Images/arrowd.png",
                                      height: 40,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: InkWell(
                                  onTap: () {
                                    print("Capturing");
                                    screenshotController
                                        .capture()
                                        .then((Uint8List image) async {
                                      //print(image);
                                      final directory =
                                          await getApplicationDocumentsDirectory();
                                      final imagePath =
                                          await File('${directory.path}.png')
                                              .create();
                                      final Uint8List pngBytes =
                                          image.buffer.asUint8List();
                                      await imagePath.writeAsBytes(pngBytes);
                                      print(
                                          "https://unkown-a6f27.web.app?id=${widget.snapchatUser.externalId}");
                                      images == null
                                          ? snapkit.share(
                                              SnapchatMediaType.NONE,
                                              // image: NetworkImage(
                                              //     'https://picsum.photos/${(this.context.size.width.round())}/${this.context.size.height.round()}.jpg'),

                                              sticker: SnapchatSticker(
                                                  image: FileImage(
                                                File(imagePath.path),
                                              )),
                                              caption: "",
                                              attachmentUrl:
                                                  "https://unkown-a6f27.web.app?id=${widget.snapchatUser.externalId}",
                                            )
                                          : snapkit.share(
                                              SnapchatMediaType.PHOTO,
                                              image: FileImage(images),
                                              sticker: SnapchatSticker(
                                                  image: FileImage(
                                                File(imagePath.path),
                                              )),
                                              caption: "",
                                              attachmentUrl:
                                                  "https://unkown-a6f27.web.app?id=${widget.snapchatUser.externalId}",
                                            );
                                    }).catchError((onError) {
                                      print(onError);
                                    });
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "Assets/Images/snap.png",
                                          height: 40,
                                        ),
                                        Text(
                                          "Send to Snapchat",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,

                                      // border: Border.all(
                                      //   width: 5,
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () {
                                getimage(false, context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "Assets/Images/pics.png",
                                          height: 40,
                                        ),
                                        Text(
                                          "Choose From Album",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,

                                      // border: Border.all(
                                      //   width: 5,
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Stack(alignment: Alignment.center, children: [
                          //   Image.asset("Assets/Images/frame.png"),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "Assets/Images/snap.png",
                          //         height: 40,
                          //       ),
                          //       Text(
                          //         "Send to Snapchat",
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //     ],
                          //   ),
                          // ]),
                          // Stack(alignment: Alignment.center, children: [
                          //   Image.asset("Assets/Images/frame.png"),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "Assets/Images/snap.png",
                          //         height: 40,
                          //       ),
                          //       Text(
                          //         "Send to Snapchat",
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //     ],
                          //   ),
                          // ]),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: provider.dark ? Colors.black : Color(0xffe6e6e6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                      ),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: images == null
                              ? NetworkImage(provider.dark
                                  ? "https://i.pinimg.com/originals/41/8e/1a/418e1a67a6ff452f43a39a4d913dc540.jpg"
                                  : "https://www.colorhexa.com/e6e6e6.png")
                              : FileImage(images)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
