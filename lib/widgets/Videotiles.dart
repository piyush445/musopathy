import "package:flutter/material.dart";

class VideoTiles extends StatelessWidget {
  final List videoUrls;
  final List titles;
  int index;

  VideoTiles(this.titles, this.videoUrls, this.index);

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(titles[index])
        //  leading: buildLeading(songsList[index]["Image"]),
        // subtitle: Text(songsList[index]["artist"]),
        // trailing: Text(songsList[index]["duration"].toString()),
        // onTap: () {
        //   Provider.of<SongsData>(context, listen: false).setIndexPath(index);
        //   print(
        //       Provider.of<SongsData>(context, listen: false).selectedSongIndex);
        //   audioPlayer.play(songsList[index]["path"]);
        );
  }
}
