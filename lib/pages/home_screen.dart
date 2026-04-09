import 'dart:convert';
import 'dart:math';
import 'package:core_care/decoration.dart';
import 'package:core_care/main.dart';
import 'package:core_care/pages/diet_module.dart';
import 'package:core_care/pages/profile_page.dart';
import 'package:core_care/data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'fitness_module.dart';

enum Status { sick, injured, travelling, active, rest, fasting }

class StatusProvider extends ChangeNotifier{
  Status status = Status.active;
  void updateStatus(Status s){
    status = s;
    notifyListeners();
  }
}

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  static Future<void> logUserOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasNotification = false;
  late int waterBarCount;
  late int fillCounter;
  Uint8List? _profileImageBytes;
  String? _cachedBase64;
  static late Status currentStatus;

  bool _buttonA = false;
  bool _buttonB = false;
  bool _buttonC = false;
  bool _buttonD = false;
  bool _buttonE = false;
  bool _buttonF = false;

  void _showStatusSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final ch = Theme.of(context).colorScheme;
        final st = context.watch<StatusProvider>();
        return StatefulBuilder(
          builder: (context, setSheet) {
            void update(VoidCallback fn) {
              setSheet(() => setState(fn));
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Status',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(Symbols.directions_run_rounded),
                                  title: Text('Active', style: Theme.of(context).textTheme.bodySmall,),
                                  trailing: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: _buttonA,
                                      onChanged: (val) => update(() {
                                        _buttonA = val;
                                        if (val) _buttonB = false;
                                        if (val) st.updateStatus(Status.active);
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(Symbols.bed_rounded),
                                  title: Text('Resting', style: Theme.of(context).textTheme.bodySmall,),
                                  trailing: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: _buttonB,
                                      onChanged: (val) => update(() {
                                        _buttonB = val;
                                        if (val) _buttonA = false;
                                        if (val) st.updateStatus(Status.rest);
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(Symbols.sick_rounded),
                                  title: Text('Sick', style: Theme.of(context).textTheme.bodySmall,),
                                  trailing: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: _buttonC,
                                      onChanged: (val) => update(() {
                                        _buttonC = val;
                                        if (val) {
                                          _buttonB = true;
                                          _buttonA = false;
                                        }
                                        if (val) st.updateStatus(Status.sick);
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(Symbols.travel_rounded),
                                  title: Text('Travelling', style: Theme.of(context).textTheme.bodySmall,),
                                  trailing: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: _buttonD,
                                      onChanged: (val) => update(() {
                                        _buttonD = val;
                                        if (val) {
                                          st.updateStatus(Status.travelling);
                                        }
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Symbols.hourglass_arrow_down_rounded,
                                  ),
                                  title: Text('Fasting', style: Theme.of(context).textTheme.bodySmall,),
                                  trailing: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: _buttonE,
                                      onChanged: _buttonE
                                          ? (val) {
                                        update(() => _buttonE = false);
                                        st.updateStatus(Status.fasting);
                                      }
                                      : null,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(Symbols.healing_rounded),
                                  title: Text('Injured', style: Theme.of(context).textTheme.bodySmall,),
                                  trailing: Transform.scale(
                                    scale: 0.6,
                                    child: Switch(
                                      value: _buttonF,
                                      onChanged: (val) => update(() {
                                        _buttonF = val;
                                        if (val) _buttonB = false;
                                        if(val) st.updateStatus(Status.injured);
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fillCounter = 0;
    currentStatus = Status.active;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadProfileImage();
      final user = context.read<DataProvider>().currentUser;
      final timeProvider = context.read<TimeProvider>();
      if (user != null && timeProvider.is24Hour != user.is24Hour) {
        timeProvider.toggleFormat();
      }
    });
  }

  void _loadProfileImage() {
    final base64Str = context.read<DataProvider>().profileImageBase64;
    if (base64Str != null && base64Str.isNotEmpty) {
      setState(() {
        _profileImageBytes = base64Decode(base64Str);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = context.watch<TimeProvider>();
    final provider = context.watch<DataProvider>();
    final fit = context.watch<FitnessProvider>();
    final meal = context.watch<MealProvider>();
    waterBarCount = meal.waterGlass;
    fit.loadExercises();
    if (provider.profileImageBase64 != _cachedBase64) {
      _cachedBase64 = provider.profileImageBase64;
      _profileImageBytes = provider.profileImageBase64 != null
          ? base64Decode(provider.profileImageBase64!)
          : null;
    }

    IconData statusIcon = Symbols.directions_run_rounded;
    switch (currentStatus) {
      case Status.fasting:
        statusIcon = Symbols.hourglass_arrow_down_rounded;
        _buttonE = true;
        break;
      case Status.travelling:
        statusIcon = Symbols.travel_rounded;
        _buttonD = true;
        break;
      case Status.injured:
        statusIcon = Symbols.healing_rounded;
        _buttonF = true;
        break;
      case Status.sick:
        statusIcon = Symbols.sick_rounded;
        _buttonC = true;
        break;
      case Status.active:
        statusIcon = Symbols.directions_run_rounded;
        _buttonA = true;
        break;
      case Status.rest:
        statusIcon = Symbols.bed_rounded;
        _buttonB = true;
        break;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'status',
        onPressed: _showStatusSheet,
        child: Icon(statusIcon),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        foregroundImage: _profileImageBytes != null
                            ? MemoryImage(_profileImageBytes!)
                            : null,
                        child: _profileImageBytes != null
                            ? null
                            : Icon(Icons.person_rounded),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Greetings(),
                          const SizedBox(height: 7),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${time.formatDate}  ',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                TextSpan(
                                  text: '.  ${time.formatTime}',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight(550),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                        icon: Badge(
                          isLabelVisible: hasNotification,
                          child: Icon(Icons.notifications),
                        ),
                      ),
                      const SizedBox(width: 10),
                      PopupMenuButton(
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProfilePage(),
                                ),
                              ).then((_) {
                                if (!mounted) return;
                                setState(() {});
                              });
                              break;
                            case 1:
                              Navigator.pushNamed(context, '/settings');
                              break;
                            case 2:
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Sign Out'),
                                    content: Text('Do you want to log out?'),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () async {
                                          await HomeScreen.logUserOut();
                                          if (context.mounted) {
                                            Navigator.of(
                                              context,
                                            ).pushNamedAndRemoveUntil(
                                              '/auth',
                                              (route) => false,
                                            );
                                            context
                                                .read<DataProvider>()
                                                .clearUser();
                                          }
                                        },
                                        child: Text('Sign Out'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(Icons.account_circle_rounded),
                                  const SizedBox(width: 8),
                                  Text("Profile"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.settings_rounded),
                                  const SizedBox(width: 8),
                                  Text("Settings"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.logout_rounded),
                                  const SizedBox(width: 8),
                                  Text("Sign out"),
                                ],
                              ),
                            ),
                          ];
                        },
                        icon: Icon(Icons.menu),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your Progress",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Spacer(),
                    Card(
                      color: CustomColors.yellowPrimary(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        child: Row(
                          children: [
                            Emoji.fire,
                            Text(
                              "3-day Streak",
                              style: TextStyle(
                                color: CustomColors.black(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (currentStatus == Status.fasting)
                  ArcTimer(startHour: 2, startMin: 7, endHour: 2, endMin: 10)
                else
                  Dashboard(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Plans",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onNavigate(1);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Symbols.exercise),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Exercises:"),
                                    Text("${fit.done} / ${fit.totalExe} left"),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(Symbols.chevron_right),
                                  onPressed: () {
                                    widget.onNavigate(1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onNavigate(2);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Symbols.dinner_dining),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Meals:"),
                                    Text("1 / 4 left"),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(Symbols.chevron_right),
                                  onPressed: () {
                                    widget.onNavigate(2);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Water intake",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 7,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: BoxBorder.all(
                              color: CustomColors.blueOutline(context),
                            ),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.water_drop_rounded,
                                    size: 50,
                                    color: CustomColors.bluePrimary(context),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${fillCounter * 0.25} L / ${waterBarCount * 0.25} L",
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              waterIntakeBar(
                                context: context,
                                total: waterBarCount,
                                fill: fillCounter,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FilledButton(
                              onPressed: fillCounter < waterBarCount
                                  ? () => setState(() => fillCounter++)
                                  : null,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Symbols.water_full_rounded),
                                  Text("+ 250 ml"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            FilledButton(
                              onPressed: fillCounter < waterBarCount
                                  ? () => setState(() {
                                      fillCounter++;
                                      fillCounter++;
                                    })
                                  : null,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Symbols.water_bottle_rounded),
                                  Text("+ 500 ml"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget waterIntakeBar({
    required BuildContext context,
    required int total,
    required int fill,
  }) {
    const int max = 8;
    int meterCount = (total / max).ceil();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(meterCount, (index) {
              int start = index * max;
              int end = (start + max > total) ? total : start + max;
              int element = end - start;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(element, (i) {
                    int mainIdx = start + i;
                    bool isFilled = mainIdx < fill;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: 15,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: isFilled
                            ? CustomColors.bluePrimary(context)
                            : Theme.of(context).colorScheme.tertiary,
                      ),
                    );
                  }).reversed.toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();
    final unit = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String showUnit = 'g';
    if (unit) {
      showUnit = 'g';
    } else {
      showUnit = 'oz';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        value: (1300 / 2000).clamp(0.0, 1.0),
                        color: Theme.of(context).colorScheme.secondary,
                        strokeWidth: 10,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "1300",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "Calories left",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: CustomColors.greenPrimary(context),
                      child: Icon(Symbols.fork_spoon),
                    ),
                    const SizedBox(height: 10),
                    Text("2500 cal"),
                    Text(
                      "Eaten",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: CustomColors.orangePrimary(context),
                      child: Icon(Icons.local_fire_department_rounded),
                    ),
                    const SizedBox(height: 10),
                    Text("1200 cal"),
                    Text(
                      "Burned",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: provider.carbImage,
                          ),
                          TextSpan(
                            text: ' Carbs',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        value: 0.7,
                        color: CustomColors.yellowOutline(context),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "70/100 $showUnit",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: provider.proteinImage,
                          ),
                          TextSpan(
                            text: ' Protein',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        value: 0.8,
                        color: CustomColors.blueOutline(context),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "70/100 $showUnit",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: provider.fatImage,
                          ),
                          TextSpan(
                            text: ' Fats',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        value: 0.6,
                        color: CustomColors.orangeOutline(context),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "70/100 $showUnit",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ArcTimer extends StatefulWidget {
  final int startHour, startMin, endHour, endMin;

  const ArcTimer({
    super.key,
    required this.startHour,
    required this.startMin,
    required this.endHour,
    required this.endMin,
  });

  @override
  State<ArcTimer> createState() => _ArcTimerState();
}

class _ArcTimerState extends State<ArcTimer> {
  @override
  Widget build(BuildContext context) {
    final is24Hour =
        context.watch<DataProvider>().currentUser?.is24Hour ?? true;
    String formatHM(int hour, int minute) {
      final min = minute.toString().padLeft(2, '0');
      if (is24Hour) return '${hour.toString().padLeft(2, '0')}:$min';
      final period = hour >= 12 ? 'PM' : 'AM';
      int h = hour % 12;
      if (h == 0) h = 12;
      return '${h.toString().padLeft(2, '0')}:$min $period';
    }

    final now = context.watch<TimeProvider>().now;
    final start = DateTime(
      now.year,
      now.month,
      now.day,
      widget.startHour,
      widget.startMin,
    );
    final end = DateTime(
      now.year,
      now.month,
      now.day,
      widget.endHour,
      widget.endMin,
    );
    final total = end.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds.clamp(0, total);
    final remaining = (total - elapsed).clamp(0, total);
    final progress = total > 0 ? elapsed / total : 0.0;

    final h = remaining ~/ 3600;
    final m = (remaining % 3600) ~/ 60;
    final s = remaining % 60;
    final countdown =
        '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Fasting',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 130),
                    painter: _ArcPainter(
                      progress: progress,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      formatHM(widget.endHour, widget.endMin),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Text(
                      formatHM(widget.startHour, widget.startMin),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: countdown,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextSpan(
                          text: '   Left',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final cx = size.width / 2;
    final cy = size.height;
    final r = min(size.width / 2, size.height) - stroke / 2 - 2;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      pi,
      pi,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        pi,
        pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode themeMode;
  late bool isNotificationsOn;
  late String shownValue;
  late bool isMetric;

  @override
  void initState() {
    super.initState();
    final user = context.read<DataProvider>().currentUser!;
    themeMode = switch (user.themeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    isNotificationsOn = user.wantNotifications;
    isMetric = user.wantMetricUnit;
    shownValue = user.language;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<DataProvider>().currentUser!;
    final hourProvider = context.read<TimeProvider>();
    if (hourProvider.is24Hour != user.is24Hour) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        hourProvider.toggleFormat();
      });
    }
  }

  Future<void> _saveSettings() async {
    final provider = context.read<DataProvider>();
    final themeModeString = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await provider.updateSettings(
      wantNotifications: isNotificationsOn,
      wantMetricUnit: isMetric,
      language: shownValue,
      themeMode: themeModeString,
      is24Hour: context.read<TimeProvider>().is24Hour,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hourFormat = context.watch<TimeProvider>();
    bool isDark;
    if (themeMode == ThemeMode.dark) {
      isDark = true;
    } else if (themeMode == ThemeMode.light) {
      isDark = false;
    } else {
      isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        "SETTINGS",
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -45,
                    child: Icon(
                      Icons.settings_rounded,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.chevron_left_rounded, size: 40, color: Theme.of(context).colorScheme.onPrimary,),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Card(
                  child: ListTile(
                    isThreeLine: true,
                    leading: Icon(Icons.dark_mode_rounded),
                    title: Text('Dark Mode'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isDark ? Text('ON') : Text('OFF'),
                        SizedBox(height: 8),
                        Center(child: modeSelect(context)),
                      ],
                    ),
                    subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_active),
                    title: Text('Notifications'),
                    subtitle: isNotificationsOn ? Text('ON') : Text('OFF'),
                    subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
                    trailing: Switch(
                      value: isNotificationsOn,
                      onChanged: (value) {
                        setState(() {
                          isNotificationsOn = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Language'),
                      trailing: languageButton(context),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.watch_later_outlined),
                    title: Text('Time Format'),
                    subtitle: hourFormat.is24Hour
                        ? Text('24-hour')
                        : Text('12-hour'),
                    subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
                    trailing: Switch(
                      value: hourFormat.is24Hour,
                      onChanged: (bool value) {
                        hourFormat.toggleFormat();
                        _saveSettings();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.square_foot_outlined),
                      title: Text('Unit of measurement'),
                      subtitle: isMetric
                          ? Text('kg . g . cm')
                          : Text('lb . ft . oz'),
                      subtitleTextStyle: Theme.of(
                        context,
                      ).textTheme.labelMedium,
                      trailing: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: unitButton(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget unitButton(BuildContext context) {
    final ch = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              isMetric = true;
            });
            _saveSettings();
          },
          child: Container(
            height: 46,
            width: 60,
            decoration: BoxDecoration(
              color: isMetric ? ch.primary : ch.surface,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
              border: Border(
                top: BorderSide(color: ch.primary),
                bottom: BorderSide(color: ch.primary),
                left: BorderSide(color: ch.primary),
                right: BorderSide.none,
              ),
            ),
            child: Center(
              child: Text(
                'Metric',
                style: TextStyle(
                  color: !isMetric ? ch.onSurface : ch.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              isMetric = false;
            });
            _saveSettings();
          },
          child: Container(
            height: 46,
            width: 60,
            decoration: BoxDecoration(
              color: !isMetric ? ch.primary : ch.surface,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
              border: Border(
                top: BorderSide(color: ch.primary),
                bottom: BorderSide(color: ch.primary),
                right: BorderSide(color: ch.primary),
                left: BorderSide.none,
              ),
            ),
            child: Center(
              child: Text(
                'Imperial',
                style: TextStyle(
                  color: isMetric ? ch.onSurface : ch.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget languageButton(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(10),
        focusColor: Colors.transparent,
        style: Theme.of(context).textTheme.bodyMedium,
        elevation: 4,
        value: shownValue,
        items: const [
          DropdownMenuItem(value: 'English', child: Text('English')),
          DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
          DropdownMenuItem(value: 'French', child: Text('French')),
          DropdownMenuItem(value: 'Bangla', child: Text('Bangla')),
        ],
        onChanged: (String? value) {
          setState(() {
            shownValue = value!;
          });
          _saveSettings();
        },
      ),
    );
  }

  Widget modeSelect(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text('Auto', style: Theme.of(context).textTheme.bodySmall),
          icon: Icon(Icons.auto_awesome, size: 12),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          label: Text('Light', style: Theme.of(context).textTheme.bodySmall),
          icon: Icon(Icons.light_mode, size: 12),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text('Dark', style: Theme.of(context).textTheme.bodySmall),
          icon: Icon(Icons.dark_mode, size: 12),
        ),
      ],
      selected: {themeMode},
      onSelectionChanged: (value) {
        setState(() {
          themeMode = value.first;
        });
        _saveSettings();
      },
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool isRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.chevron_left_rounded, size: 30),
        ),
        title: Text('Notifications'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: null,
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: null,
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: Icon(Icons.check_circle),
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: Icon(Icons.check_circle),
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: Icon(Icons.check_circle),
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: Icon(Icons.check_circle),
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: Icon(Icons.check_circle),
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: Icon(Icons.check_circle),
            ),
          ],
        ),
      ),
    );
  }
}
