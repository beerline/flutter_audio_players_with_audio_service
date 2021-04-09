part of 'media_player_bloc.dart';

@immutable
abstract class MediaPlayerStateAbstract {
  final AudioTrack audioTrack;

  MediaPlayerStateAbstract(this.audioTrack);
}

class MediaPlayerInitialState extends MediaPlayerStateAbstract {
  MediaPlayerInitialState(AudioTrack audioTrack) : super(audioTrack);
}

class MediaPlayerLoadingTrackState extends MediaPlayerStateAbstract {
  MediaPlayerLoadingTrackState(AudioTrack audioTrack) : super(audioTrack);
}

class MediaPlayerPlayingState extends MediaPlayerStateAbstract {
  MediaPlayerPlayingState(AudioTrack audioTrack) : super(audioTrack);
}

class MediaPlayerPausedState extends MediaPlayerStateAbstract {
  MediaPlayerPausedState(AudioTrack audioTrack) : super(audioTrack);
}

class MediaPlayerStoppedState extends MediaPlayerStateAbstract {
  MediaPlayerStoppedState(AudioTrack audioTrack) : super(audioTrack);
}
