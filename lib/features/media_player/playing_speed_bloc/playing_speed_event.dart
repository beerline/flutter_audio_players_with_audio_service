part of 'playing_speed_bloc.dart';

@immutable
abstract class PlayingSpeedEventAbstract {}

typedef PlayingSpeedIncreaseCallBack = void Function();

class PlayingSpeedIncreaseEvent extends PlayingSpeedEventAbstract {
  final PlayingSpeedIncreaseCallBack callBack;

  PlayingSpeedIncreaseEvent(this.callBack);
}