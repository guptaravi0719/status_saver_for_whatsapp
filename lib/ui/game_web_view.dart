import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

class GameWebView extends StatefulWidget {





  @override
  _GameWebViewState createState() => _GameWebViewState();
}

class _GameWebViewState extends State<GameWebView> {
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      initialChild: Container(
        //color: Colors.redAccent,
          child: Center(
              child: CircularProgressIndicator()
//              SizedBox(
//                  height: 50,
//                  width: 50,
//                  child: Image.asset("assets/images/loader.gif"))
//

          )),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      url:"https://www.gamezop.com/welcome",
//      appBar: new AppBar(
//        automaticallyImplyLeading: false,
//        leading: GestureDetector(
//          onTap: () => Navigator.pop(context),
//          child: Icon(Icons.arrow_back_ios,)
//
//        ),
////        backgroundColor: Theme.of(context).brightness == Brightness.dark
////            ? Colors.white10
////            : Colors.white,
////        actions: <Widget>[
////          Padding(
////            child: GestureDetector(
////              child: Icon(
////                Icons.share,
////                color: Theme.of(context).brightness == Brightness.dark
////                    ? Colors.white
////                    : Colors.deepPurple,
////              ),
////              onTap: () {
////                Share.share(widget.url +
////                    "\n Download this app and read News articles daily, It has Live TV too.\n" +
////                    "\nhttps://play.google.com/store/apps/details?id=com.toolsfortools.whatsappstatussaver");
////              },
////            ),
////            padding: EdgeInsets.only(right: 20.0),
////          )
////        ],
//        title: new Text(
//         "Play and earn money",
//          overflow: TextOverflow.ellipsis,
//          style: TextStyle(
//
//              color: Theme.of(context).brightness == Brightness.dark
//                  ? Colors.white
//                  : Colors.black87),
//        ),
//      ),
    );
  }
}
