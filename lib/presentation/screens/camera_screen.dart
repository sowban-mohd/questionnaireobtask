import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot_host_questionnaire/controller/questionnaire_page_controller.dart';
import 'dart:io';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  CameraController? _cameraController;
  bool isRecording = false;
  bool isCameraReady = false;

  Future<void> setupCamera() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _cameraController!.initialize();

    if (!mounted) return;

    setState(() {
      isCameraReady = true;
    });
  }

  Future<void> startRecording() async {
    if (!isCameraReady) return;
    if (_cameraController!.value.isRecordingVideo) return;

    await _cameraController!.startVideoRecording();
    setState(() => isRecording = true);
  }

  Future<void> stopRecording() async {
    if (!isCameraReady) return;
    if (!_cameraController!.value.isRecordingVideo) return;

    final file = await _cameraController!.stopVideoRecording();
    setState(() => isRecording = false);

    await ref
        .read(questionnairePageControllerProvider.notifier)
        .addCurrentVideo(file);
  }

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isCameraReady
          ? Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () async {
                  if (isRecording) {
                    await stopRecording();
                    if (mounted) Navigator.of(context).pop();
                  } else {
                    await startRecording();
                  }
                },
                child: isRecording ? Icon(Icons.stop, color: Colors.redAccent,) : Icon(Icons.play_arrow)

              ),
            ),
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
