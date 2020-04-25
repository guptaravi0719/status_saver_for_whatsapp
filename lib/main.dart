import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:whatsappstatussaver/ui/dashboard.dart';
import 'package:whatsappstatussaver/ui/game_web_view.dart';

import 'package:whatsappstatussaver/ui/mydrawer.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:whatsappstatussaver/utils/slide_right_route.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:whatsappstatussaver/utils/version_check.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  int _storagePermissionCheck;
  Future<int> _storagePermissionChecker;

  Future<int> checkStoragePermission() async {
    PermissionStatus result = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    print("Checking Storage Permission " + result.toString());
    setState(() {
      _storagePermissionCheck = 1;
    });
    if (result.toString() == 'PermissionStatus.denied') {
      return 0;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> requestStoragePermission() async {
    Map<PermissionGroup, PermissionStatus> result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result.toString() == 'PermissionStatus.denied') {
      return 1;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      print("Initial Values of $_storagePermissionCheck");
      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await checkStoragePermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }

  Widget dialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Grants Storage Permission",
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _storagePermissionChecker =
                                requestStoragePermission();
                          });
                        },
                        child: Text(
                          "Grant",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            title: 'Wa status saver',
            home: DefaultTabController(
              length: 2,
              child: FutureBuilder(
                future: _storagePermissionChecker,
                builder: (context, status) {
                  if (status.connectionState == ConnectionState.done) {
                    if (status.hasData) {
                      if (status.data == 1) {
                        return MyHome();
                      } else {
                        return Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Card(
                              elevation: 8.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Permission Required",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "Grant Storage access permission",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: FlatButton(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        "Allow Storage Permission",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          _storagePermissionChecker =
                                              requestStoragePermission();
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                        //dialogue(context);

                      }
                    } else {
                      return Scaffold(
                        body: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.lightBlue[100],
                              Colors.lightBlue[200],
                              Colors.lightBlue[300],
                              Colors.lightBlue[200],
                              Colors.lightBlue[100],
                            ],
                          )),
                          child: Center(
                            child: Text(
                              "Something went wrong.. Please uninstall and Install Again.",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var html =
      "<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- Enjoy!!</p>";

  Widget dialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Play Games and Earn Money?",
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context, SlideRightRoute(widget: GameWebView()));
                        },
                        child: Text(
                          "Play now",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  BannerAd bannerAd;
  static const List<String> testDevice = ["A758460DDBEFAE12C800CF559072910E"];
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? testDevice : null,
    childDirected: true,
    nonPersonalizedAds: true,
  );

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-3945166141600873/2886567655",
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  @override
  void initState() {
    versionCheck(context);
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3945166141600873~3031122755");
    bannerAd = createBannerAd()
      ..load()
      ..show();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool adShown = true;
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(
      height: 40.0,
    ));
    return Scaffold(
      persistentFooterButtons: adShown ? fakeBottomButtons : null,

      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text('Status Saver'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? null
            : Colors.teal,
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                dialogue(context);
              },
              child: Icon(Icons.videogame_asset)),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(
                  'Hey buddy! I am using Whatsapp status downloader. Download this whatsapp status downloader app from play store click link: \n https://play.google.com/store/apps/details?id=com.toolsfortools.status_saver',
                );
              }),
          IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Html(data: html),
                                Expanded(
                                  child: new Align(
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      child: Text(
                                        'OK!',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              })
        ],
        bottom: TabBar(tabs: [
          Container(
            height: 30.0,
            child: Text(
              'IMAGES',
            ),
          ),
          Container(
            height: 30.0,
            child: Text(
              'VIDEOS',
            ),
          ),
//          Container(
//            height: 30.0,
//            child: Text(
//              'GAMES',
//            ),
//          ),
        ]),
      ),
      body: Dashboard(),
      //backgroundColor: Colors.white,
      drawer: Drawer(
        child: MyNavigationDrawer(),
      ),
    );
  }
}
