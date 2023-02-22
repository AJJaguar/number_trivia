import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

final myBox = Hive.box('myBox');

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final Box box;
  NumberTriviaLocalDataSourceImpl({required this.box});
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = myBox.get(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
      // return CacheException()
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return myBox.put(
      CACHED_NUMBER_TRIVIA,
      json.encode(
        triviaToCache.toJson(),
      ),
    );
  }
}
