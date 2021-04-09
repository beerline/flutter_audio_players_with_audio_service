part of 'playing_route_cubit.dart';

@immutable
abstract class PlayingRouteStateAbstract {}

class PlayingRouteInitial extends PlayingRouteStateAbstract {}
class PlayingThroughSpeakerState extends PlayingRouteStateAbstract {}
class PlayingThroughEarpieceState extends PlayingRouteStateAbstract {}