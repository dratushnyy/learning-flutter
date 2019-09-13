import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hn_app/src/hn_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hn_app/src/article.dart';

void main() {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(bloc: hnBloc));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;

  MyApp({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hacker News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Hacker News', bloc: bloc),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc bloc;

  // This widget is the root of your application.
  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {
                //_articles.removeAt(0);
              });
            },
            child: StreamBuilder<UnmodifiableListView<Article>>(
              stream: widget.bloc.articles,
              initialData: UnmodifiableListView<Article>([]),
              builder: (context, snapshot) => ListView(
                children: snapshot.data.map(_buildItem).toList(),
              ),
            )
         ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if(index == 0) {
            widget.bloc.storiesType.add(StoriesType.Top);
          } else {
            widget.bloc.storiesType.add(StoriesType.New);
          }
        },
        items: [
          BottomNavigationBarItem(
              title: Text("Top stories"),
              icon: Icon(Icons.new_releases)),
          BottomNavigationBarItem(
              title: Text("New stories"),
              icon: Icon(Icons.arrow_drop_up)),
        ],
      ),

    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
          title:
              Text(article.title ?? "[null]", style: TextStyle(fontSize: 24)),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: () async {
                    if (await canLaunch("${article.url}")) {
                      await launch("${article.url}");
                    }
                  },
                )
              ],
            )
          ]),
    );
  }
}
