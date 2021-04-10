import 'package:audioplayersaudioservice/features/media_player/bloc/media_player_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_route_cubit/playing_route_cubit.dart';
import 'package:audioplayersaudioservice/features/media_player/playing_speed_bloc/playing_speed_bloc.dart';
import 'package:audioplayersaudioservice/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<PlayingSpeedBloc>()),
        BlocProvider.value(value: serviceLocator<PlayingRouteCubit>()),
      ],
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<PlayingSpeedBloc, PlayingSpeedStateAbstract>(
                  builder: (context, playingSpeedState) {
                return SizedBox(
                  width: 80,
                  child: TextButton(
                    onPressed: () {
                      BlocProvider.of<MediaPlayerCubit>(context).increaseSpeed();
                      print('playing speed clic');
                    },
                    child: Text(playingSpeedState.speed.toString() + 'x'),
                  ),
                );
              }),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<PlayingRouteCubit, PlayingRouteStateAbstract>(
                  builder: (context, playerRouteState) {
                return TextButton(
                  onPressed: () {
                    BlocProvider.of<MediaPlayerCubit>(context)
                        .toggleEarpieceOrSpeakers();
                    print('speaker on tap');
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 40)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(
                        playerRouteState is PlayingThroughEarpieceState
                            ? theme.colorScheme.secondary
                            : null),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/ic_speaker_on.svg',
                    width: 40,
                    height: 40,
                  ),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
