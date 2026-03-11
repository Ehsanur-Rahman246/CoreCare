import 'package:core_care/main.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FitScreen extends StatefulWidget {
  const FitScreen({super.key});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

enum BoxState { normal, today, notCompleted, completed, hasSchedule, cancelled }

class _FitScreenState extends State<FitScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Symbols.exercise),
        title: Text('Exercise Module'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'This Week',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                box("Sun\n1", BoxState.notCompleted),
                box("Mon\n2", BoxState.completed),
                box("Tue\n3", BoxState.today),
                box("Wed\n4", BoxState.normal),
                box("Thu\n5", BoxState.normal),
                box("Fri\n6", BoxState.hasSchedule),
                box("Sat\n7", BoxState.cancelled),
              ],
            ),
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Today\'s exercises',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  exerciseCard("Push Up", "15 reps"),
                  exerciseCard("Squat", "20 reps"),
                  exerciseCard("Plank", "30 reps"),
                  exerciseCard("Jumping Jack", "25 reps"),
                  exerciseCard("Lunges", "15 reps"),
                  exerciseCard("Sit Up", "20 reps"),
                  exerciseCard("Burpees", "10 reps"),
                  exerciseCard("Mountain Climber", "20 sec"),
                  exerciseCard("High Knees", "30 sec"),
                  exerciseCard("Stretching", "5 min"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget box(String text, BoxState state) {
    Decoration decoration;
    IconData? icon;
    Color? color;
    bool isToday(BoxState state) => state == BoxState.today;

    switch (state) {
      case BoxState.normal:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: BoxBorder.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        );
        icon = null;
        color = null;
        break;
      case BoxState.today:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: BoxBorder.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        );
        icon = null;
        color = null;
        break;
      case BoxState.notCompleted:
        decoration = BoxDecoration(
          color: CustomColors.redMuted(context),
          border: BoxBorder.all(color: CustomColors.redOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Icons.cancel_outlined;
        color = CustomColors.redOutline(context);
        break;
      case BoxState.completed:
        decoration = BoxDecoration(
          color: CustomColors.greenMuted(context),
          border: BoxBorder.all(color: CustomColors.greenOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Icons.check_circle_outline;
        color = CustomColors.greenOutline(context);
        break;
      case BoxState.hasSchedule:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: BoxBorder.all(color: CustomColors.greenOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Icons.event_available;
        color = Theme.of(context).colorScheme.onSurface;
        break;
      case BoxState.cancelled:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: BoxBorder.all(color: CustomColors.redOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Icons.event_busy;
        color = Theme.of(context).colorScheme.onSurface;
        break;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
        },
        child: Container(
          height: isToday(state) ? 84 : 70,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: decoration,
          child: Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Icon(icon, color: color, size: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget exerciseCard(String name, String rep) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.bodyLarge),
                  Text(rep, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.chevron_right)),
            ],
          ),
        ),
      ),
    );
  }
}
