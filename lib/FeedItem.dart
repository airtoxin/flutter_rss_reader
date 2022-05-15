import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:sealed_unions/sealed_unions.dart';

typedef FeedItems = Union2<List<AtomItem>, List<RssItem>>;
typedef FeedItemsImpl = Doublet<List<AtomItem>, List<RssItem>>;

class FeedItem {
  String title;
  FeedItems items;
  FeedItem(this.title, this.items);
}

Future<FeedItem> fetchFeed(String uri) async {
  if (uri.endsWith(".rss")) {
    final rssRes = await http
        .get(Uri.parse(uri))
        .then((res) => utf8.decode(res.bodyBytes));
    final rssFeed = RssFeed.parse(rssRes);
    return FeedItem(
        rssFeed.title!, const FeedItemsImpl().second(rssFeed.items!));
  } else if (uri.endsWith(".xml")) {
    final atomRes = await http
        .get(Uri.parse(uri))
        .then((res) => utf8.decode(res.bodyBytes));
    final atomFeed = AtomFeed.parse(atomRes);
    return FeedItem(
        atomFeed.title!, const FeedItemsImpl().first(atomFeed.items!));
  } else {
    throw Exception("Ambient feed url");
  }
}
