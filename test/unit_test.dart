import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/main.dart';

void main() {
  setUp(() => null);
  test('How importance is it?', () {
    expect('!!', howManyMark(Importance.medium));
  });
}
