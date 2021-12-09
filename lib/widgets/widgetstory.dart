
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = [
      StoryItem.text(title: '''Ucan sepetden Kazandıran Kampanya: İndirim Yağmurları Başladı''',
          backgroundColor: Colors.blueGrey),
      StoryItem.pageImage(
          url:
              "https://i.sozcu.com.tr/wp-content/uploads/2020/12/11/880x487-yemeksepeti.jpg",
          controller: controller),
      StoryItem.pageImage(
          url:
              "https://wp-modula.com/wp-content/uploads/2018/12/gifgif.gif",
          controller: controller,
          imageFit: BoxFit.contain),
    ];
    return Material(
      child: StoryView(
        storyItems: storyItems,
        controller: controller,
        inline: false,
        repeat: true,
      ),
    );
  }
}