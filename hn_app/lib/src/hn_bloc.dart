import 'dart:async';
import 'dart:collection';

import 'package:hn_app/src/article.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

enum StoriesType {
  Top,
  New
}

class HackerNewsBloc {
  final _storiesTypeController = StreamController<StoriesType>();
  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;
  // with just the StreamController a subscriber will have to wait for
  // something will emerge in the stream.
  // while BehaviourSubject (a special StreamController) will capture
  // latest item that has been added to the steam and will pass this item
  // as first to any new listener. Part of RxDart
  // https://pub.dev/documentation/rxdart/0.18.1/rx/BehaviorSubject-class.html
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();
  var _articles = <Article>[];

  List<int> _newStoriesIds = [
    20840067,
    20838082,
    20848897,
    20839146,
    20848334,
    20845928
  ];
  List<int> _topStoriesIds = [
    20850936,
    20850135,
    20848581,
    20849148,
    20847943,
    20849818,
  ];

  HackerNewsBloc() {
    _getArticlesAndUpdate(_topStoriesIds);
    _storiesTypeController.stream.listen((storiesType){
       if(storiesType == StoriesType.New) {
         _getArticlesAndUpdate(_newStoriesIds);
       }else{
         _getArticlesAndUpdate(_topStoriesIds);
       }
    });
  }

  Future<Article> _getArticle(int id) async {
    var storyUrl = "https://hacker-news.firebaseio.com/v0/item/$id.json";
    final storyRes = await http.get(storyUrl);
    if (200 == storyRes.statusCode) {
      var article = parseArticle(storyRes.body);
      return article;
    }
    return null;
  }

  Future<Null> _getArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }

  void _getArticlesAndUpdate(List<int> ids) {
    _getArticles(ids).then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });

  }
}
