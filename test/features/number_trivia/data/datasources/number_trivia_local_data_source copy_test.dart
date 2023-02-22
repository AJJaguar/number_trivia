import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source copy.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source copy_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockHiveInterface mockHiveInterface;
  late MockBox mockBox;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockBox = MockBox();
    dataSource = NumberTriviaLocalDataSourceImpl(hive: mockHiveInterface);
  });

  group('getLastNumberTrivia', () {

    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

  test('should return last cached numbertrivia if it is cached', () {
    // arrange
    when(mockHiveInterface.)


    // act


    // assert


  })


  });
}
