import "package:flutter/material.dart";
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:musopathy/models/data.dart';
import 'package:musopathy/screens/loginUi.dart';

import 'package:musopathy/screens/payment.dart';

import 'package:musopathy/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:connectivity/connectivity.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  ScrollController scrollController;
  Future<int> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return 1;
    }
    return Future.error(
        "This is the error", StackTrace.fromString("This is its trace"));
  }

  WebViewController _controller;
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List li;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final Future<int> result = checkConnection();
    return Scaffold(
      key: key,
      drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0.0,
        leading: IconButton(
            icon: Icon(Icons.menu),
            iconSize: 30.0,
            color: Theme.of(context).primaryColor,
            onPressed: () => key.currentState.openDrawer()),
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
      body: DraggableBottomSheet(
        backgroundWidget: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LimitedBox(
              maxHeight: 230,
              maxWidth: double.infinity,
              child: FutureBuilder<int>(
                future: result, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return WebView(
                        initialUrl: Provider.of<Data>(context).currentUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController c) {
                          _controller = c;
                        });
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Text(
                          "net:: ERR_INTERNET_DISCONNECTED",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          child: Text("Tap to retry once connected"),
                          onTap: () {
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                // Provider.of<Data>(context, listen: false).name,
                Provider.of<Data>(context).currentname,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                Provider.of<Data>(context).currentdesc,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Color(0xFFDFDFDF),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          ],
        )),
        expandedChild: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.8,
          maxChildSize: 1.0,
          builder: (BuildContext context, ScrollController scrollController) =>
              Scaffold(
                  body: FutureBuilder<DocumentSnapshot>(
            future: users.doc("videos").get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data.data() as Map<String, dynamic>;
                li = List.from(data['exercises']);
                Provider.of<Data>(context, listen: false).fetchVideos(li);

                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Color(0xEFEFEF),
                        child: ListTile(
                          trailing: (index > 0 && index < 8) &&
                                  (Provider.of<Data>(context, listen: false)
                                              .loggedin ==
                                          false ||
                                      Provider.of<Data>(context, listen: false)
                                              .account["paid"] ==
                                          false)
                              ? Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                )
                              : null,
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Text(
                              Provider.of<Data>(context).li[index]["name"]),
                          subtitle: Text(
                              Provider.of<Data>(context, listen: false)
                                  .li[index]["description"]),
                          onTap: () {
                            print(index);
                            if ((index > 0 && index < 8)) {
                              if ((Provider.of<Data>(context, listen: false)
                                          .loggedin ==
                                      true) &&
                                  Provider.of<Data>(context, listen: false)
                                      .account["paid"]) {
                                //  initial(link, newname, Provider.of<Data>(context,listen: false).li[index]["description"]);
                                Provider.of<Data>(context, listen: false)
                                    .updateCurrentDetails(index);
                                _controller.loadUrl(
                                    Provider.of<Data>(context, listen: false)
                                        .currentUrl);
                              } else if (Provider.of<Data>(context,
                                          listen: false)
                                      .loggedin ==
                                  true) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Payment()));
                                //  print(email);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MyHomePage()));
                              }
                            } else {
                              Provider.of<Data>(context, listen: false)
                                  .updateCurrentDetails(index);
                              _controller.loadUrl(
                                  Provider.of<Data>(context, listen: false)
                                      .currentUrl);
                            }
                          },
                        ));
                  },
                  itemCount: li.length,
                );
              }

              return Text("loading");
            },
          )),
        ),
        previewChild: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(children: <Widget>[
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                height: 8,
              ),
              Text('Exercises',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              //SizedBox(height: 16),
            ])),
        minExtent: 65,
        maxExtent: MediaQuery.of(context).size.height * 0.8,
      ),
    );
  }
}
