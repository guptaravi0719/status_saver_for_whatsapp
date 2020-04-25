import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class MyNavigationDrawer extends StatefulWidget {
  @override
  _MyNavigationDrawerState createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  bool isSwitched = false;
  final String version = '1.0.0';

  _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.toolsfortools.status_saver';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : Colors.teal),
          accountName: Text(
            'Status Saver',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text('Version: $version'),
          currentAccountPicture: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Theme.of(context).brightness == Brightness.dark
                  ? Icons.brightness_5
                  : Icons.brightness_2),
              Text(Theme.of(context).brightness == Brightness.dark
                  ? "Disable Dark Mode"
                  : "Enable Dark Mode"),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    Theme.of(context).brightness == Brightness.dark
                        ? DynamicTheme.of(context)
                            .setBrightness(Brightness.light)
                        : DynamicTheme.of(context)
                            .setBrightness(Brightness.dark);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
        Card(
          child: ListTile(
            leading: IconTheme(
                data: new IconThemeData(color: Color(0xff757575)),
                child: Icon(Icons.thumb_up)),
            title: Text('Rate Us'),
            onTap: () {
              _launchURL();
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: IconTheme(
                data: new IconThemeData(color: Color(0xff757575)),
                child: Icon(Icons.share)),
            title: Text('Share With Friends'),
            onTap: () {
              Share.share(
                'Hey buddy! I am using Whatsapp status downloader. Download this whatsapp status downloader app from play store click link: \n https://play.google.com/store/apps/details?id=com.toolsfortools.status_saver',
              );
            },
          ),
        ),
      ],
    );
  }
}
