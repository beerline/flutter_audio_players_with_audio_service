import 'package:flutter/material.dart';

class ErrorBar extends StatelessWidget {
  final double height;
  final String message;

  const ErrorBar(this.height, this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.error,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
