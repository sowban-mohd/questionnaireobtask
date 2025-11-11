import 'package:flutter_riverpod/flutter_riverpod.dart';

final experiencePageControllerProvider =
    NotifierProvider<
      ExperienceSelectionPageController,
      ExperienceSelectionState
    >(() => ExperienceSelectionPageController());

class ExperienceSelectionPageController
    extends Notifier<ExperienceSelectionState> {
  @override
  ExperienceSelectionState build() {
    return const ExperienceSelectionState(
      selectedExperiences: [],
      isTextFieldNotEmpty: false,
    );
  }

  // Toggle items in the list
  void modifyList(int value) {
    final list = state.selectedExperiences;

    if (list.contains(value)) {
      state = state.copyWith(
        selectedExperiences: list.where((e) => e != value).toList(),
      );
    } else {
      state = state.copyWith(selectedExperiences: [...list, value]);
    }
  }

  bool doesContain(int value) {
    return state.selectedExperiences.contains(value);
  }

  void setTextFieldNotEmpty(bool value) {
    if(state.isTextFieldNotEmpty != value) {
      state = state.copyWith(isTextFieldNotEmpty: value);
    }
  }
}

class ExperienceSelectionState {
  final List<int> selectedExperiences;
  final bool isTextFieldNotEmpty;

  const ExperienceSelectionState({
    required this.selectedExperiences,
    required this.isTextFieldNotEmpty,
  });

  ExperienceSelectionState copyWith({
    List<int>? selectedExperiences,
    bool? isTextFieldNotEmpty,
  }) {
    return ExperienceSelectionState(
      selectedExperiences: selectedExperiences ?? this.selectedExperiences,
      isTextFieldNotEmpty: isTextFieldNotEmpty ?? this.isTextFieldNotEmpty,
    );
  }
}
