import 'dart:convert';
import 'dart:io';
// import ;
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_sourc.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_sourc_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
        being the endpoint and with application/json header''', () {
      setUpMockClientSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(
        mockClient.get(
            Uri.parse(
              'http://numbersapi.com/$tNumber',
            ),
            headers: {
              'Content-Type': 'application/json',
            }),
      );
    });

    test('should return numbertrivia when response is 200', () async {
      // arrange
      setUpMockClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, tNumberTriviaModel);
    });
    
    test('should return ServerException if response is 400 or other', () async {
      // arrange
      setUpMockClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;

      // assert
      expect(
          () => call(tNumber),
          throwsA(
            const TypeMatcher<ServerException>(),
          ));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
        being the endpoint and with application/json header''', () {
      setUpMockClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(
        mockClient.get(
            Uri.parse(
              'http://numbersapi.com/random',
            ),
            headers: {
              'Content-Type': 'application/json',
            }),
      );
    });

    test('should return numbertrivia when response is 200', () async {
      // arrange
      setUpMockClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();

      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should return ServerException if response is 400 or other', () async {
      // arrange
      setUpMockClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;

      // assert
      expect(
          () => call(),
          throwsA(
            const TypeMatcher<ServerException>(),
          ));
    });
  });
}
