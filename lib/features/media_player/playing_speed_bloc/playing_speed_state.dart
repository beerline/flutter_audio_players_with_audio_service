part of 'playing_speed_bloc.dart';

@immutable
abstract class PlayingSpeedStateAbstract {
  get speed;
}

class PlayingSpeedX1State extends PlayingSpeedStateAbstract {
  static const SPEED = 1.0;
  get speed => SPEED;
}
class PlayingSpeedX1_25State extends PlayingSpeedStateAbstract {
  static const SPEED = 1.25;
  get speed => SPEED;
}
class PlayingSpeedX1_5State extends PlayingSpeedStateAbstract {
  static const SPEED = 1.5;
  get speed => SPEED;
}
class PlayingSpeedX1_75State extends PlayingSpeedStateAbstract {
  static const SPEED = 1.75;
  get speed => SPEED;
}
class PlayingSpeedX2State extends PlayingSpeedStateAbstract {
  static const SPEED = 2.0;
  get speed => SPEED;
}
