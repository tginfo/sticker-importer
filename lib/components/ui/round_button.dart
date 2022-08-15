import 'package:flutter/material.dart';

class IconRoundButton extends StatelessWidget {
  const IconRoundButton({
    this.onPressed,
    required this.icon,
    required this.child,
    super.key,
  });

  final void Function()? onPressed;
  final String child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>((isDarkTheme
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onPrimary)),
          foregroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary),
          overlayColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary.withAlpha(50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          ),
          minimumSize: MaterialStateProperty.all<Size>(const Size(150.0, 60.0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 2,
              child: Icon(
                icon,
                size: 30.0,
                color: (isDarkTheme
                    ? Theme.of(context).textTheme.button!.color
                    : null),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                child,
                style: TextStyle(
                  fontSize: 20.0,
                  color: (isDarkTheme
                      ? Theme.of(context).textTheme.button!.color
                      : null),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }
}
