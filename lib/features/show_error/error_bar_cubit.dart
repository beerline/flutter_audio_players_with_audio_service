import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'error_bar_state.dart';

class ErrorBarCubit extends Cubit<ErrorBarStateAbstract> {
  ErrorBarCubit() : super(ErrorBarStateInitial());

  void show(String message) {
    emit(ShowErrorBarState(message));
  }

  void hide() {
    emit(HideErrorBarState());
  }
}
