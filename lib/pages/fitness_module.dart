import 'package:core_care/main.dart';
import 'package:core_care/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'home_screen.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

class FitScreen extends StatefulWidget {
  const FitScreen({super.key});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

enum BoxState { normal, today, notCompleted, completed, restDay, cancelled }

class _FitScreenState extends State<FitScreen>
    with SingleTickerProviderStateMixin {
  late IconData statusIcon;
  bool warmupCompleted = false;
  bool exerciseCompleted = false;
  bool stretchesCompleted = false;

  @override
  Widget build(BuildContext context) {
    final day = context.watch<TimeProvider>();
    final currentStatus = context.watch<StatusProvider>().status;
    switch (currentStatus) {
      case Status.fasting:
        statusIcon = Symbols.hourglass_arrow_down_rounded;
        break;
      case Status.travelling:
        statusIcon = Symbols.travel_rounded;
        break;
      case Status.injured:
        statusIcon = Symbols.healing_rounded;
        break;
      case Status.sick:
        statusIcon = Symbols.sick_rounded;
        break;
      case Status.active:
        statusIcon = Symbols.directions_run_rounded;
        break;
      case Status.rest:
        statusIcon = Symbols.bed_rounded;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Symbols.exercise),
        title: Text('Exercise Module'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case 0:
                  Navigator.pushNamed(context, '/fitH');
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'tutorial',
            onPressed: () {
              Navigator.pushNamed(context, '/tutorial');
            },
            child: Icon(Symbols.play_lesson_rounded),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.small(
            heroTag: 'schedule',
            onPressed: () {
              Navigator.pushNamed(context, '/schedule');
            },
            child: Icon(Symbols.calendar_month_rounded),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'This Week',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (i) {
                  final now = day.now;
                  final firstDayOfWeek = now.subtract(
                    Duration(days: now.weekday % 7),
                  );
                  final date = firstDayOfWeek.add(Duration(days: i));
                  BoxState state;
                  if (date.day == now.day &&
                      date.month == now.month &&
                      date.year == now.year) {
                    state = BoxState.today;
                  } else {
                    state = BoxState.normal;
                  }
                  final dayName = [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ][date.weekday % 7];
                  final text = "$dayName\n${date.day}";

                  return weekBox(text, state);
                }),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Today\'s exercises',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 5),
              if(currentStatus == Status.injured)
                Center(child: Text("You're Injured!!\nNo exercises for you today\nHeal up soon", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall,),)
              else if(currentStatus == Status.sick)
                Center(child: Text("You're Sick!\nNo exercises for you today\nHeal up soon", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall,),)
              else if(currentStatus == Status.rest)
                  Center(child: Text("It's your rest day\nNo exercise today\nRemember to take a walk", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall,),)
              else ...[
                if(currentStatus == Status.travelling) ...[
                  Center(child: Text("Safe Travelling\nIf you get time do your regular exercises", textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium,),),
                  const SizedBox(height: 5,),
                ],
                Expanded(
                  child: ListView(
                    children: [
                      ExerciseList(time: '08:30AM', title: "Warm Ups", subtitle: Text("50kcal"), trailing: TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => WarmupScreen()));}, child: Text('Start')), burn: '200kcal', isCompleted: true, isPast: true, icon: Icons.eighteen_mp, isFirst: true,),
                      ExerciseList(time: '08:30AM', title: "Main Workouts", subtitle: Text("380kcal"), trailing: TextButton(onPressed: (){}, child: Text('Start')), burn: '200kcal', isCompleted: true, isPast: true, icon: Icons.eighteen_mp,),
                      ExerciseList(time: '08:30AM', title: "Stretches", subtitle: Text("10kcal"), trailing: TextButton(onPressed: (){}, child: Text('Start')), burn: '200kcal', isCompleted: true, isPast: true, icon: Icons.eighteen_mp, isLast: true,),
                    ],
                  ),
                ),
              ]
            ],
          ),
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
        icon = statusIcon;
        color = Theme.of(context).colorScheme.onPrimary;
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
      case BoxState.restDay:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: BoxBorder.all(color: CustomColors.blueOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Icons.bed_rounded;
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
        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => DayScreen()));},
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
}

