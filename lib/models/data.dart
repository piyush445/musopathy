import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Videos extends ChangeNotifier {
  List videoUrls;
  int selectedIndex = 0;
  List titles;

  void fetchVideos(List videos) {
    videoUrls = videos;
    notifyListeners();
  }

  void setIndexPath(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void fetchTitles(List t) {
    titles = t;
    notifyListeners();
  }
}
