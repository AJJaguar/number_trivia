import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class NumberTriviaControls extends StatefulWidget {
  const NumberTriviaControls({
    super.key,
  });

  @override
  State<NumberTriviaControls> createState() => _NumberTriviaControlsState();
}

class _NumberTriviaControlsState extends State<NumberTriviaControls> {
  late String inputtedNumber;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              inputtedNumber = value;
            },
            decoration: InputDecoration(
              hintText: 'Input a number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: dispatchConcrete,
                child: const Text('Search'),
              ),
              ElevatedButton(
                onPressed: addRandom,
                child: const Text('Get Random'),
              )
            ],
          )
        ],
      ),
    );
  }

  void dispatchConcrete() {
    context
        .read<NumberTriviaBloc>()
        .add(GetTriviaForConcreteNumber(numberString: inputtedNumber));
    print(inputtedNumber);
  }

  void addRandom() {
    context.read<NumberTriviaBloc>().add(
          GetTriviaForRandomNumber(),
        );
  }
}
