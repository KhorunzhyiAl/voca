import 'package:flutter/material.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/widgets/placeholder.dart';

// TODO: should be defined in the language package, not localized
String mapPos(PartOfSpeech pos) {
  switch (pos) {
    case PartOfSpeech.adjective:
      return 'Adjective';
    case PartOfSpeech.adverb:
      return 'Adverb';
    case PartOfSpeech.noun:
      return 'Noun';
    case PartOfSpeech.verb:
      return 'Verb';
  }
}

class WordDefinitionsWidget extends StatelessWidget {
  const WordDefinitionsWidget({
    required this.definitions,
    super.key,
  });

  static Widget get placeholder => const _WordDefinitionsPlaceholder();

  final List<WordDefinition> definitions;

  @override
  Widget build(BuildContext context) {
    final posDefinitions = <PartOfSpeech, List<WordDefinition>>{};

    for (final definition in definitions) {
      final curr = posDefinitions[definition.pos] ??
          (posDefinitions[definition.pos] = []);

      curr.add(definition);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entry in posDefinitions.entries) ...[
            buildPosName(entry.key),
            const SizedBox(height: 10),
            ...buildDefinitionsForPos(entry.value),
          ],
        ],
      ),
    );
  }

  List<Widget> buildDefinitionsForPos(List<WordDefinition> definitions) {
    return [
      for (var i = 0; i < definitions.length; ++i)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              alignment: Alignment.centerRight,
              child: Text(
                (i + 1).toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: BaseColors.curiousBlue,
                  fontWeight: FontWeights.extraBold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildDefinition(definitions[i]),
            ),
          ],
        ),
      const SizedBox(height: 10),
    ];
  }

  Widget buildPosName(PartOfSpeech pos) {
    return Text(
      mapPos(pos),
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeights.bold,
        color: BaseColors.curiousBlue,
      ),
    );
  }

  Widget buildDefinition(WordDefinition definition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.definition,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeights.regular,
          ),
        ),
        for (final example in definition.examples) ...[
          Text(
            '"$example"',
            style: const TextStyle(
              color: BaseColors.grey,
              fontSize: 15,
              fontWeight: FontWeights.light,
            ),
          ),
        ]
      ],
    );
  }
}

class _WordDefinitionsPlaceholder extends StatelessWidget {
  const _WordDefinitionsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlaceholderCard(
            width: 100,
            height: 25,
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < 3; ++i) ...[
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: PlaceholderCard(height: 15),
            ),
            const SizedBox(height: 10),
          ]
        ],
      ),
    );
  }
}
