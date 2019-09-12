import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class TimerEvent extends Equatable {
  TimerEvent([List props = const [] ]): super(props);
}

class StartTimer extends TimerEvent {
  final int timerTime;
  StartTimer({@required this.timerTime}):super([timerTime]);

  @override
  String toString() => "Start {duration: $timerTime}";
}

class PauseTimer extends TimerEvent {
  @override
  String toString() => "Pause";
}

class ResumeTimer extends TimerEvent {
  @override
  String toString() => "Resume";
}

class ResetTimer extends TimerEvent {
  @override
  String toString() => "Reset";
}

class TimerTick extends TimerEvent {
  final int timerTime;
  TimerTick({@required this.timerTime}): super([timerTime]);

  @override
  String toString() => "Tick {duration: $timerTime}";
}