import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final String label;

  const CustomElevatedButton({
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromARGB(255, 128, 132, 157),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(0, 50)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: iconColor,
          ),
          Text(label),
        ],
      ),
    );
  }
}
