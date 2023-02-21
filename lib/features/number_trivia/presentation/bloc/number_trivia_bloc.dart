import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const INVALID_INPUT_ERROR = 'Invalid Input';
const SERVER_FAILURE_ERROR = 'SERVER ERROR FAILURE';
const CACHE_FAILURE_ERROR = 'CACHE FAILURE';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaState get initialState => Empty();

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(
          Empty(),
        ) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    print(event.numberString + 'yes');
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);
    print(inputEither);

    print('no');
    await inputEither!.fold((failure) {
      print('error');
      emit(
        const Error(
          message: INVALID_INPUT_ERROR,
        ),
      );
    }, (integer) async {
      emit(Loading());
      print('loading');
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      print('$integer done');
      print(failureOrTrivia);
      failureOrTrivia!
          .fold((failure) => emit(Error(message: _mapFailureMessage(failure))),
              (trivia) {
        // print('$trivia Me');
        print('${trivia.number} ${trivia.text} concrete');
        emit(Loaded(trivia: trivia));
      });
      // failureOrTrivia!.fold((failure) => emit(Error(message: 'me')),
      //     (trivia) => emit(Loaded(trivia: trivia)));
    });
    // emit.isDone;
  }

  FutureOr<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(
      Loading(),
    );
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    print(failureOrTrivia);
    failureOrTrivia!
        .fold((failure) => emit(Error(message: _mapFailureMessage(failure))),
            (trivia) {
      print('${trivia.number} random');
      emit(Loaded(trivia: trivia));
    });
  }
}

String _mapFailureMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_ERROR;
    case CacheFailure:
      return CACHE_FAILURE_ERROR;
    default:
      return 'Unknown Error';
  }
}
