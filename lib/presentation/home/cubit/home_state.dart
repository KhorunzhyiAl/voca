// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/presentation/entities/word_range.dart';

class HomeState {
  const HomeState({
    this.selectedLanguage,
    this.todaysGoal,
    this.todaysGoalCompleted,
    this.nofWordsCurrentlyLearning,
    this.selectedWordRange,
  });

  final String? selectedLanguage;
  final int? todaysGoal;
  final int? todaysGoalCompleted;
  final int? nofWordsCurrentlyLearning;
  final WordRange? selectedWordRange;

  HomeState copyWith({
    String? selectedLanguage,
    int? todaysGoal,
    int? todaysGoalCompleted,
    int? nofWordsCurrentlyLearning,
    WordRange? selectedWordRange,
  }) {
    return HomeState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      todaysGoal: todaysGoal ?? this.todaysGoal,
      todaysGoalCompleted: todaysGoalCompleted ?? this.todaysGoalCompleted,
      nofWordsCurrentlyLearning:
          nofWordsCurrentlyLearning ?? this.nofWordsCurrentlyLearning,
      selectedWordRange: selectedWordRange ?? this.selectedWordRange,
    );
  }
}
