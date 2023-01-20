import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';

class TodaysGoalProgBar extends StatelessWidget {
  const TodaysGoalProgBar({
    required this.goal,
    required this.completed,
    super.key,
  });

  final int goal;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Intls.current.todaysGoal(goal),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeights.bold,
            color: BaseColors.mineShaft,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: BaseColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: BaseColors.black25,
              width: 0.5,
              strokeAlign: StrokeAlign.outside,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (goal == 0) {
                return const SizedBox.shrink();
              }
              final percent = completed / goal;

              return Container(
                decoration: BoxDecoration(
                  color: BaseColors.curiousBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: constraints.maxWidth * percent,
              );
            },
          ),
        ),
      ],
    );
  }
}
