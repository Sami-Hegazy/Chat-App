import 'package:flutter/material.dart';

void showCustomSnackbar(
    BuildContext context, String message, IconData iconData, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 10),
          Text(message, style: const TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    ),
  );
}
