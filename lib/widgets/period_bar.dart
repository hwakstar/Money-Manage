import 'package:flutter/material.dart';
import 'package:money_manager/widgets/circular_shadow_button.dart';

class PeriodBar extends StatelessWidget {
  const PeriodBar(
      {Key? key,
      this.backgroundDecoration,
      required this.onPrevPress,
      required this.onNextPress,
      required this.title})
      : super(key: key);
  final BoxDecoration? backgroundDecoration;
  final String title;
  final Function onPrevPress;
  final Function onNextPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: backgroundDecoration == null
          ? const EdgeInsets.all(5)
          : const EdgeInsets.all(0),
      decoration: backgroundDecoration ??
          BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
              const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-3, -3),
                  blurRadius: 3,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularShadowButton(
              icon: Icons.arrow_back_ios,
              iconColor: Colors.blue,
              onPressed: () {
                onPrevPress();
              },
            ),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularShadowButton(
                icon: Icons.arrow_forward_ios,
                iconColor: Colors.blue,
                onPressed: () {
                  onNextPress();
                },
              ))
        ],
      ),
    );
  }
}
