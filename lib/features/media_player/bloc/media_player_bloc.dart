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

part 'media_player_event.dart';

part 'media_player_state.dart';

void _entryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class MediaPlayerBloc
    extends Bloc<MediaPlayerEventAbstract, MediaPlayerStateAbstract> {
  final PlayingRouteCubit playRouteCubit;
  final PlayingSpeedBloc playingSpeedBloc;
  final PlayingDurationCubit playingDurationCubit;
  final PlayingPositionCubit playingPositionCubit;
  final PlayerSeekCubit playerSeekCubit;
  final GetAudioTrackUseCase getAudioTrackUseCase;
  final ErrorBarCubit errorBarCubit;

  AudioTrack _audioTrack;

  get isPlayingThroughEarpiece => playRouteCubit.isPlayingThroughEarpiece;

  factory MediaPlayerBloc(
    PlayingRouteCubit playRouteCubit,
    PlayingSpeedBloc playingSpeedBloc,
    PlayingDurationCubit playingDurationCubit,
    PlayingPositionCubit playingPositionCubit,
    PlayerSeekCubit playerSeekCubit,
    GetAudioTrackUseCase getAudioTrackUseCase,
    ErrorBarCubit errorBarCubit,
  ) {
    var mediaPlayer = MediaPlayerBloc._init(
      playRouteCubit,
      playingSpeedBloc,
      playingDurationCubit,
      playingPositionCubit,
      playerSeekCubit,
      getAudioTrackUseCase,
      errorBarCubit,
    );

    _startAudioService(mediaPlayer, playingDurationCubit, playingPositionCubit);

    return mediaPlayer;
  }

  MediaPlayerBloc._init(
    this.playRouteCubit,
    this.playingSpeedBloc,
    this.playingDurationCubit,
    this.playingPositionCubit,
    this.playerSeekCubit,
    this.getAudioTrackUseCase,
    this.errorBarCubit,
  ) : super(MediaPlayerInitialState(null));

  static Future<void> _startAudioService(
    MediaPlayerBloc mediaPlayer,
    PlayingDurationCubit playingDurationCubit,
    PlayingPositionCubit playingPositionCubit,
  ) async {
    AudioService.customEventStream.listen((event) {
      if (event[AudioPlayerTask.DURATION_SECONDS_EVENT] != null) {
        playingDurationCubit.setDuration(
            Duration(seconds: event[AudioPlayerTask.DURATION_SECONDS_EVENT]));
      }
      if (event[AudioPlayerTask.POSITION_SECONDS_EVENT] != null) {
        playingPositionCubit.setPosition(
            Duration(seconds: event[AudioPlayerTask.POSITION_SECONDS_EVENT]));
      }
      if (event[AudioPlayerTask.COMPLETE_EVENT] != null) {
        mediaPlayer.add(MediaPlayerNextTrackEvent());
      }
      if (event[AudioPlayerTask.PLAY_EVENT] != null) {
        mediaPlayer.add(MediaPlayerResumeEvent());
      }
      if (event[AudioPlayerTask.PAUSE_EVENT] != null) {
        mediaPlayer.add(MediaPlayerPauseEvent());
      }
      if (event[AudioPlayerTask.SKIP_TO_PREVIOUS_EVENT] != null) {
        mediaPlayer.add(MediaPlayerPreviousTrackEvent());
      }
      if (event[AudioPlayerTask.SKIP_TO_NEXT_EVENT] != null) {
        mediaPlayer.add(MediaPlayerNextTrackEvent());
      }
      if (event[AudioPlayerTask.STOP_EVENT] != null) {
        mediaPlayer.add(MediaPlayerStopFromIsolateEvent());
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
    AudioService.customAction(AudioPlayerTask.PLAY_ACTION);
  }

  Future<dynamic> _addActionToAudioService(Function callback) async {
    if (!AudioService.running) {
      print('------ _startAudioService ----');
      await _startAudioService(
          this, playingDurationCubit, playingPositionCubit);
    }

    return callback();
  }

  @override
  Stream<MediaPlayerStateAbstract> mapEventToState(
    MediaPlayerEventAbstract event,
  ) async* {
    if (event is MediaPlayerPlayEvent) {
      yield MediaPlayerLoadingTrackState(null);

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
      yield MediaPlayerPlayingState(_audioTrack);
    } else if (event is MediaPlayerPauseEvent) {
      yield MediaPlayerPausedState(_audioTrack);
      _addActionToAudioService(() => AudioService.pause());
    } else if (event is MediaPlayerStopEvent) {
      yield MediaPlayerStoppedState(_audioTrack);
      _addActionToAudioService(() =>
          AudioService.stop().then((value) => print('**** stop stop ***')));
    } else if (event is MediaPlayerEarpieceOrSpeakersToggleEvent) {
      if (await _addActionToAudioService(() =>
          AudioService.customAction(AudioPlayerTask.EARPIECE_TOGGLE_ACTION))) {
        playRouteCubit.toggle();
      }
    } else if (event is MediaPlayerSpeedIncreaseEvent) {
      playingSpeedBloc.add(PlayingSpeedIncreaseEvent(
        () {
          _addActionToAudioService(() => AudioService.customAction(
              AudioPlayerTask.SPEED_CHANGE_ACTION,
              playingSpeedBloc.playingSpeed));
        },
      ));
    } else if (event is MediaPlayerSeekEvent) {
      var newPosition = Duration(seconds: 0);
      if (event.newPosition.inSeconds > 0) {
        newPosition = event.newPosition;
      }
      playerSeekCubit.seek(newPosition);
      _addActionToAudioService(() => AudioService.customAction(
          AudioPlayerTask.SEEK_ACTION, newPosition.inSeconds));
    } else if (event is MediaPlayerResumeEvent) {
      yield MediaPlayerPlayingState(_audioTrack);
      _addActionToAudioService(
          () => AudioService.customAction(AudioPlayerTask.RESUME_ACTION));
    } else if (event is MediaPlayerNextTrackEvent) {
      if (_audioTrack is AudioTrack) {
        var nextTrack = await getAudioTrackUseCase.next(
          currentTrackIndex: _audioTrack.currentTrackIndex,
        );
        if (nextTrack is AudioTrack) {
          _audioTrack = nextTrack;
          yield MediaPlayerPlayingState(_audioTrack);
          _addActionToAudioService(() => _addTrackAndPlay(nextTrack));
        } else {
          errorBarCubit.show('no more tracks');
        }
      }
    } else if (event is MediaPlayerPreviousTrackEvent) {
      if (_audioTrack is AudioTrack) {
        var prevTrack = await getAudioTrackUseCase.previous(
          _audioTrack.currentTrackIndex,
        );

        if (prevTrack is AudioTrack) {
          _audioTrack = prevTrack;
          yield MediaPlayerPlayingState(_audioTrack);
          _addTrackAndPlay(prevTrack);
        } else {
          errorBarCubit.show('no previouse tracks');
        }
      }
    } else if (event is MediaPlayerStopFromIsolateEvent) {
      /// handle stop event from isolate and from UI to avoid send stop action
      /// after isolate already stopped
      _audioTrack = null;
      yield MediaPlayerStoppedState(_audioTrack);
    }
  }
}
