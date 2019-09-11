import 'package:flutter_counter/bloc.dart';
import 'package:flutter_counter/events.dart';
import 'package:test/test.dart';

void main() {
  group("CounterBlock", (){
    CounterBloc counterBloc;
    setUp((){
      counterBloc = CounterBloc();
    });

    test("Initial state is 0", () {
      expect(counterBloc.initialState, 0);
    });

    test('single Increment event updates state to 1', () {
      final List<int> expected = [0, 1];
      expectLater(
        counterBloc.state,
        emitsInOrder(expected),
      );

      counterBloc.dispatch(CounterEvent.Increment);
    });

    test('single Decrement event updates state to -1', () {
      final List<int> expected = [0, -1];

      expectLater(
        counterBloc.state,
        emitsInOrder(expected),
      );

      counterBloc.dispatch(CounterEvent.Decrement);
    });
  });


}