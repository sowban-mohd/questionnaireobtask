import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_host_questionnaire/controller/questionnaire_page_controller.dart';
import 'package:hotspot_host_questionnaire/core/color_palette.dart';
import 'package:hotspot_host_questionnaire/core/utils/format_duration.dart';
import 'package:hotspot_host_questionnaire/presentation/components/navigation_button.dart';
import 'package:hotspot_host_questionnaire/presentation/components/reusable_textfield.dart';
import 'package:hotspot_host_questionnaire/presentation/components/questionnaire_layout.dart';
import 'package:hotspot_host_questionnaire/presentation/screens/camera_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  late final TextEditingController _textController;
  late final RecorderController _recorderController;
  late final PlayerController _playerController;

  String? recordedPath;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();

    _recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;

    _playerController = PlayerController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final permission = await _recorderController.checkPermission();
      if (permission == false) {
        await Permission.microphone.request();
      }

      //Updates duration of current recording realtime
      _recorderController.onCurrentDuration.listen((duration) {
        ref
            .read(questionnairePageControllerProvider.notifier)
            .modifyCurrentRecordAudioDuration(duration.inMilliseconds);
      });

      //Updates state whenever text field updates
      _textController.addListener(() {
        ref
            .read(questionnairePageControllerProvider.notifier)
            .setTextFieldNotEmpty(_textController.text.trim().isNotEmpty);
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _recorderController.dispose();
    _playerController.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    await _recorderController.record();
  }

  Future<String?> stopRecording() async {
    return await _recorderController.stop();
  }

  Future<void> play() async {
    if (recordedPath == null) return;
    await _playerController.startPlayer();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      questionnairePageControllerProvider.select(
        (state) => state.isAudioRecording,
      ),
      (_, next) async {
        if (next) {
          await startRecording();
        } else {
          final path = await stopRecording();
          if (path != null) {
            debugPrint("Current path is not null");
            await _playerController.preparePlayer(path: path);
            final duration = _playerController.maxDuration;
            ref
                .read(questionnairePageControllerProvider.notifier)
                .addCurrentAudio(recordedPath: path, ms: duration);
          } else {
            debugPrint("Current path is null");
          }
        }
      },
    );

    final state = ref.watch(questionnairePageControllerProvider);
    final isAudioRecording = state.isAudioRecording;
    final isAudioPlaying = state.isAudioPlaying;
    final currentAudioPath = state.recordedPath;
    final currentAudioDuration = state.currentAudioDuration;
    final currentVideo = state.recordedVideo;
    final currentVideoDuration = state.currentVideoDuration;
    final currentVideoThumbnail = state.currentVideoThumbnail;
    final bool canNavigateToNext =
        currentAudioPath != null ||
        currentVideo != null ||
        state.isTextFieldNotEmpty;

    return QuestionnaireLayout(
      onBackButton: () {
        Navigator.of(context).pop();
      },
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 54.0),
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
                        '02',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: ColorPalette.fontColor1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "What do you want to host with us?",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Tell us about your intent and what motivates you to create experiences.",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: ColorPalette.fontColor1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Column(
                        children: [
                          ReusableTextfield(
                            controller: _textController,
                            height:
                                (currentVideo != null ||
                                    currentAudioPath != null ||
                                    isAudioRecording)
                                ? 160
                                : 358,
                            hintText: "/ Start typing here",
                            characterLimit: 600,
                          ),

                          const SizedBox(height: 12),

                          //Audio recording container
                          if (isAudioRecording)
                            Container(
                              height: 132,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: AlignmentGeometry.topCenter,
                                  end: AlignmentGeometry.bottomCenter,
                                  colors: ColorPalette.buttonBorderGradient,
                                ),
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  padding: EdgeInsetsGeometry.all(12),
                                  decoration: BoxDecoration(
                                    backgroundBlendMode: BlendMode.srcOver,
                                    gradient: RadialGradient(
                                      colors: ColorPalette.buttonGradient,
                                      center: const Alignment(-1.0, -0.8),
                                      radius: 0.0,
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                    borderRadius: BorderRadiusGeometry.circular(
                                      12,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Recording Audio...",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: ColorPalette.fontColor1,
                                        ),
                                      ),
                                      if (currentAudioPath == null)
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    ColorPalette.progressColor,
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  "assets/images/icons/audio_icon.svg",
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            Expanded(
                                              child: AudioWaveforms(
                                                size: Size(double.infinity, 50),
                                                recorderController:
                                                    _recorderController,
                                                waveStyle: WaveStyle(
                                                  showMiddleLine: false,
                                                  extendWaveform: true,
                                                  waveColor: Colors.white,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            Consumer(
                                              builder: (context, ref, _) {
                                                final recordDuration = ref.watch(
                                                  questionnairePageControllerProvider
                                                      .select(
                                                        (state) => state
                                                            .currentAudioRecordDuration,
                                                      ),
                                                );
                                                return Text(
                                                  recordDuration ?? "0:00",
                                                  style:
                                                      GoogleFonts.spaceGrotesk(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: ColorPalette
                                                            .progressColor,
                                                      ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          //Video recorded container
                          if (currentVideo != null)
                            Container(
                              height: 64,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.05),
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (currentVideoThumbnail != null)
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Image.file(
                                        fit: BoxFit.contain,
                                        File(currentVideoThumbnail),
                                      ),
                                    ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Video Recorded",
                                          style: GoogleFonts.spaceGrotesk(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        Text(
                                          "•",
                                          style: TextStyle(
                                            color: ColorPalette.fontColor1,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        if (currentVideoDuration != null)
                                          Text(
                                            formatDuration(
                                              currentVideoDuration,
                                            ),
                                            style: GoogleFonts.spaceGrotesk(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: ColorPalette.fontColor1,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(
                                              questionnairePageControllerProvider
                                                  .notifier,
                                            )
                                            .deleteCurrentVideo();
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/icons/delete_icon.svg",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          //Audio playback container
                          if (currentAudioPath != null)
                            Container(
                              height: 132,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: AlignmentGeometry.topCenter,
                                  end: AlignmentGeometry.bottomCenter,
                                  colors: ColorPalette.buttonBorderGradient,
                                ),
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  padding: EdgeInsetsGeometry.all(12),
                                  decoration: BoxDecoration(
                                    backgroundBlendMode: BlendMode.srcOver,
                                    gradient: RadialGradient(
                                      colors: ColorPalette.buttonGradient,
                                      center: const Alignment(-1.0, -0.8),
                                      radius: 0.0,
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                    borderRadius: BorderRadiusGeometry.circular(
                                      12,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Audio Recorded",
                                            style: GoogleFonts.spaceGrotesk(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: ColorPalette.fontColor1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                ref
                                                    .read(
                                                      questionnairePageControllerProvider
                                                          .notifier,
                                                    )
                                                    .deleteCurrentAudio();
                                              },
                                              child: SvgPicture.asset(
                                                "assets/images/icons/delete_icon.svg",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      Row(
                                        children: [
                                          if (!isAudioPlaying) ...[
                                            InkWell(
                                              onTap: () async {
                                                await _playerController
                                                    .startPlayer();
                                                ref
                                                    .read(
                                                      questionnairePageControllerProvider
                                                          .notifier,
                                                    )
                                                    .toggleAudioPlaying();
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ColorPalette
                                                      .progressColor,
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/images/icons/play_icon.svg",
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 12),
                                          ],

                                          Expanded(
                                            child: AudioFileWaveforms(
                                              size: Size(double.infinity, 50),
                                              playerController:
                                                  _playerController,
                                              playerWaveStyle: PlayerWaveStyle(
                                                fixedWaveColor: Colors.white,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          Text(
                                            currentAudioDuration ?? "0:00",
                                            style: GoogleFonts.spaceGrotesk(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: ColorPalette.fontColor1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),

                          //Bottom buttons
                          Row(
                            children: [
                              if (currentAudioPath == null &&
                                  currentVideo == null) ...[
                                //Audio & video record buttons
                                Container(
                                  width: 112,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.08,
                                      ),
                                    ),
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            ref
                                                .read(
                                                  questionnairePageControllerProvider
                                                      .notifier,
                                                )
                                                .toggleAudioRecord();
                                          },
                                          child: Container(
                                            decoration: isAudioRecording
                                                ? BoxDecoration(
                                                    backgroundBlendMode:
                                                        BlendMode.srcOver,
                                                    gradient: RadialGradient(
                                                      colors: ColorPalette
                                                          .buttonGradient,
                                                      center: const Alignment(
                                                        -1.0,
                                                        -0.8,
                                                      ),
                                                      radius: 1.5,
                                                      stops: const [
                                                        0.0,
                                                        0.5,
                                                        1.0,
                                                      ],
                                                    ),
                                                  )
                                                : null,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                "assets/images/icons/audio_icon.svg",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 20,
                                        color: Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          0.08,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              if (!isAudioRecording) {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CameraScreen(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Opacity(
                                              opacity: isAudioRecording
                                                  ? 0.3
                                                  : 1.0,
                                              child: SvgPicture.asset(
                                                "assets/images/icons/video_icon.svg",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),
                              ],

                              //Next button
                              Expanded(
                                child: NavigationButton(
                                  opacity: canNavigateToNext ? 1.0 : 0.3,
                                  onPressed: () {
                                    if (canNavigateToNext) {
                                      debugPrint(
                                        ''' Recorded Audio Path is : $currentAudioPath
                                  Recorded Video Path is : ${currentVideo?.path}
                                  User's motivation to host is : ${_textController.text.trim()}
                                  ''',
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBarProgress: 2 / 3,
    );
  }
}
