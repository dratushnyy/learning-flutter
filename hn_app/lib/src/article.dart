import 'dart:convert' as convert;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';

part 'article.g.dart';

abstract class Article implements Built<Article, ArticleBuilder> {
  static Serializer<Article> get serializer => _$articleSerializer;

  int get id;

  @nullable
  bool get deleted;

  String get type; // "job", "story", "comment", "poll", or "pollopt".

  @nullable
  String get by;

  int get time;

  @nullable
  String get text;

  @nullable
  bool get dead;

  @nullable
  int get parent;

  @nullable
  int get poll;

  @nullable
  BuiltList<int> get kids;

  @nullable
  String get url;

  @nullable
  int get score;

  String get title;

  @nullable
  BuiltList<int> get parts;

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
  final parsed = convert.jsonDecode(jsonString);
  var article = standardSerializers.deserializeWith(Article.serializer, parsed);
  return article;
}
