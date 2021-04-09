import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'playing_position_state.dart';

class PlayingPositionCubit extends Cubit<PlayingPositionStateAbstract> {
  PlayingPositionCubit() : super(PlayingPositionInitial());

  Future<void> setPosition(Duration position) async {
    emit(PlayingPositionState(position));
  }
}
