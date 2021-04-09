import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'playing_route_state.dart';

class PlayingRouteCubit extends Cubit<PlayingRouteStateAbstract> {
  PlayingRouteCubit() : super(PlayingRouteInitial());

  PlayingRouteState _playingRouteState = PlayingRouteState.SPEAKERS;
  get isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRouteState.EARPIECE;

  Future<void> toggle() async {
    if (_playingRouteState == PlayingRouteState.SPEAKERS) {
      emit(PlayingThroughEarpieceState());
      _playingRouteState = PlayingRouteState.EARPIECE;

    } else {
      emit(PlayingThroughSpeakerState());
      _playingRouteState = PlayingRouteState.SPEAKERS;
    }
  }
}
