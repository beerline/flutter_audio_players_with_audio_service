part of 'media_player_bloc.dart';

@immutable
abstract class MediaPlayerEventAbstract {}

class MediaPlayerPlayEvent extends MediaPlayerEventAbstract {}

class MediaPlayerPauseEvent extends MediaPlayerEventAbstract {}

class MediaPlayerResumeEvent extends MediaPlayerEventAbstract {}

class MediaPlayerNextTrackEvent extends MediaPlayerEventAbstract {}

class MediaPlayerPreviousTrackEvent extends MediaPlayerEventAbstract {}

class MediaPlayerStopEvent extends MediaPlayerEventAbstract {}
class MediaPlayerStopFromIsolateEvent extends MediaPlayerEventAbstract {}

class MediaPlayerEarpieceOrSpeakersToggleEvent
    extends MediaPlayerEventAbstract {}

class MediaPlayerSpeedIncreaseEvent extends MediaPlayerEventAbstract {}

class MediaPlayerSeekEvent extends MediaPlayerEventAbstract {
  final Duration newPosition;

  MediaPlayerSeekEvent(this.newPosition);
}
