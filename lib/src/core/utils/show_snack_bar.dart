import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showMessageSnackBar(
  BuildContext context,
  String message, {
  Color? color = Colors.grey,
  Color? textColor = Colors.white,
  required IconData icon,
  required Color iconColor,
}) {
  final theme = Theme.of(context);
  final snackbar = SnackBar(
    backgroundColor: color,
    content: Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const Gap(8),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall!.copyWith(
              color: textColor,
            ),
          ),
        )
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );

  final scaffoldMsg = ScaffoldMessenger.of(context);
  scaffoldMsg
    ..hideCurrentSnackBar()
    ..showSnackBar(snackbar);
}
