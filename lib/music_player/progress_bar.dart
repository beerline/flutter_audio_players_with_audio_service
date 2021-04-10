import 'package:audioplayersaudioservice/features/media_player/bloc/media_player_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_duration_cubit/playing_duration_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_position_cudit/playing_position_cubit.dart';
import 'package:audioplayersaudioservice/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<PlayingDurationCubit>()),
        BlocProvider.value(value: serviceLocator<PlayingPositionCubit>()),
      ],
      child: BlocBuilder<PlayingDurationCubit, PlayingDurationStateAbstract>(
          builder: (context, playingDurationState) {
        final _playingDurationSeconds =
            playingDurationState is PlayingDurationState
                ? playingDurationState.duration.inSeconds
                : 0;
        return BlocBuilder<PlayingPositionCubit, PlayingPositionStateAbstract>(
            builder: (context, playingPositionState) {
          final _playingPosition = playingPositionState is PlayingPositionState
              ? playingPositionState.position
              : Duration(seconds: 0);
          return Stack(children: [
            Slider(
              value: (_playingPosition.inSeconds.toDouble() > 0 &&
                      _playingPosition.inSeconds.toDouble() <=
                          _playingDurationSeconds.toDouble())
                  ? _playingPosition.inSeconds.toDouble()
                  : 0,
              max: _playingDurationSeconds.toDouble(),
              onChanged: (v) {
                Duration newPosition = Duration(seconds: v.round());
                BlocProvider.of<MediaPlayerCubit>(context).seek(newPosition);
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Text(
                playingPositionState is PlayingPositionState
                    ? RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                            .firstMatch(
                                playingPositionState.position.toString())
                            ?.group(1) ??
                        playingPositionState.position.toString()
                    : '00:00',
                style: TextStyle(color: theme.hintColor, fontSize: 11),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                playingDurationState is PlayingDurationState
                    ? RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                            .firstMatch(
                                playingDurationState.duration.toString())
                            ?.group(1) ??
                        playingDurationState.duration.toString()
                    : '00:00',
                style: TextStyle(color: theme.hintColor, fontSize: 11),
              ),
            ),
          ]);
        });
      }),
    );
  }
}