class ExerciseList extends StatefulWidget {
  final String time;
  final String title;
  final Widget subtitle;
  final Widget trailing;
  final String burn;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;
  final bool isPast;
  final IconData icon;
  final bool prevIsPast;
  final bool prevIsCompleted;
  const ExerciseList({super.key, required this.time, required this.title, required this.subtitle, required this.trailing, required this.burn, this.isFirst = false, this.isLast = false, required this.isCompleted, required this.isPast, required this.icon, this.prevIsPast = false, this.prevIsCompleted = false});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.20,
      isFirst: widget.isFirst,
      isLast: widget.isLast,

      startChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(widget.time, textAlign: TextAlign.right, style: th.labelMedium,)
      ),

      endChild: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isCompleted ? CustomColors.greenMuted(context) : ch.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.isCompleted ? CustomColors.greenOutline(context) : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(widget.icon),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: th.bodyLarge,),
                const SizedBox(height: 10,),
                widget.subtitle,
              ],
            ),
            Spacer(),
            widget.trailing,
          ],
        ),
      ),

      indicatorStyle: IndicatorStyle(
        width: 12,
        color: (widget.isPast && !widget.isCompleted) ? CustomColors.redOutline(context) : (widget.isPast && widget.isCompleted) ? CustomColors.greenOutline(context) : ch.primary,
      ),

      beforeLineStyle: LineStyle(
        thickness: 2,
        color: (widget.prevIsPast && !widget.prevIsCompleted) ? CustomColors.redOutline(context) : (widget.prevIsPast && widget.prevIsCompleted) ? CustomColors.greenOutline(context) : ch.primary,
      ),
      afterLineStyle: LineStyle(
        thickness: 2,
        color: (widget.isPast && !widget.isCompleted) ? CustomColors.redOutline(context) : (widget.isPast && widget.isCompleted) ? CustomColors.greenOutline(context) : ch.primary,
      ),
    );
  }
}

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final time = context.watch<TimeProvider>();
    final status = context.watch<StatusProvider>().status;
    final fit = context.watch<FitnessProvider>();
    fit.loadExercises();
    String currStat = '';
    IconData? avatar;

    switch (status) {
      case Status.fasting:
        currStat = 'Fasting';
        avatar = Symbols.hourglass_arrow_down_rounded;
        break;
      case Status.travelling:
        currStat = 'Travelling';
        avatar = Symbols.travel_rounded;
        break;
      case Status.injured:
        currStat = 'Injured';
        avatar = Symbols.healing_rounded;
        break;
      case Status.sick:
        currStat = 'Sick';
        avatar = Symbols.sick_rounded;
        break;
      case Status.active:
        currStat = 'Active';
        avatar = Symbols.directions_run_rounded;
        break;
      case Status.rest:
        currStat = 'On Rest';
        avatar = Symbols.bed_rounded;
        break;
    }
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Today'),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ch.surface,
              ),
              child: Column(
                children: [
                  Text(time.formatDate, style: th.headlineSmall,),
                  const SizedBox(height: 10,),
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: "$currStat  ", style: th.titleMedium,),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(avatar, size: 30, color: ch.onSurface,)
                      ),
                    ]
                  )),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Exercises:",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "${fit.done} / ${fit.totalExe} left",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Calories Burned:",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "${fit.burnedCal} kcal",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Progress: ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: '${fit.progress *100}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: fit.progress,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),

          ],
        ),
      )
      ),
    );
  }
}

class FitnessModel{
  String? title;
  String? name;
  int? burn;
  int? sets;
  int? reps;
  int? duration;
  int? rest;
  String? instructions;

  FitnessModel({required this.title, required this.name, this.sets, this.reps, this.duration, this.rest, required this.instructions, required this.burn});
}

