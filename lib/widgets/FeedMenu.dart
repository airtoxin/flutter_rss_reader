import 'package:flutter/material.dart';

import '../FeedItem.dart';

class FeedMenu extends StatefulWidget {
  const FeedMenu({Key? key, required this.feedUrl, required this.onTap})
      : super(key: key);

  final String feedUrl;
  final void Function(String content) onTap;

  @override
  State<FeedMenu> createState() => _FeedMenuState();
}

class _FeedMenuState extends State<FeedMenu> {
  FeedItem? _feedItem;

  @override
  void initState() async {
    super.initState();
    fetchFeed(widget.feedUrl).then((feedItem) => setState(() {
          _feedItem = feedItem;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(_feedItem?.title ?? ""),
      children: _feedItem?.items
              .join(
                  (p0) => p0.map((article) => ListTile(
                        title: Text(article.title ?? ""),
                        onTap: () {
                          widget.onTap(article.content ?? "");
                        },
                      )),
                  (p0) => p0.map((article) => ListTile(
                        title: Text(article.title ?? ""),
                        onTap: () {
                          widget.onTap(article.content?.value ?? "");
                        },
                      )))
              .toList() ??
          [],
    );
  }
}
