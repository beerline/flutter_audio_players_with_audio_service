import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'player_seek_state.dart';

class PlayerSeekCubit extends Cubit<PlayerSeekStateAbstract> {
  PlayerSeekCubit() : super(PlayerSeekInitialState());

  Future<void> seek(Duration seconds) async {
    emit(PlayerSeekSeekState(seconds));
  }
}