class FitnessProvider extends ChangeNotifier{
  double progress = 0;
  int done = 0;
  int totalExe = 0;
  int totalCal = 0;
  int burnedCal = 0;

  final List<FitnessModel> exercises = [
    FitnessModel(title: "Warm-up", name: 'Neck rolls (gentle)', instructions: '1. Stand tall\n2. Drop chin to chest\n3. Slowly roll head in a circle\n4. Switch direction', burn: 3, duration: 30, sets: 1),
    FitnessModel(title: "Warm-up", name: 'Shoulder rolls', instructions: '1. Stand relaxed\n2. Lift shoulders up\n3. Roll back and down\n4. Repeat forward and backward', burn: 3, duration: 30, sets: 1),
    FitnessModel(title: "Warm-up", name: 'Neck rolls (gentle)', instructions: '1. Extend arms sideways\n2. Make small circles\n3. Increase size gradually\n4. Reverse direction', burn: 4, duration: 60, sets: 1),
    FitnessModel(title: "Warm-up", name: 'Torso rotation (standing)', instructions: '1. Stand with feet shoulder-width\n2. Keep hips forward\n3. Rotate upper body side to side', burn: 3, duration: 30, sets: 1),
    FitnessModel(title: "Warm-up", name: 'Hip circles', instructions: '1. Hands on hips\n2. Move hips in a circle\n3. Keep chest still\n4. Switch direction', burn: 3, duration: 60, sets: 1),
    FitnessModel(title: "Warm-up", name: 'Cat-cow', instructions: '1. On hands and knees\n2. Inhale drop belly lift chest\n3. Exhale round spine tuck chin', burn: 4, reps: 10, sets: 1),
    FitnessModel(title: "Warm-up", name: 'Inchworm (slow)', instructions: '1. Stand tall\n2. Bend forward touch floor\n3. Walk hands to plank\n4. Walk feet toward hands', burn: 6, reps: 4, sets: 1),
    FitnessModel(title: "Warm-up", name: 'World\'s greatest stretch', instructions: '1. Step into deep lunge\n2. Place one hand on floor\n3. Rotate chest upward\n4. Switch sides', burn: 5, reps: 4, sets: 1),
    FitnessModel(title: 'Main Workout', name: 'Wall push-up', instructions: '1. Stand facing wall\n2. Hands on wall at chest height\n3. Bend elbows bring chest closer\n4. Push back', burn: 18, sets: 3, reps: 12, duration: 45, rest: 60),
    FitnessModel(title: 'Main Workout', name: 'Scapular wall slide', instructions: '1. Back against wall\n2. Arms in goalpost position\n3. Slide arms up\n4. Slide down slowly', burn: 10, sets: 3, reps: 10, duration: 40, rest: 45),
    FitnessModel(title: 'Main Workout', name: 'Arm out band-less pull-apart', instructions: '1. Extend arms forward\n2. Pull arms to sides\n3. Squeeze shoulder blades\n4. Return slowly', burn: 8, sets: 3, reps: 15, duration: 40, rest: 45),
    FitnessModel(title: 'Main Workout', name: 'Chin tuck', instructions: '1. Sit or stand straight\n2. Pull chin straight back\n3. Hold 2 seconds\n4. Relax', burn: 4, sets: 3, reps: 12, duration: 30, rest: 30),
    FitnessModel(title: 'Main Workout', name: 'Dead bug', instructions: '1. Lie on back\n2. Arms and legs up\n3. Extend opposite arm and leg\n4. Return and switch', burn: 14, sets: 3, reps: 12, duration: 50, rest: 60),
    FitnessModel(title: 'Main Workout', name: 'Plank (forearm)', instructions: '1. Forearms on floor\n2. Body straight line\n3. Tighten core\n4. Hold', burn: 12, sets: 3, duration: 20, rest: 45),
    FitnessModel(title: 'Main Workout', name: 'Glute bridge', instructions: '1. Lie on back knees bent\n2. Push through heels\n3. Lift hips up\n4. Squeeze and lower', burn: 16, sets: 3, reps: 15, duration: 45, rest: 45),
    FitnessModel(title: 'Main Workout', name: 'Doorway chest stretch (hold)', instructions: '1. Place hands on door frame\n2. Step forward slightly\n3. Feel chest stretch\n4. Hold', burn: 4, sets: 2, duration: 20, rest: 60),
    FitnessModel(title: "Stretches", name: 'Seated forward fold', instructions: '1. Sit with legs straight\n2. Reach toward toes\n3. Keep back long\n4. Hold', burn: 0, duration: 45),
    FitnessModel(title: "Stretches", name: 'Cross-body shoulder stretch', instructions: '1. Bring arm across chest\n2. Hold with other arm\n3. Keep shoulder relaxed', burn: 0, duration: 40),
    FitnessModel(title: "Stretches", name: 'Neck side stretch', instructions: '1. Sit tall\n2. Tilt head to one side\n3. Gently hold', burn: 0, duration: 40),
    FitnessModel(title: "Stretches", name: 'Child\'s pose', instructions: '1. Kneel on floor\n2. Sit back on heels\n3. Reach arms forward\n4. Relax', burn: 0, duration: 45),
    FitnessModel(title: "Stretches", name: 'Supine spinal twist', instructions: '1. Lie on back\n2. Drop knees to one side\n3. Keep shoulders down\n4. Switch sides', burn: 0, duration: 60),
  ];

