import 'package:flutter/material.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/theming/base_theme.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/clicable_card.dart';
import 'package:voca/presentation/common_widgets/card_repetition_indicator.dart';

class WordListEntry extends StatelessWidget {
  const WordListEntry({
    super.key,
    required this.onTap,
    required this.card,
    required this.maxRepetitionCount,
    this.searchedWord = '',
  });

  final WordCard card;
  final String searchedWord;
  final int maxRepetitionCount;
  final void Function(WordCard card) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50,
      child: ClickableCard(
        onTap: () => onTap(card),
        child: BaseCard(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              buildWord(context),
              const SizedBox(width: 5),
              buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildWord(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: RichText(
        text: TextSpan(
          children: buildWordSpans(context),
          style: DefaultTextStyle.of(context).style.merge(
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeights.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
        ),
      ),
    );
  }

  List<InlineSpan> buildWordSpans(BuildContext context) {
    var queryLetter = searchedWord.characters.iterator..moveNext();
    final textSpans = <InlineSpan>[];

    final theme = Theme.of(context);

    for (final letter in card.word.name.characters) {
      if (letter == queryLetter.current && queryLetter.isNotEmpty) {
        textSpans.add(TextSpan(
          text: letter,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ));

        !queryLetter.moveNext();
      } else {
        textSpans.add(TextSpan(text: letter));
      }
    }

    return textSpans;
  }

  Widget buildProgressIndicator() {
    switch (card.status) {
      case WordCardStatus.learning:
        return Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: CardRepetitionIndicator(
              repetitionCount: card.repetitionCount,
              maxRepetitionCount: maxRepetitionCount,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
