import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayersaudioservice/error_bar.dart';
import 'package:audioplayersaudioservice/features/show_error/error_bar_cubit.dart';
import 'package:audioplayersaudioservice/injection_container.dart';
import 'package:audioplayersaudioservice/music_player/music_player.dart';
import 'package:audioplayersaudioservice/theme_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() {
  runApp(MyApp());
  di.init();
}

class MyApp extends StatelessWidget {
  static const _errorBarHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    final theme = di.serviceLocator<ThemeFactory>().getThemeData();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    return MaterialApp(
      title: 'AudioPlayres playing via AusioService',
      themeMode: ThemeMode.dark,
      darkTheme: theme,
      home: AudioServiceWidget(
        child: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: serviceLocator<ErrorBarCubit>())
            ],
            child: BlocListener<ErrorBarCubit, ErrorBarStateAbstract>(
                listener: (context, state) {
              if (state is ShowErrorBarState) {
                Timer(Duration(seconds: 5), () {
                  serviceLocator<ErrorBarCubit>().hide();
                });
              }
            }, child: BlocBuilder<ErrorBarCubit, ErrorBarStateAbstract>(
                    builder: (context, state) {
              final message = state is ShowErrorBarState ? state.message : '';
              final position =
                  state is ShowErrorBarState ? 0.0 : _errorBarHeight * -1;
              return Stack(
                children: [
                  MusicPlayer(),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    width: MediaQuery.of(context).size.width,
                    curve: Curves.easeInOutQuart,
                    top: position,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        int sensitivity = 1;
                        if (details.delta.dy < -sensitivity) {
                          serviceLocator<ErrorBarCubit>().hide();
                        }
                      },
                      child: ErrorBar(_errorBarHeight, message),
                    ),
                  ),
                ],
              );
            })),
          ),
        ),
      ),
    );
  }
}
