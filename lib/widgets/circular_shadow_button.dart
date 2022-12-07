import 'package:flutter/material.dart';

class CircularShadowButton extends StatelessWidget {
  const CircularShadowButton(
      {Key? key,
      this.size = 25,
      this.iconColor = Colors.black,
      required this.onPressed,
      required this.icon})
      : super(key: key);
  final double size;
  final Function onPressed;
  final IconData icon;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade600,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          const BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 2,
              spreadRadius: 1),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
            Colors.grey.shade400,
            Colors.grey.shade500,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderOnForeground: true,
        type: MaterialType.circle,
        elevation: 0,
        child: InkWell(
            highlightColor: Colors.grey.withOpacity(.5),
            onTap: () {
              onPressed();
            },
            child: Align(
              child: Icon(
                icon,
                size: 15,
                color: iconColor,
              ),
            )),
      ),
    );
  }
}
