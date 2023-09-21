import 'package:flutter/material.dart';

class CustomElevatedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final Widget label;

  const CustomElevatedIconButton({
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    this.label = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromARGB(255, 128, 132, 157),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(0, 50)),
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 22,
        color: iconColor,
      ),
      label: label,
    );
  }
}
