import 'package:flutter/material.dart';

enum ButtonType { primary, secondary }

class CardGuardButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;

  const CardGuardButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return const Color(0xFF96A5B8);
              }
              return type == ButtonType.primary
                  ? const Color(0xFF5A8DEE)
                  : const Color(0xFF161E29);
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white;
              }
              return type == ButtonType.primary
                  ? const Color(0xFF0B1014)
                  : const Color(0xFF5A8DEE);
            },
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide.none,
                );
              }
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: type == ButtonType.secondary
                    ? const BorderSide(color: Color(0xFF5A8DEE), width: 1.5)
                    : BorderSide.none,
              );
            },
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}