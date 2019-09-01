import 'dart:convert' as json;

import 'article.dart';

List<int> parseTopStories(String jsonSting) {
  final parsed = json.jsonDecode(jsonSting);
  final listOfIds = List<int>.from(parsed);
  return listOfIds;
}

Article parseArticle(String jsonString) {
  final parsed = json.jsonDecode(jsonString);
  var article =  Article.fomJson(parsed);
  return article;
}
