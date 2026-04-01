import 'package:core_care/main.dart';
import 'package:core_care/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

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
    final day = context.watch<TimeProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Symbols.exercise),
        title: Text('Exercise Module'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case 0:
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.history_rounded),
                      const SizedBox(width: 8),
                      Text("History"),
                    ],
                  ),
                ),
              ];
            },
            icon: Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [FloatingActionButton.small(heroTag: 'tutorial', onPressed: (){Navigator.pushNamed(context, '/tutorial');}), const SizedBox(height: 10,),FloatingActionButton.small(heroTag: 'schedule', onPressed: (){Navigator.pushNamed(context, '/schedule');}),]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'This Week',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (i){
                final now = day.now;
                final firstDayOfWeek = now.subtract(Duration(days: now.weekday % 7));
                final date = firstDayOfWeek.add(Duration(days: i));
                BoxState state;
                if(date.day == now.day && date.month == now.month && date.year == now.year){
                  state = BoxState.today;
                }
                else{
                  state = BoxState.normal;
                }
                final dayName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
                final text = "$dayName\n${date.day}";

                return weekBox(text, state);
              })
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Today\'s exercises',
                style: Theme.of(context).textTheme.bodyLarge,
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

  Widget weekBox(String date, BoxState state) {
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
          border: BoxBorder.all(color: CustomColors.blueOutline(context)),
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
                date,
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

class ExerciseScheduleScreen extends StatefulWidget {
  const ExerciseScheduleScreen({super.key});

  @override
  State<ExerciseScheduleScreen> createState() => _ExerciseScheduleScreenState();
}

class _ExerciseScheduleScreenState extends State<ExerciseScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

class ExerciseTutorialScreen extends StatefulWidget {
  const ExerciseTutorialScreen({super.key});

  @override
  State<ExerciseTutorialScreen> createState() => _ExerciseTutorialScreenState();
}

class _ExerciseTutorialScreenState extends State<ExerciseTutorialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
