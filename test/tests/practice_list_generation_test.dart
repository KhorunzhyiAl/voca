import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/injectable/injectable_init.dart';

import '../base/utils/days.dart';
import '../base/utils/prepare_words.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(InjectableEnv.test);

  final wordsRepo = getIt.get<WordsRepository>();
  final practiceRepo = getIt.get<PracticeRepository>();

  final words = await prepareWords(wordsRepo);

  group('Practice list generation', () {
    test(
      'Newly added words show up instantly',
      () async {
        await withClock(day1, () async {
          await wordsRepo.setWordCardStatus(words[0], WordCardStatus.learning);
          await wordsRepo.setWordCardStatus(words[1], WordCardStatus.learning);

          final list = await practiceRepo.createPracticeList();

          expect(list.length == 2, true);
          _expectContains(list, words[0], contains: true);
          _expectContains(list, words[1], contains: true);
        });
      },
    );

    test(
      "Word doesn't show up the same day after incrementing its progress",
      () async {
        await withClock(day1, () async {
          await practiceRepo.incrementCard(words[0]);
          final list = await practiceRepo.createPracticeList();
          _expectContains(list, words[0], contains: false);
        });
      },
    );

    test(
      "Words show up according to the intervals",
      () async {
        await withClock(day1, () async {
          await wordsRepo.setWordCardRepetitions(words[0], 1);
          await wordsRepo.setWordCardRepetitions(words[1], 3);

          final list = await practiceRepo.createPracticeList();

          _expectContains(list, words[0], contains: false, msg: 'day1');
          _expectContains(list, words[1], contains: false, msg: 'day1');
        });

        await withClock(day2, () async {
          final list = await practiceRepo.createPracticeList();
          _expectContains(list, words[0], contains: true, msg: 'day2');
          _expectContains(list, words[1], contains: false, msg: 'day2');
        });

        await withClock(day3, () async {
          final list = await practiceRepo.createPracticeList();
          _expectContains(list, words[0], contains: true, msg: 'day3');
          _expectContains(list, words[1], contains: true, msg: 'day3');
        });
      },
    );

    test(
      "Word shows up instantly after resetting its progress",
      () async {
        await withClock(day1, () async {
          await wordsRepo.setWordCardRepetitions(words[0], 4);
          final list1 = await practiceRepo.createPracticeList();
          _expectContains(list1, words[0], contains: false);

          await practiceRepo.resetCard(words[0]);
          final list2 = await practiceRepo.createPracticeList();
          _expectContains(list2, words[0], contains: true);
        });
      },
    );

    test(
      "Word with complete progress doesn't show up",
      () async {
        await withClock(day1, () async {
          await wordsRepo.setWordCardRepetitions(
            words[0],
            DomainConstants.maxCardRepetitionsSetting,
          );
        });

        await withClock(dayALot, () async {
          final list = await practiceRepo.createPracticeList();
          _expectContains(list, words[0], contains: false);
        });
      },
    );
  });
}

void _expectContains(
  List<WordCard> list,
  Word word, {
  required bool contains,
  String? msg,
}) {
  expect(list.any((card) => card.word == word), contains, reason: msg);
}
