import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'FeedItem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final feedUrlController = TextEditingController();
  List<String> _feedUrls = [
    'https://future-architect.github.io/atom.xml',
    'https://developer.apple.com/news/releases/rss/releases.rss'
  ];
  Widget? html;

  @override
  void dispose() {
    feedUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(child: Text("Feeds")),
            ..._feedUrls.map((feedUrl) => FutureBuilder(
                  future: fetchFeed(feedUrl),
                  builder:
                      (BuildContext context, AsyncSnapshot<FeedItem> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      } else if (!snapshot.hasData) {
                        return const Text("No Data");
                      } else {
                        return ExpansionTile(
                          title: Text(snapshot.data!.title),
                          children: snapshot.data!.items
                              .join(
                                  (p0) => p0.map((article) => ListTile(
                                        title: Text(article.title!),
                                        onTap: () {
                                          setState(() {
                                            html = Html(
                                                data: article.content ?? "");
                                          });
                                        },
                                      )),
                                  (p0) => p0.map((article) => ListTile(
                                        title: Text(article.title!),
                                        onTap: () {
                                          setState(() {
                                            html = Html(
                                                data: article.content?.value ??
                                                    "");
                                          });
                                        },
                                      )))
                              .toList(),
                        );
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )),
          ],
        ),
      ),
      body: Row(children: [html == null ? const SizedBox.shrink() : html!]),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.lock_reset),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Add feed"),
                    content: TextField(
                      controller: feedUrlController,
                      decoration: const InputDecoration(hintText: "Feed url"),
                    ),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          setState(() {
                            _feedUrls += [feedUrlController.text];
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
