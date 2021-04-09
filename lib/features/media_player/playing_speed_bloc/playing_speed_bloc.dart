import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'playing_speed_event.dart';

part 'playing_speed_state.dart';

class PlayingSpeedBloc
    extends Bloc<PlayingSpeedEventAbstract, PlayingSpeedStateAbstract> {
  var _playingSpeed = PlayingSpeedX1State.SPEED;

  get playingSpeed => _playingSpeed;

  PlayingSpeedBloc() : super(PlayingSpeedX1State());

  @override
  Stream<PlayingSpeedStateAbstract> mapEventToState(
    PlayingSpeedEventAbstract event,
  ) async* {
    if (event is PlayingSpeedIncreaseEvent) {
      dynamic state = PlayingSpeedX1State();
      if (_playingSpeed == PlayingSpeedX1State.SPEED) {
        state = PlayingSpeedX1_25State();
      } else if (_playingSpeed == PlayingSpeedX1_25State.SPEED) {
        state = PlayingSpeedX1_5State();
      } else if (_playingSpeed == PlayingSpeedX1_5State.SPEED) {
        state = PlayingSpeedX1_75State();
      } else if (_playingSpeed == PlayingSpeedX1_75State.SPEED) {
        state = PlayingSpeedX2State();
      } else if (_playingSpeed == PlayingSpeedX2State.SPEED) {
        state = PlayingSpeedX1State();
      }
      yield state;
      _playingSpeed = state.speed;
      event.callBack();
    }
  }
}
