import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeFactory {
  final Brightness brightness;

  ThemeFactory(this.brightness);

  get primary => isDarkTheme() ? Color(0xFF121212) : Colors.white;

  get primaryLevel2 => isDarkTheme() ? Color(0xFF222121) : Colors.grey[200];

  get primaryLevel3 => isDarkTheme() ? Color(0xFF343330) : Colors.white;

  get primaryContrast => isDarkTheme() ? Color(0xFFEAE0C9) : Colors.black;

  get primaryContrastMiddlePale =>
      isDarkTheme() ? Color(0xFFAAA28F) : Colors.white;

  get primaryContrastPale => isDarkTheme() ? Color(0xFF706D64) : Colors.white;

  get primaryAccent => isDarkTheme() ? Color(0xFFF04A32) : Colors.greenAccent;

  get secondaryAccent => isDarkTheme() ? Color(0xFFDCC99D) : Colors.blueAccent;

  get errorSnackBar => isDarkTheme() ? Color(0xFFF3BD41) : Colors.redAccent;

  bool isDarkTheme() {
    return brightness == Brightness.dark;
  }

  ThemeData getThemeData() {
    final ThemeData baseTheme = ThemeData(
      fontFamily: 'Montserrat',
      brightness: brightness,
    );
    return baseTheme.copyWith(
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryAccent,
        inactiveTrackColor: primaryContrastPale,
        thumbColor: primaryAccent,
        thumbShape: SquareSliderThumbShape(),
        overlayShape: SquareSliderOverlayShape(thumbSize: 26),
        trackShape: CustomTrackShape(),
      ),
      primaryColor: primary,
      primaryColorLight: primaryLevel2,
      backgroundColor: primaryContrast,
      // (knobs, text, overscroll edge effect, etc)
      accentColor: secondaryAccent,
      scaffoldBackgroundColor: primary,
      bottomAppBarColor: primary,
      cardColor: primaryLevel2,
      dividerColor: primaryLevel3,
      buttonColor: secondaryAccent,
      hintColor: primaryContrastPale,
      toggleableActiveColor: secondaryAccent,
      textTheme: TextTheme(
        headline1:
            baseTheme.textTheme.headline1.copyWith(color: primaryContrast),
        headline2:
            baseTheme.textTheme.headline2.copyWith(color: primaryContrast),
        headline3:
            baseTheme.textTheme.headline3.copyWith(color: primaryContrast),
        headline4:
            baseTheme.textTheme.headline4.copyWith(color: primaryContrast),
        headline5:
            baseTheme.textTheme.headline5.copyWith(color: primaryContrast),
        headline6:
            baseTheme.textTheme.headline6.copyWith(color: primaryContrast),
        subtitle1:
            baseTheme.textTheme.subtitle1.copyWith(color: primaryContrast),
        subtitle2:
            baseTheme.textTheme.subtitle2.copyWith(color: primaryContrast),
        bodyText1:
            baseTheme.textTheme.bodyText1.copyWith(color: primaryContrast),
        bodyText2:
            baseTheme.textTheme.bodyText2.copyWith(color: primaryContrast),
        caption: baseTheme.textTheme.caption,
        button: baseTheme.textTheme.button,
        overline: baseTheme.textTheme.overline,
      ),
      primaryTextTheme: TextTheme(
        headline1: baseTheme.textTheme.headline1.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        headline2: baseTheme.textTheme.headline2.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        headline3: baseTheme.textTheme.headline3.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        headline4: baseTheme.textTheme.headline4.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        headline5: baseTheme.textTheme.headline5.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        headline6: baseTheme.textTheme.headline6.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        subtitle1: baseTheme.textTheme.subtitle1.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        subtitle2: baseTheme.textTheme.subtitle2.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        bodyText1: baseTheme.textTheme.bodyText1.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        bodyText2: baseTheme.textTheme.bodyText2.copyWith(
          color: primaryContrast,
          fontFamily: 'Philosopher',
        ),
        caption: baseTheme.textTheme.caption,
        button: baseTheme.textTheme.button,
        overline: baseTheme.textTheme.overline,
      ),
      accentTextTheme: TextTheme(
        headline1: baseTheme.accentTextTheme.headline1
            .copyWith(color: primaryContrast),
        headline2: baseTheme.accentTextTheme.headline2
            .copyWith(color: primaryContrast),
        headline3: baseTheme.accentTextTheme.headline3
            .copyWith(color: primaryContrast),
        headline4: baseTheme.accentTextTheme.headline4
            .copyWith(color: primaryContrast),
        headline5: baseTheme.accentTextTheme.headline5
            .copyWith(color: primaryContrast),
        headline6: baseTheme.accentTextTheme.headline6
            .copyWith(color: primaryContrast),
        subtitle1: baseTheme.accentTextTheme.subtitle1
            .copyWith(color: primaryContrast),
        subtitle2: baseTheme.accentTextTheme.subtitle2
            .copyWith(color: primaryContrast),
        bodyText1: baseTheme.accentTextTheme.bodyText1
            .copyWith(color: primaryContrast),
        bodyText2: baseTheme.accentTextTheme.bodyText2
            .copyWith(color: primaryContrast),
        caption: baseTheme.accentTextTheme.caption,
        button: baseTheme.accentTextTheme.button,
        overline: baseTheme.accentTextTheme.overline,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryAccent,
        selectionColor: primaryAccent,
        selectionHandleColor: primaryAccent,
      ),
      selectedRowColor: primaryAccent,
      iconTheme: baseTheme.iconTheme.copyWith(color: primaryContrast),
      primaryIconTheme:
          baseTheme.primaryIconTheme.copyWith(color: secondaryAccent),
      accentIconTheme: baseTheme.accentIconTheme.copyWith(color: primary),
      cardTheme: baseTheme.cardTheme.copyWith(color: primaryLevel2),
      appBarTheme: baseTheme.appBarTheme,
      bottomAppBarTheme: baseTheme.bottomAppBarTheme.copyWith(color: primary),
      dialogTheme:
          baseTheme.dialogTheme.copyWith(backgroundColor: primaryLevel2),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: primaryAccent,
        foregroundColor: primaryContrastPale,
      ),
      buttonTheme: baseTheme.buttonTheme.copyWith(
        buttonColor: secondaryAccent,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        primary: primaryContrast,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      )),
      navigationRailTheme: baseTheme.navigationRailTheme,
      snackBarTheme: baseTheme.snackBarTheme.copyWith(
        backgroundColor: errorSnackBar,
        actionTextColor: primary,
        disabledActionTextColor: primary,
      ),
      dividerTheme: baseTheme.dividerTheme.copyWith(color: primaryLevel3),
      bottomNavigationBarTheme: baseTheme.bottomNavigationBarTheme.copyWith(
          backgroundColor: primary,
          selectedItemColor: secondaryAccent,
          unselectedItemColor: primaryContrastPale),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: primaryAccent,
      ),

      colorScheme: ColorScheme(
        primary: primary,
        onPrimary: primaryContrast,
        primaryVariant: primaryLevel3,
        secondary: primaryAccent,
        onSecondary: primaryContrast,
        secondaryVariant: secondaryAccent,
        surface: primaryLevel2,
        onSurface: primaryContrast,
        background: primaryContrast,
        onBackground: primaryContrast,
        error: errorSnackBar,
        onError: primaryContrast,
        brightness: brightness,
      ),
    );
  }
}

