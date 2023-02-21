import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/locator.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/number_trivia_controls.dart';
import '../widgets/widgets.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Scaffold(
        // backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return const MessageDisplay(
                        message: 'Start Searching',
                      );
                    } else if (state is Loading) {
                      return const LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(
                        message: state.trivia,
                      );
                    } else if (state is Error) {
                      return MessageDisplay(
                        message: state.message,
                      );
                    } else {
                      return Text('me');
                    }
                  },
                ),
              ),
              const NumberTriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
