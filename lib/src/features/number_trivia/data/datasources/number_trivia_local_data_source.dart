import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/src/core/errors/exceptions.dart';
import 'package:trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';

const String CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

abstract class NumberTriviaLocalDataSource {
  /// Get a cached [NumberTriviaModel] which was gotten the last time the
  /// user had an internet connection.
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Cache the [NumberTriviaModel] gotten from remote source
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final jsonString = json.encode(triviaToCache.toJson());
    await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      final parsedJson = json.decode(jsonString);
      return Future.value(NumberTriviaModel.fromJson(parsedJson));
    } else {
      throw CacheException();
    }
  }
}
