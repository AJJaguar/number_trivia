import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTrivialModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      expect(tNumberTrivialModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return a valid number when the json number is an integer',
        () {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTrivialModel);
        },
      );
    },
  );
  group(
    'toJson',
    () {
      test(
        'should return a json map containing the proper data',
        () {
          // act
          final result = tNumberTrivialModel.toJson();
          // assert
          final expectedMap = {
            "text": "Test Text",
            "number": 1,
          };

          expect(result, expectedMap);
        },
      );
    },
  );
}
