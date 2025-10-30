import 'dart:ui';

import 'package:flutter/material.dart';

setColorFilter(int iconIndex, int currentPageIndex) {
  return ColorFilter.mode(
    currentPageIndex == iconIndex ? Colors.black : const Color(0xFF8A8A8A),
    BlendMode.srcIn,
  );
}