  void loadExercises(){
    int sum = 0;
    for(var e in exercises){
      if(e.burn == null) continue;
      sum += e.burn!;
    }
    totalCal = sum;
    totalExe = exercises.length;
  }

  List<FitnessModel> getExercise(String type){
    return exercises.where((e) => e.title == type).toList();
  }

  void logExercise(FitnessModel fit){
    progress += exercises.length / 100;
    done++;
    if(fit.burn != null){
      burnedCal += fit.burn!;
    }
    notifyListeners();
  }
}

class WarmupScreen extends StatefulWidget {
  const WarmupScreen({super.key});

  @override
  State<WarmupScreen> createState() => _WarmupScreenState();
}

class _WarmupScreenState extends State<WarmupScreen> {
  @override
  Widget build(BuildContext context) {
    final ex = context.read<FitnessProvider>().getExercise("Warm-up");
    return Scaffold(
      appBar: AppBar(
        title: Text('Warm-ups'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: ex.length,
            itemBuilder: (context, index){
              final exercises = ex[index];
              return Card(
                child: ListTile(
                  title: Text(exercises.name!),
                  trailing: OutlinedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => DemoScreen()));}, child: Text('Start')),
                ),
              );
        }),
      ),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    final exe = context.watch<FitnessProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Warm-up demo'),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5,),
              Center(child: SetRepTimer(seconds: 300,)),
              const SizedBox(height: 15,),
              ExpansionTile(title: Text('Instructions'),
              children: [
                Text(exe.exercises[0].instructions!,),
              ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class MainWorkoutScreen extends StatefulWidget {
  const MainWorkoutScreen({super.key});

  @override
  State<MainWorkoutScreen> createState() => _MainWorkoutScreenState();
}

class _MainWorkoutScreenState extends State<MainWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class StretchScreen extends StatefulWidget {
  const StretchScreen({super.key});

  @override
  State<StretchScreen> createState() => _StretchScreenState();
}

class _StretchScreenState extends State<StretchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
    return Scaffold(body: Container());
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Your Exercise Tutorials')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorialPlayer(playerNumber: 0),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                            children: [
                              TextSpan(text: 'Warm up\n', style: Theme.of(context).textTheme.titleSmall,),
                              TextSpan(text: 'exercises . 8 videos\n\n', style: Theme.of(context).textTheme.bodyMedium,),
                              TextSpan(text: 'Play', style: Theme.of(context).textTheme.labelLarge,),
                              WidgetSpan(child: Icon(Icons.play_circle_outline_rounded, size: 16,)),
                            ]
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorialPlayer(playerNumber: 1),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Upper Body\n', style: Theme.of(context).textTheme.titleSmall,),
                                    TextSpan(text: 'exercises . 5 videos\n\n', style: Theme.of(context).textTheme.bodyMedium,),
                                    TextSpan(text: 'Play', style: Theme.of(context).textTheme.labelLarge,),
                                    WidgetSpan(child: Icon(Icons.play_circle_outline_rounded, size: 16,)),
                                  ]
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorialPlayer(playerNumber: 2),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Lower Body & Core\n', style: Theme.of(context).textTheme.titleSmall,),
                                    TextSpan(text: 'exercises . 3 videos\n\n', style: Theme.of(context).textTheme.bodyMedium,),
                                    TextSpan(text: 'Play', style: Theme.of(context).textTheme.labelLarge,),
                                    WidgetSpan(child: Icon(Icons.play_circle_outline_rounded, size: 16,)),
                                  ]
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorialPlayer(playerNumber: 3),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Stretches\n', style: Theme.of(context).textTheme.titleSmall,),
                                    TextSpan(text: 'exercises . 5 videos\n\n', style: Theme.of(context).textTheme.bodyMedium,),
                                    TextSpan(text: 'Play', style: Theme.of(context).textTheme.labelLarge,),
                                    WidgetSpan(child: Icon(Icons.play_circle_outline_rounded, size: 16,)),
                                  ]
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TutorialPlayer extends StatefulWidget {
  final int playerNumber;

  const TutorialPlayer({super.key, required this.playerNumber});

  @override
  State<TutorialPlayer> createState() => _TutorialPlayerState();
}

