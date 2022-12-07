import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/constants/app_theme.dart';

class Util {
  static Widget getCatIcon(int type) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFECECEC)),
        child: Icon(type == 0 ? FontAwesomeIcons.coins : Icons.category,
            color:
                type == 0 ? const Color(0xff06c554) : const Color(0xFFFF7D7D)),
      );
  static void showSnackbar(BuildContext context, String string) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: AppTheme.darkGray,
        content: Text(string),
        duration: const Duration(seconds: 2),
      ));
  }

  static String imageToString(File? imageFile) {
    if (imageFile != null) {
      final bytes = imageFile.readAsBytesSync();
      return base64Encode(bytes);
    }
    return '';
  }

  static getAvatharImage(String? img64) {
    if (img64 != null && img64.trim().isNotEmpty) {
      return MemoryImage(base64Decode(img64));
    } else {
      return const AssetImage('assets/images/person_default.jpg');
    }
  }

  // static ImageProvider<Object> getAvatharImageF(File? imageFile) {
  //   if (imageFile != null) {
  //     return FileImage(imageFile);
  //   } else {
  //     return const AssetImage('assets/images/person_default.jpg');
  //   }
  // }
}