class SquareSliderThumbShape extends SliderComponentShape {
  const SquareSliderThumbShape({
    this.thumbSize = 13.0,
    this.disabledThumbSize,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  final double thumbSize;

  final double disabledThumbSize;

  double get _disabledThumbRadius => disabledThumbSize ?? thumbSize;

  final double elevation;

  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? thumbSize : _disabledThumbRadius);
  }

  Color getColor(
      SliderThemeData sliderTheme, Animation<double> enableAnimation) {
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    return colorTween.evaluate(enableAnimation);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> sizeTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: thumbSize,
    );

    final Color color = getColor(sliderTheme, enableAnimation);
    final double size = sizeTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    final Path path = Path()..addRect(rect);
    canvas.drawShadow(path, Colors.black, evaluatedElevation, true);

    canvas.drawRect(
      rect,
      Paint()..color = color,
    );
  }
}

class SquareSliderOverlayShape extends SquareSliderThumbShape {
  SquareSliderOverlayShape({
    double thumbSize = 26.0,
    double disabledThumbSize,
  }) : super(thumbSize: thumbSize, disabledThumbSize: disabledThumbSize);

  @override
  Color getColor(
      SliderThemeData sliderTheme, Animation<double> enableAnimation) {
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor.withAlpha(25),
      end: sliderTheme.thumbColor.withAlpha(25),
    );

    return colorTween.evaluate(enableAnimation);
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
