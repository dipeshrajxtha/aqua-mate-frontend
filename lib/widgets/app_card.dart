import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double padding;
  final VoidCallback? onTap; // Optional tap handler for interactivity

  const AppCard({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.padding = 16.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // We use an InkWell inside a Material widget to handle the tap effect (ripple)
    // while maintaining the card's rounded shape.
    return Material(
      color: backgroundColor,
      // Define the common shape: rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      // Use a slight elevation (shadow) to make the card stand out
      elevation: 4.0,
      child: InkWell(
        // Handle the tap event if provided
        onTap: onTap,
        // Ensure the inkwell respects the rounded borders
        borderRadius: BorderRadius.circular(18.0),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child, // The content of the card (Fish Compatibility, etc.)
        ),
      ),
    );
  }
}