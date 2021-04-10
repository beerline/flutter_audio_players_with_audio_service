import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();

  static const IS_LOCAL_TO_BACKGROUND = 'isLocal';

  static const DURATION_SECONDS_EVENT = 'DURATION_SECONDS_EVENT';
  static const POSITION_SECONDS_EVENT = 'POSITION_SECONDS_EVENT';
  static const COMPLETE_EVENT = 'COMPLETE_EVENT';

  static const PAUSE_EVENT = 'PAUSE_EVENT';
  static const STOP_EVENT = 'STOP_EVENT';
  static const PLAY_EVENT = 'PLAY_EVENT';
  static const SKIP_TO_NEXT_EVENT = 'SKIP_TO_NEXT_EVENT';
  static const SKIP_TO_PREVIOUS_EVENT = 'SKIP_TO_PREVIOUS_EVENT';

  static const PLAY_ACTION = 'PLAY_ACTION';
  static const SEEK_ACTION = 'SEEK_ACTION';
  static const EARPIECE_TOGGLE_ACTION = 'EARPIECE_TOGGLE_ACTION';
  static const SPEED_CHANGE_ACTION = 'SPEED_CHANGE_ACTION';
  static const RESUME_ACTION = 'RESUME_ACTION';

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    var position = Duration(milliseconds: await _player.getCurrentPosition());
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        _player.state == AudioPlayerState.PLAYING
            ? MediaControl.pause
            : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: _player.state == AudioPlayerState.PLAYING,
      position: position,
    );
  }

  /// Maps audio_players's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    switch (_player.state) {
      case AudioPlayerState.STOPPED:
        return AudioProcessingState.stopped;
      case AudioPlayerState.COMPLETED:
        return AudioProcessingState.completed;
      case AudioPlayerState.PLAYING:
        return AudioProcessingState.ready;
      case AudioPlayerState.PAUSED:
        return AudioProcessingState.ready;
      default:
        throw Exception("Invalid state: ${_player.state}");
    }
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    _player.onDurationChanged.listen((duration) {
      if (duration != AudioServiceBackground.mediaItem.duration) {
        AudioServiceBackground.setMediaItem(
            AudioServiceBackground.mediaItem.copyWith(duration: duration));
        AudioServiceBackground.sendCustomEvent(
            {DURATION_SECONDS_EVENT: duration.inSeconds});
      }
    });
    _player.onAudioPositionChanged.listen((position) {
      AudioServiceBackground.sendCustomEvent(
          {POSITION_SECONDS_EVENT: position.inSeconds});
      _broadcastState();
    });
    _player.onPlayerCompletion.listen((event) {
      _broadcastState();
      AudioServiceBackground.sendCustomEvent({COMPLETE_EVENT: true});
    });
    _player.onPlayerStateChanged.listen((event) {
      _broadcastState();
    });
    _player.onPlayerCommand.listen((event) {
      _broadcastState();
    });
  }

  @override
  Future<void> onPlay() async {
    print('----- onPlay in isolate ------');
    AudioServiceBackground.sendCustomEvent({PLAY_EVENT: true});
  }

  @override
  Future<void> onPause() async {
    print('----- pouse in isolate ------');
    if (_player.state != AudioPlayerState.PAUSED) {
      print('----- do pouse in isolate ------');
      AudioServiceBackground.sendCustomEvent({PAUSE_EVENT: true});
      _player.pause();
    }
  }

  Future<void> _stop() async {
    await _player.seek(Duration(seconds: 0));
    await _player.stop();
    AudioServiceBackground.sendCustomEvent({STOP_EVENT: true});
    await _player.dispose();
    await _broadcastState();
  }

  @override
  Future<void> onStop() async {
    print('----- stop in isolate ------');
    await _stop();
    super.onStop();
  }

  @override
  Future<void> onTaskRemoved() async {
    print('----- onTaskRemoved in isolate ------');
    _stop();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    print('----- onSeekTo in isolate ------   position.inSeconds:' +
        position.inSeconds.toString());
    _player.seek(position);
  }

  @override
  Future<void> onSkipToPrevious() async {
    print('----- onSkipToPrevious in isolate ------');
    AudioServiceBackground.sendCustomEvent({SKIP_TO_PREVIOUS_EVENT: true});
  }

  @override
  Future<void> onSkipToNext() async {
    print('----- onSkipToNext in isolate ------');
    AudioServiceBackground.sendCustomEvent({SKIP_TO_NEXT_EVENT: true});
  }

  @override
  Future<void> onAddQueueItem(MediaItem mediaItem) async {
    print('----- onAddQueueItem in isolate ------');
    AudioServiceBackground.setMediaItem(mediaItem);
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {
    if (name == SEEK_ACTION && arguments is int && arguments > 0) {
      var duration = Duration(seconds: arguments);
      AudioServiceBackground.setState(position: duration);
      return await _player.seek(duration);
    }
    if (name == EARPIECE_TOGGLE_ACTION) {
      return await _player.earpieceOrSpeakersToggle() == 1;
    }
    if (name == SPEED_CHANGE_ACTION && arguments is double && arguments > 0) {
      return await _player.setPlaybackRate(playbackRate: arguments);
    }
    if (name == RESUME_ACTION) {
      return await _player.resume();
    }
    if (name == PLAY_ACTION) {
      var mediaItem = AudioServiceBackground.mediaItem;
      await _player.play(
        mediaItem.id,
        position: Duration(seconds: 0),
        isLocal: false,
      );
      _player.setPlaybackRate(playbackRate: arguments);
    }
  }
}
