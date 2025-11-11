import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotspot_host_questionnaire/presentation/components/wavy_line.dart';
import 'package:hotspot_host_questionnaire/core/color_palette.dart';

class QuestionnaireLayout extends StatelessWidget {
  final Widget body;
  final double appBarProgress;
  final VoidCallback? onBackButton;

  const QuestionnaireLayout({
    super.key,
    required this.body,
    required this.appBarProgress,
    this.onBackButton
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorPalette.appBarBgColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if(onBackButton != null) onBackButton!();
                },
                child: SvgPicture.asset("assets/images/icons/back_icon.svg"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 54.0),
                  child: WavyLine(
                    size: Size(double.infinity, 40),
                    progress: appBarProgress,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: SvgPicture.asset("assets/images/icons/icon_x.svg"),
              ),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset("assets/images/bg.png", fit: BoxFit.cover),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
