import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    Key? key,
    this.color = Colors.blue,
    required this.icon,
    required this.label,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final colorA = color.withOpacity(0.6);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: colorA,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            label,
            style: GoogleFonts.arvo(
              color: colorA,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
