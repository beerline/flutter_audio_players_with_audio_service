import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'playing_duration_state.dart';

class PlayingDurationCubit extends Cubit<PlayingDurationStateAbstract> {
  PlayingDurationCubit() : super(PlayingDurationInitial());

  Future<void> setDuration(Duration duration) async {
    emit(PlayingDurationState(duration));
  }
}
