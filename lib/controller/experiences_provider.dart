import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot_host_questionnaire/models/experience.dart';
import 'package:hotspot_host_questionnaire/repository/experiences_repository.dart';

final experiencesProvider =
FutureProvider<List<Experience>>((ref) async {
  final repo = ref.read(experiencesRepoProvider);
  final result = await repo.getExperiences();

  if (result.isSuccess) {
    return result.data!;
  } else {
    throw result.error!.message;
  }
});
