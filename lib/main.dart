import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot_host_questionnaire/presentation/screens/experience_selection_screen.dart';
import 'package:hotspot_host_questionnaire/presentation/screens/questionnaire_screen.dart';
import 'package:hotspot_host_questionnaire/services/api_service.dart';

void main() {
  ApiService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ExperienceSelectionScreen());
  }
}