class _TutorialPlayerState extends State<TutorialPlayer> {
  late List<String> selectedPlaylist;
  late String showTitle;
  late List<String> selectedDescriptions;
  late IconData showIcon;

  final List<List<String>> _playlists = [
    ['X-CUlo4zf0Y', 'w8yCm_sFUo4', '35h5gdlm46w', 'QQMri8bsjy8', 'qkrJXGVj_OQ', 'LIVJZZyZ2qM', 'rmCOifHCDKE', '-CiWQ2IvY34'],
    ['HsdRtg7Czv8', 'tWDGEyMWv10', 'MnDpmNYUjbc', 'H0TWk06p5s4', 'r6mv__re704',],
    ['DdUKPepLsTw', '3QZlgJ40LfU', 'XLXGydU5DdU'],
    ['PUVTGBARpoo', 'TOCcgbqzq5g', 'Zwtu9635kMQ', 'nMp3MlTz9fA', 'TeAhhVD2q1c'],
  ];
  final List<String> _titles = [
    'Warm-up exercises', 'Upper body exercises', 'Lower body and core exercises', 'Stretches',
  ];
  final List<IconData> _appBarIcons = [
    Symbols.arrow_warm_up_rounded, Symbols.body_system_rounded, Symbols.tibia_alt_rounded, Symbols.physical_therapy_rounded,
  ];


