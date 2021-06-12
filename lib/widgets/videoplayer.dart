import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  VideoPlayerScreen({this.url});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/musopathy-bfaea.appspot.com/o/musopathy%2F01.mp4?alt=media&token=9b43361d-6360-402a-90af-0597a68cdd50");
    _initializeVideoPlayerFuture = _controller.initialize();
    // _controller.play();
    // _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  void initial(String url) {
    setState(() {
      _controller = VideoPlayerController.network(url);
      _initializeVideoPlayerFuture = _controller.initialize();
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('videos'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            ListView(
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
                  onTap: () {
                    initial(
                        "https://firebasestorage.googleapis.com/v0/b/musopathy-bfaea.appspot.com/o/musopathy%2F03.mp4?alt=media&token=0a820bf8-74f2-40aa-ba11-7376df1c0048");
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // pause
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // play
              _controller.play();
            }
          });
        },
        // icon
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
