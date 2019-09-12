import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_timer/bloc/timer_events.dart';
import 'package:flutter_timer/bloc/timer_state.dart';
import 'package:flutter_timer/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final int _duration = 60;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  @override
  TimerState get initialState => Ready(_duration);

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is StartTimer) {
      yield* _mapStartToState(event);
    } else if (event is TimerTick) {
      yield* _mapTickToState(event);
    } else if (event is PauseTimer) {
      yield* _mapPauseToState(event);
    } else if (event is ResumeTimer) {
      yield* _mapResumeToState(event);
    } else if (event is ResetTimer) {
      yield* _mapResetToState(event);
    }
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }

  Stream<TimerState> _mapStartToState(StartTimer start) async* {
    yield Running(start.timerTime);
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick(ticks: start.timerTime).listen((time) {
          dispatch(TimerTick(timerTime: time));
        });
  }

  Stream<TimerState>_mapTickToState(TimerTick tick) async* {
    yield tick.timerTime > 0 ? Running(tick.timerTime) : Finished();
  }

  Stream<TimerState>_mapPauseToState(PauseTimer pause) async* {
    final state = currentState;
    if (state is Running) {
     _tickerSubscription?.pause();
     yield Pause(state.timerTime);
    }
  }

  Stream<TimerState> _mapResumeToState(ResumeTimer event) async* {
    final state = currentState;
    if (state is Pause) {
      _tickerSubscription?.resume();
      yield Running(state.timerTime);
    }
  }

  Stream<TimerState> _mapResetToState(ResetTimer event) async*{
    _tickerSubscription?.cancel();
    yield Ready(_duration);
  }

}

