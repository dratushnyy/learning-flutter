import 'package:flutter/material.dart';
import 'src/article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _ids = [
  20850936, 20850135, 20848581, 20849148,
  20847943, 20849818, 20840067, 20838082,
  20848897, 20839146, 20848334,20845928];

  Future<Article> _getArticle(int id) async{
    var storyUrl = "https://hacker-news.firebaseio.com/v0/item/$id.json";
    final storyRes = await http.get(storyUrl);
    if (200 == storyRes.statusCode) {
      var article = parseArticle(storyRes.body);
      return article;
    }
    return null;
  }

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
        child: ListView(
            children: _ids.map((i) =>
                FutureBuilder<Article> (
                  future: _getArticle(i),
                  builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _buildItem(snapshot.data);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                )
        ).toList(),
      ),
      )
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.text.hashCode.toString()),
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
          title: Text(article.title?? "[null]",
              style: TextStyle(fontSize: 24)
          ),
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
          ]
      ),
    );
  }
}
