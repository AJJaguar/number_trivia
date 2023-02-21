import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

import 'number_trivia_local_data_source copy_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockHiveInterface mockHiveInterface;
  late MockBox mockBox;
  
}
