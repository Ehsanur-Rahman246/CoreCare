import 'dart:convert';
import 'package:core_care/decoration.dart';
import 'package:core_care/main.dart';
import 'package:core_care/pages/profile_page.dart';
import 'package:core_care/data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

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

  @override
  void initState() {
    super.initState();
    waterBarCount = 19;
    fillCounter = 0;

    SchedulerBinding.instance.addPostFrameCallback((_){
      _loadProfileImage();
      final user = context.read<DataProvider>().currentUser;
      final timeProvider = context.read<TimeProvider>();
      if(user != null && timeProvider.is24Hour != user.is24Hour){
        timeProvider.toggleFormat();
      }
    });
  }

  void _loadProfileImage(){
    final base64Str = context.read<DataProvider>().profileImageBase64;
    if(base64Str != null && base64Str.isNotEmpty){
      setState(() {
        _profileImageBytes = base64Decode(base64Str);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = context.watch<TimeProvider>();
    final provider = context.watch<DataProvider>();
    if(provider.profileImageBase64 != _cachedBase64){
      _cachedBase64 = provider.profileImageBase64;
      _profileImageBytes = provider.profileImageBase64 != null ? base64Decode(provider.profileImageBase64!) : null;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(heroTag: 'status', onPressed: (){}),
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
                          RichText(text: TextSpan(children: [
                            TextSpan(text: '${time.formatDate}  ', style: Theme.of(context).textTheme.labelLarge),
                            TextSpan(text: '.  ${time.formatTime}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight(550), fontFamily: 'Poppins')),
                          ])),
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
                        onSelected: (value){
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
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  title: Text('Sign Out'),
                                  content: Text('Do you want to log out?'),
                                  actions: [
                                    OutlinedButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
                                    FilledButton(onPressed: () async {await HomeScreen.logUserOut();
                                      if(context.mounted){
                                        Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
                                        context.read<DataProvider>().clearUser();
                                      }
                                      }, child: Text('Sign Out')),
                                  ],
                                );
                              });
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

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();
    return Card(
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
                          Text(
                            "Calories left",
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge,
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
                      backgroundColor: CustomColors.greenPrimary(
                        context,
                      ),
                      child: Icon(Symbols.fork_spoon),
                    ),
                    const SizedBox(height: 10),
                    Text("2500 cal"),
                    Text(
                      "Eaten",
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium,
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium,
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
                    RichText(text: TextSpan(
                      children: [
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: provider.carbImage),
                        TextSpan(text: ' Carbs'),
                      ],
                    )),
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text: TextSpan(
                      children: [
                        WidgetSpan(alignment: PlaceholderAlignment.middle, child: provider.proteinImage),
                        TextSpan(text: ' Protein'),
                      ],
                    )),
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text: TextSpan(
                      children: [
                        WidgetSpan(alignment: PlaceholderAlignment.middle, child: provider.fatImage),
                        TextSpan(text: ' Fats'),
                      ],
                    )),
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium,
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

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

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
    themeMode = switch (user.themeMode){
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
    if(hourProvider.is24Hour != user.is24Hour){
      SchedulerBinding.instance.addPostFrameCallback((_){
        hourProvider.toggleFormat();
      });
    }
  }

  Future<void> _saveSettings() async{
    final provider = context.read<DataProvider>();
    final themeModeString = switch (themeMode){
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.square_foot_outlined),
                      title: Text('Unit of measurement'),
                      subtitle: isMetric ? Text('kg . g . cm') : Text('lb . ft . oz'),
                      subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
                      trailing: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: unitButton(context)),
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
  
  Widget unitButton(BuildContext context){
    final ch = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
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
            child: Center(child: Text('Metric', style: TextStyle(color: !isMetric ? ch.onSurface : ch.onPrimary, fontSize: 12, fontWeight: FontWeight.w400),)),
          ),
        ),
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
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
            child: Center(child: Text('Imperial', style: TextStyle(color: isMetric ? ch.onSurface : ch.onPrimary,  fontSize: 12, fontWeight: FontWeight.w400),)),
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


