import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {Key? key,
      this.size = 25,
      this.iconColor = Colors.blue,
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
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 2, spreadRadius: 0),
          ],
          color: Colors.white),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
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
