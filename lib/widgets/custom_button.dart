import 'package:flutter/material.dart';

enum CustomButtonType { primary, secondary, tertiary }

class CustomButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final CustomButtonType type;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.icon,
    this.type = CustomButtonType.primary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = switch (type) {
      CustomButtonType.primary => ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      CustomButtonType.secondary => ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      CustomButtonType.tertiary => OutlinedButton.styleFrom(),
    };

    if (icon != null) {
      return ElevatedButton.icon(
        style: style,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}