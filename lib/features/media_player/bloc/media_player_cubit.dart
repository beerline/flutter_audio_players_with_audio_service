import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayersaudioservice/features/audio_track/domain/entities/audio_track.dart';
import 'package:audioplayersaudioservice/features/audio_track/domain/usecases/get_audio_track_usecase.dart';
import 'package:audioplayersaudioservice/features/media_player/audio_player_task.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_duration_cubit/playing_duration_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_position_cudit/playing_position_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_route_cubit/playing_route_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_speed_bloc/playing_speed_bloc.dart';
import 'package:audioplayersaudioservice/features/media_player/plyer_seek_cubit/player_seek_cubit.dart';
import 'package:audioplayersaudioservice/features/show_error/error_bar_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'media_player_state.dart';

void _entryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class MediaPlayerCubit extends Cubit<MediaPlayerStateAbstract> {
  final PlayingRouteCubit playRouteCubit;
  final PlayingSpeedBloc playingSpeedBloc;
  final PlayingDurationCubit playingDurationCubit;
  final PlayingPositionCubit playingPositionCubit;
  final PlayerSeekCubit playerSeekCubit;
  final GetAudioTrackUseCase getAudioTrackUseCase;
  final ErrorBarCubit errorBarCubit;

  AudioTrack _audioTrack;

  get isPlayingThroughEarpiece => playRouteCubit.isPlayingThroughEarpiece;

  factory MediaPlayerCubit(
    PlayingRouteCubit playRouteCubit,
    PlayingSpeedBloc playingSpeedBloc,
    PlayingDurationCubit playingDurationCubit,
    PlayingPositionCubit playingPositionCubit,
    PlayerSeekCubit playerSeekCubit,
    GetAudioTrackUseCase getAudioTrackUseCase,
    ErrorBarCubit errorBarCubit,
  ) {
    var mediaPlayer = MediaPlayerCubit._init(
      playRouteCubit,
      playingSpeedBloc,
      playingDurationCubit,
      playingPositionCubit,
      playerSeekCubit,
      getAudioTrackUseCase,
      errorBarCubit,
    );

    _startAudioService(mediaPlayer);

    return mediaPlayer;
  }

  MediaPlayerCubit._init(
    this.playRouteCubit,
    this.playingSpeedBloc,
    this.playingDurationCubit,
    this.playingPositionCubit,
    this.playerSeekCubit,
    this.getAudioTrackUseCase,
    this.errorBarCubit,
  ) : super(MediaPlayerInitialState(null));

  static Future<void> _startAudioService(
    MediaPlayerCubit mediaPlayer,
  ) async {
    AudioService.customEventStream.listen((event) {
      if (event[AudioPlayerTask.DURATION_SECONDS_EVENT] != null) {
        mediaPlayer.changDuration(
            Duration(seconds: event[AudioPlayerTask.DURATION_SECONDS_EVENT]));
      }
      if (event[AudioPlayerTask.POSITION_SECONDS_EVENT] != null) {
        mediaPlayer.setPosition(
            Duration(seconds: event[AudioPlayerTask.POSITION_SECONDS_EVENT]));
      }
      if (event[AudioPlayerTask.COMPLETE_EVENT] != null) {
        mediaPlayer.nextTrack();
      }
      if (event[AudioPlayerTask.PLAY_EVENT] != null) {
        mediaPlayer.resume();
      }
      if (event[AudioPlayerTask.PAUSE_EVENT] != null) {
        mediaPlayer.pause();
      }
      if (event[AudioPlayerTask.SKIP_TO_PREVIOUS_EVENT] != null) {
        mediaPlayer.prevTrack();
      }
      if (event[AudioPlayerTask.SKIP_TO_NEXT_EVENT] != null) {
        mediaPlayer.nextTrack();
      }
      if (event[AudioPlayerTask.STOP_EVENT] != null) {
        mediaPlayer.stopFromIsolate();
      }
    });

    await AudioService.start(backgroundTaskEntrypoint: _entryPoint)
        .then((value) =>
            print('==== successStartBackgroundTask ====>' + value.toString()))
        .onError((error, stackTrace) => print(
            '----- successStartBackgroundTask error ----: ' +
                error.toString()));
  }

  void _addTrackAndPlay(AudioTrack track) {
    AudioService.updateQueue([]);
    AudioService.addQueueItem(MediaItem(
      id: track.url,
      album: track.author,
      title: track.title,
    ));

    /// using custom PLAY_ACTION because regular onPlay from background using as resume
    AudioService.customAction(AudioPlayerTask.PLAY_ACTION, playingSpeedBloc.playingSpeed);
  }

  Future<dynamic> _addActionToAudioService(Function callback) async {
    if (!AudioService.running) {
      await _startAudioService(this);
    }

    return callback();
  }

  Future<void> play() async {
    emit(MediaPlayerLoadingTrackState(null));

    if (_audioTrack == null) {
      _audioTrack = await getAudioTrackUseCase.next();

      if (_audioTrack is AudioTrack) {
        _addActionToAudioService(() => _addTrackAndPlay(_audioTrack));
      } else {
        errorBarCubit.show('no tracks in library');
      }
    } else {
      _addActionToAudioService(
          () => AudioService.customAction(AudioPlayerTask.RESUME_ACTION));
    }
    emit(MediaPlayerPlayingState(_audioTrack));
  }

  Future<void> pause() async {
    emit(MediaPlayerPausedState(_audioTrack));
    _addActionToAudioService(() => AudioService.pause());
  }

  Future<void> resume() async {
    emit(MediaPlayerPlayingState(_audioTrack));
    _addActionToAudioService(
        () => AudioService.customAction(AudioPlayerTask.RESUME_ACTION));
  }

  Future<void> stop() async {
    emit(MediaPlayerStoppedState(_audioTrack));
    _addActionToAudioService(
        () => AudioService.stop().then((value) => print('**** stop stop ***')));
  }

  Future<void> toggleEarpieceOrSpeakers() async {
    if (await _addActionToAudioService(() =>
        AudioService.customAction(AudioPlayerTask.EARPIECE_TOGGLE_ACTION))) {
      playRouteCubit.toggle();
    }
  }

  Future<void> increaseSpeed() async {
    playingSpeedBloc.add(PlayingSpeedIncreaseEvent(
      () {
        _addActionToAudioService(() => AudioService.customAction(
            AudioPlayerTask.SPEED_CHANGE_ACTION,
            playingSpeedBloc.playingSpeed));
      },
    ));
  }

  Future<void> seek(Duration newPosition) async {
    if (newPosition.inSeconds > 0) {
      newPosition = newPosition;
    }
    playerSeekCubit.seek(newPosition);
    _addActionToAudioService(() => AudioService.customAction(
        AudioPlayerTask.SEEK_ACTION, newPosition.inSeconds));
  }

  Future<void> nextTrack() async {
    if (_audioTrack is AudioTrack) {
      var nextTrack = await getAudioTrackUseCase.next(
        currentTrackIndex: _audioTrack.currentTrackIndex,
      );
      if (nextTrack is AudioTrack) {
        _audioTrack = nextTrack;
        emit(MediaPlayerPlayingState(_audioTrack));
        _addActionToAudioService(() => _addTrackAndPlay(nextTrack));
      } else {
        errorBarCubit.show('no more tracks');
      }
    }
  }

  Future<void> prevTrack() async {
    if (_audioTrack is AudioTrack) {
      var prevTrack = await getAudioTrackUseCase.previous(
        _audioTrack.currentTrackIndex,
      );

      if (prevTrack is AudioTrack) {
        _audioTrack = prevTrack;
        emit(MediaPlayerPlayingState(_audioTrack));
        _addTrackAndPlay(prevTrack);
      } else {
        errorBarCubit.show('no previouse tracks');
      }
    }
  }

  Future<void> stopFromIsolate() async {
    /// handle stop event from isolate and from UI to avoid send stop action
    /// after isolate already stopped
    _audioTrack = null;
    emit(MediaPlayerStoppedState(_audioTrack));
  }

  Future<void> changDuration(Duration duration) async {
    playingDurationCubit.setDuration(duration);
  }

  Future<void> setPosition(Duration position) async {
    playingPositionCubit.setPosition(position);
  }
}
