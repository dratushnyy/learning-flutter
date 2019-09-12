import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerState extends Equatable {
  final int timerTime;

  TimerState(this.timerTime, [List props = const []])
      : super([timerTime]..addAll(props));

}

class Ready extends TimerState {
  Ready(int timerTimer): super(timerTimer);

  @override
  String toString() => "Ready {timerTimer: $timerTime}";
}

class Pause extends TimerState {
  Pause(int timerTimer):super(timerTimer);

  @override
  String toString() => "Pause {timerTimer: $timerTime}";
}

class Running extends TimerState {
  Running(int timerTimer) : super(timerTimer);

  @override
  String toString() => "Running {timerTimer: $timerTime}";
}


class Finished extends TimerState {
  Finished() : super(0);

  @override
  String toString() => "Finished";
}