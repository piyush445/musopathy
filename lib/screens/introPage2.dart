import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:musopathy/screens/languagePage.dart';
import 'package:musopathy/screens/register.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  WebViewController _controller;
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  String url =
      "https://player.vimeo.com/video/562218470?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479";
  // Rect myRect = Rect.fromLTRB(5.0, 5.0, 5.0, 5.0);
  @override
  void initState() {
    //flutterWebviewPlugin.resize(myRect);
    // flutterWebviewPlugin.launch(url,
    //           //fullScreen: false,
    //           rect: new Rect.fromLTWH(
    //               0.0,
    //               0.0,
    //               MediaQuery.of(context).size.width,
    //               300.0));
    super.initState();
    // Enable hybrid composition.

    // WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottomOpacity: 0.0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            iconSize: 30.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'MUSOPATHY',
            style: TextStyle(
              color: Colors.cyan,
              fontFamily: 'Ubuntu',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // drawer: Drawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LimitedBox(
                maxHeight: 230,
                maxWidth: double.infinity,
                child: WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController c) {
                      _controller = c;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'The Musopathy breathing and tonation program uniquely combines - Breathing, Tonation and Phonation and gives triple benefits to participants in the most effortless manner.  It includes only the easiest techniques and simplifies even challenging ones.  It has benefited hundreds of Covid positive or rehab patients as well as healthy participants by improving lung, immunological, health and oxygen saturation and decreased stress, anxiety and depression.',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  // _controller1.pause();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Register()));
                },
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 70.0),
                  alignment: Alignment
                      .center, // on giving this the container got its size later
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade800,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: new Text(
                    "Join Us 😊", //without alignment the size is according to the text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Language())),
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 70.0),
                  alignment: Alignment
                      .center, // on giving this the container got its size later
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: new Text(
                    "Videos", //without alignment the size is according to the text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
