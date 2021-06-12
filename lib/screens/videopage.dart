import "package:flutter/material.dart";
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musopathy/models/data.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:musopathy/screens/payment.dart';
import 'package:musopathy/widgets/Videotiles.dart';
import 'package:musopathy/widgets/videoplayer.dart';

import 'package:video_player/video_player.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
var loggedInUser;

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _controller;
  bool paid;
  Future<void> _initializeVideoPlayerFuture;
  List videoUrls = [];
  Videos videodata = new Videos();
  final _auth = FirebaseAuth.instance;
  //List oldtitles = ["01", "02", "03", "04"];
  List titles = [];
  dynamic ic = Icons.play_arrow;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/musopathy-bfaea.appspot.com/o/musopathy%2F01.mp4?alt=media&token=9b43361d-6360-402a-90af-0597a68cdd50";

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getdata() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data());
        paid = Map.from(documentSnapshot.data())['paid'];
        print(paid);
      } else {
        print("not exist");
      }
    });
  }

  downloadURLS() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref('musopathy/')
        .listAll();

    result.items.forEach((firebase_storage.Reference ref1) async {
      titles.add(ref1.fullPath);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(ref1.fullPath.toString())
          .getDownloadURL();

      videoUrls.add(downloadURL.toString());
      // print(downloadURL);

      //  print(ref.fullPath);
    }

        // videodata.fetchTitles(titles);
        );
    try {
      if (videoUrls.length == 0) {
        print("error");
      }

      // videodata.fetchVideos(videoUrls);
      // videodata.fetchTitles(titles);
      // print(videoUrls);

      //print(songsdata.songs);
    } catch (e) {
      print(e);
    }
  }

  void initial(String url) {
    // _controller.pause();
    setState(() {
      _controller = VideoPlayerController.network(url);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.play();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      "https://firebasestorage.googleapis.com/v0/b/musopathy-bfaea.appspot.com/o/musopathy%2F01.mp4?alt=media&token=9b43361d-6360-402a-90af-0597a68cdd50",
      //videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();

    // initPlatformState();
    // getCurrentUser();
    // getdata();

    // void initPlatformState() {
    // this.downloadURLS();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: missing_required_param
      body: DraggableBottomSheet(
        backgroundWidget: Container(
            child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    //  ClosedCaption(text: _controller.value.caption.text),
                    _ControlsOverlay(controller: _controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )),
        expandedChild: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                ListTile(
                  title: Text("01.mp4"),
                  onTap: () {
                    initial(
                        "https://firebasestorage.googleapis.com/v0/b/musopathy-bfaea.appspot.com/o/musopathy%2F01.mp4?alt=media&token=9b43361d-6360-402a-90af-0597a68cdd50");
                  },
                ),
                ListTile(
                  title: Text("02.mp4"),
                  trailing: Icon(Icons.lock),
                  onTap: () {
                    setState(() {
                      _controller.pause();
                    });
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => Payment()));
                    // initial(
                    //     "https://firebasestorage.googleapis.com/v0/b/musopathy-bfaea.appspot.com/o/musopathy%2F03.mp4?alt=media&token=0a820bf8-74f2-40aa-ba11-7376df1c0048");
                  },
                ),
                ListTile(
                  title: Text("03.mp4"),
                  onTap: () {
                    initial(
                        "https://firebasestorage.googleapis.com/v0/b/musopathy-bfaea.appspot.com/o/musopathy%2F04.mp4?alt=media&token=f9cca684-6b7f-40c4-83ea-93d5cc5da605");
                  },
                ),
              ],
            )),
        previewChild: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.pink,
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
        maxExtent: MediaQuery.of(context).size.height * 0.6,
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  _ControlsOverlay({@required this.controller});

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
