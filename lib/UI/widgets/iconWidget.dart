import 'package:flutter/cupertino.dart';

Widget iconWidget(icon, ontap, double size, color) {
  return GestureDetector(
      onTap: ontap,
      child: Icon(
        icon,
        size: size,
        color: color,
      ));
}
