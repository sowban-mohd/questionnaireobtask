import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_host_questionnaire/core/color_palette.dart';

class ReusableTextfield extends StatelessWidget {
  final TextEditingController controller;
  final double height;
  final int characterLimit;
  final String hintText;

  const ReusableTextfield({super.key, required this.controller, required this.height, required this.characterLimit, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.textFieldBgColor,
      height: height,
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        maxLines: null,
        inputFormatters: [LengthLimitingTextInputFormatter(characterLimit)],
        keyboardType: TextInputType.multiline,
        style: GoogleFonts.spaceGrotesk(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.spaceGrotesk(
            color: ColorPalette.fontColor1,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
          contentPadding: EdgeInsets.all(12),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
