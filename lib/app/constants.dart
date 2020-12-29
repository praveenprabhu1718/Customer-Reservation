import 'package:flutter/material.dart';

final primaryColor = Color(0xfffb747c);

final border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16),
  borderSide: BorderSide(),
);

final focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16),
  borderSide: BorderSide(color: primaryColor),
);