  final List<List<String>> _descriptions = [
    [
      "Neck rolls (gentle): Loosen neck muscles and improve cervical mobility.",
      "Shoulder rolls: Activate and warm up shoulder joints.",
      "Arm circles (forward + back): Prepare shoulders and arms for movement.",
      "Torso rotation (standing): Increase thoracic spine mobility.",
      "Hip circles: Loosen hip joints for better range of motion.",
      "Cat-cow: Mobilize the spine and warm up back muscles.",
      "Inchworm (slow): Activate core, shoulders, and hamstrings.",
      "World's greatest stretch: Open hips, thoracic spine, and hamstrings."
    ],

    [
      "Wall push-up: Strengthen chest, shoulders, and triceps.",
      "Scapular wall slide: Improve shoulder mobility and posture.",
      "Arm out band-less pull-apart: Strengthen upper back and rear delts.",
      "Chin tuck: Improve neck posture and cervical stability.",
      "Doorway chest stretch (hold): Open chest and anterior shoulders."
    ],

    [
      "Dead bug: Strengthen core and stabilize lower back.",
      "Plank (forearm): Build core stability and full-body tension.",
      "Glute bridge: Activate glutes and strengthen posterior chain."
    ],

    [
      "Seated forward fold: Stretch hamstrings and lower back.",
      "Cross-body shoulder stretch: Release tension in posterior shoulders.",
      "Neck side stretch: Loosen cervical muscles.",
      "Child's pose: Stretch lats, hips, and lower back.",
      "Supine spinal twist: Improve thoracic and lumbar rotation."
    ]
  ];

  @override
  void initState() {
    super.initState();
    selectedPlaylist = _playlists[widget.playerNumber];
    showTitle = _titles[widget.playerNumber];
    showIcon = _appBarIcons[widget.playerNumber];
    selectedDescriptions = _descriptions[widget.playerNumber];
    for(final videoId in selectedPlaylist){
      final id = 'yt-player-$videoId';
      ui.platformViewRegistry.registerViewFactory(id, (int i){
        final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement
            ..src = 'https://www.youtube-nocookie.com/embed/$videoId'
                '?rel=0&showinfo=0&enablejsapi=1&playsinline=1'
            ..width = '100%'
            ..height = '100%'
            ..allowFullscreen = true
            ..setAttribute('referrerpolicy', 'strict-origin-when-cross-origin')
            ..setAttribute('allow', 'accelerometer; autoplay; clipboard-write; '
                'encrypted-media; gyroscope; picture-in-picture; web-share',);
        (iframe as web.HTMLElement).style.border = 'none';
        return iframe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: RichText(text: TextSpan(
            children: [
              TextSpan(text: '$showTitle  ', style: Theme.of(context).textTheme.titleMedium),
              WidgetSpan(child: Icon(showIcon)),
            ]
          )),
        ),
        body: ListView.builder(
          itemCount: selectedPlaylist.length,
          itemBuilder: (context, index) {
            final videoId = selectedPlaylist[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                  children: [AspectRatio(aspectRatio: 16 /7,child: HtmlElementView(viewType: 'yt-player-$videoId'),),
                    Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: Text(selectedDescriptions[index], style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.left,)),
              ])
            );
          },
        ),
      ),
    );
  }
}

class FitnessHistory extends StatefulWidget {
  const FitnessHistory({super.key});

  @override
  State<FitnessHistory> createState() => _FitnessHistoryState();
}

class _FitnessHistoryState extends State<FitnessHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Fitness History'),
      ),
      body: SizedBox(),
    );
  }
}

class SetRepTimer extends StatefulWidget {
  final int seconds;
  const SetRepTimer({super.key, required this.seconds});

  @override
  State<SetRepTimer> createState() => _SetRepTimerState();
}

class _SetRepTimerState extends State<SetRepTimer> {
  late final StopWatchTimer _timer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(widget.seconds),
  );
  bool _isRunning = false;

  @override
  void dispose() async {
    super.dispose();
    await _timer.dispose();
  }

  void _toggle() {
    if (_isRunning) {
      _timer.onResetTimer();
      setState(() => _isRunning = false);
    } else {
      _timer.onStartTimer();
      setState(() => _isRunning = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<int>(
              stream: _timer.rawTime,
              initialData: _timer.rawTime.value,
              builder: (context, snap) => Text(
                StopWatchTimer.getDisplayTime(
                  snap.data!,
                  hours: false,
                  milliSecond: false,
                ),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _toggle,
              icon: Icon(
                _isRunning
                    ? Icons.refresh_rounded
                    : Icons.play_circle_filled_rounded,
              ),
              iconSize: 26,
            ),
          ],
        ),
      ),
    );
  }
}

