part of 'playing_position_cubit.dart';

@immutable
abstract class PlayingPositionStateAbstract {}

class PlayingPositionInitial extends PlayingPositionStateAbstract {}
class PlayingPositionState extends PlayingPositionStateAbstract {
  final Duration position;

  PlayingPositionState(this.position);
}
