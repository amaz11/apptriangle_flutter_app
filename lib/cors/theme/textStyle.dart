import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle title32 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 32,
    color: Colors.black,
  );
  static final title22 = title32.copyWith(fontSize: 22);
  static final title16 = title32.copyWith(fontSize: 16);
  static final regular18 = title32.copyWith(fontSize: 18);
  static final regular16 = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
  static final regular15 = regular16.copyWith(fontSize: 15);
  static final regular14 = regular16.copyWith(
    fontSize: 14,
  );
  static final regular14White = regular16.copyWith(
    fontSize: 14,
    color: Colors.white,
  );
  static final regular12 = regular16.copyWith(
    fontSize: 12,
  );

  static final regular11 = regular16.copyWith(
    fontSize: 11,
  );
}
