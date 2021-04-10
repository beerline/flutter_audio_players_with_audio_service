import 'package:audioplayersaudioservice/features/media_player/bloc/media_player_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_position_cudit/playing_position_cubit.dart';
import 'package:audioplayersaudioservice/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<MediaPlayerCubit>()),
        BlocProvider.value(value: serviceLocator<PlayingPositionCubit>()),
      ],
      child: BlocBuilder<MediaPlayerCubit, MediaPlayerStateAbstract>(
          builder: (context, mediaPlayerState) {
        var _playCallback = () async {
          print('play tap');

          BlocProvider.of<MediaPlayerCubit>(context).play();
        };

        var _resumeCallback = () async {
          print('resume tap');

          BlocProvider.of<MediaPlayerCubit>(context).resume();
        };

        var _pauseCallback = () {
          BlocProvider.of<MediaPlayerCubit>(context).pause();
          print('pause tap');
        };

        return BlocBuilder<PlayingPositionCubit, PlayingPositionStateAbstract>(
            builder: (context, playingPositionState) {
          final _playingPosition = playingPositionState is PlayingPositionState
              ? playingPositionState.position
              : Duration(seconds: 0);
          return Padding(
            padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
            child: Column(children: [
              Divider(thickness: 0.5, color: theme.hintColor),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        print('previous track');
                        serviceLocator<MediaPlayerCubit>().prevTrack();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(40, 40)),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Icon(
                        Icons.skip_previous_sharp,
                        size: 30,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print('backward 15 on tap');
                        Duration newPosition =
                            _playingPosition - Duration(seconds: 15);
                        BlocProvider.of<MediaPlayerCubit>(context)
                            .seek(newPosition);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(40, 40)),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/ic_backward_15.svg',
                        color: theme.colorScheme.onPrimary,
                        width: 30,
                        height: 30,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TextButton(
                        onPressed: mediaPlayerState is MediaPlayerPlayingState
                            ? _pauseCallback
                            : mediaPlayerState is MediaPlayerInitialState ||
                                    mediaPlayerState is MediaPlayerStoppedState
                                ? _playCallback
                                : _resumeCallback,
                        child: mediaPlayerState is MediaPlayerPlayingState
                            ? Icon(
                                Icons.pause,
                                color: theme.colorScheme.onPrimary,
                                size: 30,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: theme.colorScheme.onPrimary,
                                size: 30,
                              ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                theme.colorScheme.secondary),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        print('forward 30 on tap');
                        Duration newPosition =
                            _playingPosition + Duration(seconds: 30);
                        BlocProvider.of<MediaPlayerCubit>(context)
                            .seek(newPosition);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(40, 40)),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/ic_forward_30.svg',
                        color: theme.colorScheme.onPrimary,
                        width: 30,
                        height: 30,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print('next track');
                        serviceLocator<MediaPlayerCubit>().nextTrack();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(40, 40)),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Icon(Icons.skip_next_sharp, size: 30),
                    ),
                  ],
                ),
              )
            ]),
          );
        });
      }),
    );
  }
}
