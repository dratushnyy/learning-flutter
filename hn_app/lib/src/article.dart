import 'package:built_value/built_value.dart';
part 'article.g.dart';

abstract class Article implements Built<Article, ArticleBuilder> {
  int get id;
  String get by;
  String get text;
  String get url;
  int get time;
  int get score;
  int get commentsCount;
  Article._();
  factory Article([void Function(ArticleBuilder) updates]) = _$Article;
}

var articles = [];

List<int> parseTopStories(String jsonSting) {
  return [];
//  final parsed = json.jsonDecode(jsonSting);
//  final listOfIds = List<int>.from(parsed);
//  return listOfIds;
}

Article parseArticle(String jsonString) {
  return null;
//  final parsed = json.jsonDecode(jsonString);
//  var article =  Article.fomJson(parsed);
//  return article;
}
