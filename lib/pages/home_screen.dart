import 'package:core_care/decoration.dart';
import 'package:core_care/main.dart';
import 'package:core_care/pages/login_screen.dart';
import 'package:core_care/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasNotification = false;
  late int waterBarCount;
  late int fillCounter;

  @override
  void initState() {
    super.initState();
    waterBarCount = 19;
    fillCounter = 0;
  }

  @override
  Widget build(BuildContext context) {
    final time = context.watch<TimeProvider>();

    return Scaffold(
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
                        foregroundImage: _ProfilePageState.hasImage
                            ? MemoryImage(_ProfilePageState.imageBytes)
                            : null,
                        child: _ProfilePageState.hasImage
                            ? null
                            : Icon(Icons.person_rounded),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning ${String.fromCharCode(0x2600)}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "${time.formatDate}  .  ${time.formatTime}",
                            style: Theme.of(context).textTheme.labelLarge,
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
                              ).then((_) => setState(() {}));
                              break;
                            case 1:
                              Navigator.pushNamed(context, '/settings');
                              break;
                            case 2:
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
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
                              style: TextStyle(color: CustomColors.black(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
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
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    value: (1300 / 2000).clamp(0.0, 1.0),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    strokeWidth: 10,
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "1300",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 7),
                                      Text("Calories left", style: Theme.of(context).textTheme.labelLarge,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: CustomColors.greenPrimary(
                                    context,
                                  ),
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
                                  backgroundColor: CustomColors.orangePrimary(
                                    context,
                                  ),
                                  child: Icon(
                                    Icons.local_fire_department_rounded,
                                  ),
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
                                Text("🍞 Carbs"),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    value: 0.7,
                                    color: CustomColors.yellowOutline(context),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "70/100 g",
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("🥩 Protein"),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    value: 0.8,
                                    color: CustomColors.blueOutline(context),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "70/100 g",
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("🧈 Fat"),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    value: 0.6,
                                    color: CustomColors.redOutline(context),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "70/100 g",
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                                    Text("7 / 20 left"),
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

class SettingsPage extends StatefulWidget {
  final ThemeMode currentTheme;
  final Function(ThemeMode) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode themeMode;
  late bool isNotificationsOn;

  @override
  void initState() {
    super.initState();
    themeMode = widget.currentTheme;
    isNotificationsOn = false;
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
                      style: Theme.of(context).textTheme.displayLarge,
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
                    icon: Icon(Icons.chevron_left_rounded, size: 40),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.all(10),
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
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
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
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
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
        widget.onThemeChanged(value.first);
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static bool hasImage = false;
  static Uint8List imageBytes = Uint8List(0);

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      maxHeight: 1080,
      maxWidth: 1080,
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      XFile? imageFile = XFile(pickedImage.path);
      imageBytes = await imageFile.readAsBytes();
      setState(() {
        hasImage = true;
      });
    }
  }
  void removeImage(){
    setState(() {
      hasImage = false;
    });
  }

  void _showDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Edit Profile Image"),
        actions: [
          OutlinedButton(onPressed: (){
            removeImage();
            Navigator.pop(context);
          }, child: Text('Remove Image')),
          FilledButton(onPressed: (){
            pickImage();
            Navigator.pop(context);
          }, child: Text('Change Image')),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: -150,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 15),
                      child: Column(
                        children: [
                          Text(
                            "User",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "user.new@aust.edu",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    child: Emoji.starter,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Starter",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "110 XP",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    child: Emoji.fire,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "3 day",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "Streak",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    child: Emoji.coin,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "100 FC",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "FitCoins",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.chevron_left_rounded, size: 40),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "Profile",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (!hasImage)
                          CircleAvatar(
                            backgroundColor: CustomColors.greyLight(context),
                            radius: 37,
                            child: Icon(Icons.person, size: 40),
                          )
                        else
                          CircleAvatar(
                            radius: 37,
                            foregroundImage: MemoryImage(imageBytes),
                          ),
                        Positioned(
                          right: -5,
                          bottom: -5,
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.tertiary,
                              ),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                if(hasImage){
                                  _showDialog();
                                }
                                else{
                                  pickImage();
                                }
                              },
                              icon: hasImage
                                  ? Icon(Icons.edit)
                                  : Icon(Icons.camera_alt),
                              iconSize: 18,
                              tooltip: "Add",
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 150),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: ListView(
                  children: [
                    ExpansionTile(title: Text('Personal Information')),
                    const SizedBox(height: 10,),
                    ExpansionTile(title: Text('Fitness Profile')),
                    const SizedBox(height: 10,),
                    ExpansionTile(title: Text('Diet Profile')),
                    const SizedBox(height: 10,),
                    ExpansionTile(title: Text('Health & Conditions')),
                    const SizedBox(height: 10,),
                    ExpansionTile(title: Text('Schedule')),
                    const SizedBox(height: 10,),
                    ExpansionTile(title: Text('Additional Settings'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget profileTile(Image img, Widget title, BuildContext context){
    return ExpansionTile(title: title);
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

