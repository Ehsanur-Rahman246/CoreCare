import 'package:core_care/main.dart';
import 'package:core_care/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
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
  late Status currentStatus;
  late IconData statusIcon;
  bool warmupCompleted = false;
  bool exerciseCompleted = false;
  bool stretchesCompleted = false;

  @override
  void initState() {
    super.initState();
    currentStatus = Status.active;
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
  }

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
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              "7 / 20 left",
                              style: Theme.of(context).textTheme.labelMedium,
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
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              "50 kcal",
                              style: Theme.of(context).textTheme.labelMedium,
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
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: '60%',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontSize: 14,
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
                  value: 0.6,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView(
                  children: [
                    // ExerciseList(time: '08:30 AM', title: 'Warm up', subtitle: Row(
                    //   children: [
                    //   ],
                    // ), trailing: trailing, burn: burn, isCompleted: isCompleted, isPast: isPast, icon: icon),
                    // ExerciseList(time: '08:37 AM', title: 'Main exercises', subtitle: subtitle, trailing: trailing, burn: burn, isCompleted: isCompleted, isPast: isPast, icon: icon),
                    // ExerciseList(time: '09:05 AM', title: 'After exercise stretches', subtitle: subtitle, trailing: trailing, burn: burn, isCompleted: isCompleted, isPast: isPast, icon: icon),
                  ],
                ),
              ),
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
        onTap: () {},
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
      lineXY: 0.2,
      isFirst: widget.isFirst,
      isLast: widget.isLast,

      startChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(widget.time, textAlign: TextAlign.right, style: th.labelLarge,)
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

class WarmupScreen extends StatefulWidget {
  const WarmupScreen({super.key});

  @override
  State<WarmupScreen> createState() => _WarmupScreenState();
}

class _WarmupScreenState extends State<WarmupScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
