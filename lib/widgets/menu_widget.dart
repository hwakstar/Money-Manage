import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Menu',
        onPressed: () {
          DrawerScaffold.currentController(context).toggle();
        },
        icon: const Icon(Icons.menu));
  }
}
