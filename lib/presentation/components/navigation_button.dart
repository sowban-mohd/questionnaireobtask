import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_host_questionnaire/core/color_palette.dart';

class NavigationButton extends StatelessWidget {
  final double opacity;
  final VoidCallback onPressed;

  const NavigationButton({super.key, required this.opacity, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsetsGeometry.symmetric(horizontal: 6),
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
              colors: ColorPalette.buttonBorderGradient,
            ),
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(1),
            child: Container(
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.srcOver,
                gradient: RadialGradient(
                  colors: ColorPalette.buttonGradient,
                  center: const Alignment(-1.0, -0.8),
                  radius: 0.0,
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Next",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      "assets/images/icons/arrow.svg",
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
