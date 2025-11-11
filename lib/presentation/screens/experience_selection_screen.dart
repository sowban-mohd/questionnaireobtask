import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_host_questionnaire/controller/experiences_provider.dart';
import 'package:hotspot_host_questionnaire/controller/experience_page_controller.dart';
import 'package:hotspot_host_questionnaire/core/color_palette.dart';
import 'package:hotspot_host_questionnaire/presentation/components/navigation_button.dart';
import 'package:hotspot_host_questionnaire/presentation/components/reusable_textfield.dart';
import 'package:hotspot_host_questionnaire/presentation/components/questionnaire_layout.dart';
import 'package:hotspot_host_questionnaire/presentation/screens/questionnaire_screen.dart';

class ExperienceSelectionScreen extends ConsumerStatefulWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  ConsumerState<ExperienceSelectionScreen> createState() =>
      _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState
    extends ConsumerState<ExperienceSelectionScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Whenever text field changes update state
      _textController.addListener(() {
        ref
            .read(experiencePageControllerProvider.notifier)
            .setTextFieldNotEmpty(_textController.text.trim().isNotEmpty);
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final experiencesAsync = ref.watch(experiencesProvider);

    return QuestionnaireLayout(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset("assets/images/bg.png", fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: experiencesAsync.when(
              data: (experiences) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 54.0,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '01',
                                style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: ColorPalette.fontColor1,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "What kind of experiences do you want to host?",
                                style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 12),

                              SizedBox(
                                height: 100,
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    ref.watch(
                                      experiencePageControllerProvider.select(
                                        (state) => state.selectedExperiences,
                                      ),
                                    );
                                    final notifier = ref.read(
                                      experiencePageControllerProvider.notifier,
                                    );
                                    return ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: experiences.length,
                                      itemBuilder: (context, index) {
                                        final experience = experiences[index];
                                        final doesContain = notifier
                                            .doesContain(experience.id);
                                        return InkWell(
                                          onTap: () {
                                            notifier.modifyList(experience.id);
                                          },
                                          child: SizedBox(
                                            width: 96,
                                            height: 96,
                                            child: Image.network(
                                              colorBlendMode: BlendMode.hue,
                                              color: !doesContain
                                                  ? Colors.grey.shade50
                                                  : null,
                                              experience.imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(width: 8);
                                      },
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              ReusableTextfield(
                                controller: _textController,
                                hintText: "/Describe your perfect hotspot",
                                characterLimit: 240,
                                height: 160,
                              ),
                              const SizedBox(height: 16),

                              Consumer(
                                builder: (context, ref, _) {
                                  final state = ref.watch(
                                    experiencePageControllerProvider,
                                  );
                                  final isNavigatable =
                                      state.selectedExperiences.isNotEmpty ||
                                      state.isTextFieldNotEmpty;
                                  final opacity = isNavigatable ? 1.0 : 0.3;
                                  return NavigationButton(
                                    opacity: opacity,
                                    onPressed: () {
                                      if (isNavigatable) {
                                        debugPrint(
                                          ''' Selected Experiences are : ${state.selectedExperiences.toString()}
                                    Hotspot description is : ${_textController.text.trim()}
                                     ''',
                                        );
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                QuestionnaireScreen(),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () =>
                  Center(child: CircularProgressIndicator(color: Colors.white)),

              error: (err, stack) => Center(child: Text(err.toString())),
            ),
          ),
        ],
      ),
      appBarProgress: 1 / 3,
    );
  }
}
