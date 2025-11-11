import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;

final questionnairePageControllerProvider =
    NotifierProvider<QuestionnairePageController, QuestionnairePageState>(
      QuestionnairePageController.new,
    );

class QuestionnairePageController extends Notifier<QuestionnairePageState> {
  @override
  QuestionnairePageState build() {
    return const QuestionnairePageState(
      isTextFieldNotEmpty: false,
      isAudioRecording: false,
      isAudioPlaying: false,
    );
  }

  void setTextFieldNotEmpty(bool value) {
    if (state.isTextFieldNotEmpty != value) {
      state = state.copyWith(
        isTextFieldNotEmpty: value,
        recordedPath: state.recordedPath,
        currentAudioDuration: state.currentAudioDuration,
        recordedVideo: state.recordedVideo,
        currentVideoThumbnail: state.currentVideoThumbnail,
        currentVideoDuration: state.currentVideoDuration,
      );
    }
  }

  void toggleAudioRecord() {
    if (state.isAudioRecording) {
      state.copyWith(currentAudioRecordDuration: null);
    }
    state = state.copyWith(isAudioRecording: !state.isAudioRecording);
  }

  void toggleAudioPlaying() {
    state = state.copyWith(
      isAudioPlaying: !state.isAudioPlaying,
      recordedPath: state.recordedPath,
      currentAudioDuration: state.currentAudioDuration,
    );
  }

  void addCurrentAudio({required String recordedPath, required int ms}) {
    final seconds = (ms ~/ 1000) % 60;
    final minutes = (ms ~/ 60000);
    state = state.copyWith(
      recordedPath: recordedPath,
      currentAudioDuration:
          "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
    );
    debugPrint("Added current aduio succesfullt");
  }

  Future<void> addCurrentVideo(XFile videoFile) async {
    final thumb = await vt.VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      imageFormat: vt.ImageFormat.JPEG,
      maxWidth: 200,
      quality: 75,
    );

    final vp = VideoPlayerController.file(File(videoFile.path));
    await vp.initialize();

    final duration = vp.value.duration;

    state = state.copyWith(
      recordedVideo: videoFile,
      currentVideoThumbnail: thumb,
      currentVideoDuration: duration,
    );
  }

  void deleteCurrentVideo() {
    state = state.copyWith(
      currentVideoDuration: null,
      currentVideoThumbnail: null,
      recordedVideo: null,
    );
  }

  void deleteCurrentAudio() {
    state = state.copyWith(
      recordedPath: null,
      currentAudioDuration: null,
      isAudioPlaying: null,
    );
  }

  void modifyCurrentRecordAudioDuration(int ms) {
    final seconds = (ms ~/ 1000) % 60;
    final minutes = (ms ~/ 60000);
    state = state.copyWith(
      currentAudioRecordDuration:
          "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
    );
  }
}

class QuestionnairePageState {
  final bool isTextFieldNotEmpty;
  final bool isAudioRecording;
  final String? currentAudioRecordDuration;
  final String? recordedPath;
  final String? currentAudioDuration;
  final bool isAudioPlaying;
  final XFile? recordedVideo;
  final Duration? currentVideoDuration;
  final String? currentVideoThumbnail;

  const QuestionnairePageState({
    required this.isTextFieldNotEmpty,
    required this.isAudioRecording,
    required this.isAudioPlaying,
    this.currentAudioRecordDuration,
    this.recordedPath,
    this.currentAudioDuration,
    this.recordedVideo,
    this.currentVideoDuration,
    this.currentVideoThumbnail,
  });

  QuestionnairePageState copyWith({
    bool? isTextFieldNotEmpty,
    bool? isAudioRecording,
    String? currentAudioRecordDuration,
    String? recordedPath,
    String? currentAudioDuration,
    bool? isAudioPlaying,
    XFile? recordedVideo,
    Duration? currentVideoDuration,
    String? currentVideoThumbnail,
  }) {
    return QuestionnairePageState(
      isTextFieldNotEmpty: isTextFieldNotEmpty ?? this.isTextFieldNotEmpty,
      isAudioRecording: isAudioRecording ?? this.isAudioRecording,
      currentAudioRecordDuration: currentAudioRecordDuration,
      recordedPath: recordedPath,
      currentAudioDuration: currentAudioDuration,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      recordedVideo: recordedVideo,
      currentVideoDuration: currentVideoDuration,
      currentVideoThumbnail: currentVideoThumbnail,
    );
  }
}
