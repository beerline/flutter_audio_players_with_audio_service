part of 'player_seek_cubit.dart';

@immutable
abstract class PlayerSeekStateAbstract {}

class PlayerSeekInitialState extends PlayerSeekStateAbstract {}
class PlayerSeekSeekState extends PlayerSeekStateAbstract {
  final Duration newPosition;

  PlayerSeekSeekState(this.newPosition);
}
