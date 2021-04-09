import 'package:audioplayersaudioservice/features/media_player/bloc/media_player_bloc.dart';
import 'package:audioplayersaudioservice/injection_container.dart';
import 'package:audioplayersaudioservice/music_player/bottom_bar.dart';
import 'package:audioplayersaudioservice/music_player/progress_bar.dart';
import 'package:audioplayersaudioservice/music_player/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<MediaPlayerBloc>()),

      ],
      child: BlocBuilder<MediaPlayerBloc, MediaPlayerStateAbstract>(
          builder: (context, mediaPlayerState) {

        return Container(
          color: theme.colorScheme.primaryVariant,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: mediaQuery.padding.top + 8, left: 10, right: 10),
                child: TopBar(),
              ),
              Divider(thickness: 0.5, color: theme.hintColor),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            mediaPlayerState.audioTrack?.title ?? '',
                            style: theme.primaryTextTheme.headline5,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Stack(
                      children: [
                        SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.asset('assets/dali.png')),
                        (() {
                          /// styling ProgressIndicator
                          if (mediaPlayerState
                              is MediaPlayerLoadingTrackState) {
                            return SizedBox(
                              width: 200,
                              height: 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            );
                          }

                          return SizedBox();
                        }()),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            mediaPlayerState.audioTrack?.title ??
                                'no selected track',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            mediaPlayerState.audioTrack?.author ??
                                'no selected track',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.hintColor),
                          ),
                        ),
                      ],
                    ),
                    ProgressBar(),
                  ]),
                ),
              ),
              BottomBar(),
            ],
          ),
        );
      }),
    );
  }
}
