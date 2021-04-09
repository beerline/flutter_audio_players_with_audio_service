part of 'error_bar_cubit.dart';

@immutable
abstract class ErrorBarStateAbstract {}

class ErrorBarStateInitial extends ErrorBarStateAbstract {}
class ShowErrorBarState extends ErrorBarStateAbstract {
  final String message;

  ShowErrorBarState(this.message);
}
class HideErrorBarState  extends ErrorBarStateAbstract {}