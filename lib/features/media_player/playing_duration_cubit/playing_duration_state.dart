part of 'playing_duration_cubit.dart';

@immutable
abstract class PlayingDurationStateAbstract {}

class PlayingDurationInitial extends PlayingDurationStateAbstract {}
class PlayingDurationState extends PlayingDurationStateAbstract {
  final Duration duration;

  PlayingDurationState(this.duration);
}