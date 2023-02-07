import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be empty', () async* {
    // assert

    expect(bloc.initialState, equals(Empty));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    ;

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async* {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
        Left(
          InvalidInputFailure(),
        ),
      );
      // assert late
      final expected = [
        Empty(),
        const Error(message: INVALID_INPUT_ERROR),
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('should get data from the concrete use case', () async* {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      // assert later
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });
    test('should emit [loading, loaded] when data is gotten successfully',
        () async* {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('should emit [loading, error] when data is gotten unsuccessfully',
        () async* {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_ERROR)
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('should emit [loading, error] and give type of error message',
        () async* {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_ERROR),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
   
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    
    test('should get data from the Random use case', () async* {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      // assert later
      verify(mockGetRandomNumberTrivia(NoParams()));
    });
    test('should emit [loading, loaded] when data is gotten successfully',
        () async* {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('should emit [loading, error] when data is gotten unsuccessfully',
        () async* {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_ERROR)
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('should emit [loading, error] and give type of error message',
        () async* {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_ERROR),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
