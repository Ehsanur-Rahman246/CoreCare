import 'package:core_care/boarding_screen.dart';
import 'package:core_care/main.dart';
import 'package:core_care/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                        child: Icon(Icons.person_rounded),
                      ),
                      const SizedBox(width: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good Morning ${String.fromCharCode(0x2600)}", style: Theme.of(context).textTheme.headlineSmall,),
                          const SizedBox(height: 7,),
                          Text("Feb 28, 2026  .  12:37 PM", style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                      Spacer(),
                        Badge(
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/notifications');
                              },
                              icon: Icon(Icons.notifications),
                            ),
                          ),
                        ),
                      const SizedBox(width: 10,),
                      PopupMenuButton(
                        onSelected: (value){
                          switch(value){
                            case 0:
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => ProfilePage())
                              );
                              break;
                            case 1:
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => OnboardingScreen())
                              );
                              break;
                            case 2:
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (_) => LoginScreen())
                              );
                              break;
                          }
                        },
                        itemBuilder:(context) {
                          return [
                            PopupMenuItem(
                              value: 0,
                                child: Row(
                                children: [Icon(Icons.account_circle_rounded), const SizedBox(width: 8,), Text("Profile"),])),
                            PopupMenuItem(
                                value: 1,
                                child: Row(
                                children: [Icon(Icons.settings_rounded),const SizedBox(width: 8,), Text("Settings")])),
                            PopupMenuItem(
                              value: 2,
                                child: Row(
                                children: [Icon(Icons.logout_rounded),const SizedBox(width: 8,), Text("Sign out")])),
                          ];
                        },
                          icon: CircleAvatar(child: Icon(Icons.menu))),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text("Your Progress", style: Theme.of(context).textTheme.titleMedium,)
                      ),
                      const Spacer(),
                      Card(
                        color: CustomColors.yellowPrimary(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Text("${String.fromCharCode(0x1F525)} 3-day Streak", style: TextStyle(color: CustomColors.black(context)),)),
                      )
                    ],
                ),
                Card(
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
                                    value: (1300/2000).clamp(0.0, 1.0),
                                    color: Theme.of(context).colorScheme.secondary,
                                    strokeWidth: 10,
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                    Text("1300", style: Theme.of(context).textTheme.bodyLarge,),
                                    const SizedBox(height: 7,),
                                    Text("Calories left"),
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
                                const SizedBox(height: 10,),
                                Text("2500 cal"),
                                Text("Eaten"),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: CustomColors.orangePrimary(context),
                                  child: Icon(Icons.local_fire_department_rounded),
                                ),
                                const SizedBox(height: 10,),
                                Text("1200 cal"),
                                Text("Burned"),
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
                                children: [Text("🍞 Carbs"), SizedBox(height: 8,), SizedBox(width: 100, child: LinearProgressIndicator(backgroundColor: Theme.of(context).colorScheme.tertiary,value: 0.7, color: CustomColors.yellowOutline(context),)), SizedBox(height: 5,), Text("70/100 g")]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("🥩 Protein"), SizedBox(height: 8,), SizedBox(width: 100, child: LinearProgressIndicator(backgroundColor: Theme.of(context).colorScheme.tertiary,value: 0.8, color: CustomColors.blueOutline(context),)), SizedBox(height: 5,), Text("70/100 g")]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("🧈 Fat"), SizedBox(height: 8,), SizedBox(width: 100, child: LinearProgressIndicator(backgroundColor: Theme.of(context).colorScheme.tertiary,value: 0.6, color: CustomColors.redOutline(context),)), SizedBox(height: 5,), Text("70/100 g")]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Text("Your Plans", style: Theme.of(context).textTheme.titleMedium,)
                ),
                const SizedBox(height: 8,),
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
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                                  onPressed: (){
                                    widget.onNavigate(1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onNavigate(2);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                                  onPressed: (){
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
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                    child: Text("Water intake", style: Theme.of(context).textTheme.titleMedium,)
                ),
                const SizedBox(height: 8,),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding : const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: BoxBorder.all(color: CustomColors.blueOutline(context))
                          ),
                          child: Row(
                            children: [
                              Column(children: [Icon(Icons.water_drop_rounded, size: 50,color: CustomColors.bluePrimary(context),),
                                const SizedBox(height: 10,),
                                Text("${fillCounter * 0.25} L / ${waterBarCount * 0.25} L"),
                              ]),

                              waterIntakeBar(context: context, total: waterBarCount,fill: fillCounter), ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(Symbols.water_full_rounded, size: 30, color: CustomColors.bluePrimary(context),),
                                const SizedBox(width: 8,),
                                FilledButton(onPressed:
                                  fillCounter < waterBarCount ? () => setState(() => fillCounter++) : null,
                                 child: Text("+ 250 ml")),
                              ],
                            ),
                            const SizedBox(height: 25,),
                            Row(
                              children: [
                                Icon(Symbols.water_bottle_rounded, size: 30, color: CustomColors.bluePrimary(context),),
                                const SizedBox(width: 8,),
                                FilledButton(onPressed: fillCounter < waterBarCount ? () => setState(() {
                                  fillCounter++;
                                  fillCounter++;
                                }) : null,
                                    child: Text("+ 500 ml")),
                              ],
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

  Widget waterIntakeBar(
      {required BuildContext context, required int total, required int fill}){
    const int max = 8;
    int meterCount = (total / max).ceil();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
              List.generate(meterCount, (index){
                int start = index * max;
                int end = (start + max > total) ? total : start + max;
                int element = end - start;
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:
                      List.generate(element, (i){
                        int mainIdx = start + i;
                        bool isFilled = mainIdx < fill;
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          width: 15,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: isFilled ? CustomColors.bluePrimary(context) : Theme.of(context).colorScheme.tertiary,
                          ),
                        );
                      }).reversed.toList(),
                  ),
                );
              }),
          )
        ],
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.chevron_left_rounded, ))),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20),),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(child: Text("SETTINGS", style: Theme.of(context).textTheme.displayLarge,)),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: -40,
                  child: Icon(Icons.settings_rounded, size: 100,)),
            ],
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.dark_mode_rounded),
                title: Text('Dark Mode'),
                subtitle: isDark ? Text('ON') : Text('OFF'),
                subtitleTextStyle: Theme.of(context).textTheme.labelSmall,
                trailing: Switch(value: isDark, onChanged: (value){
                  setState(() {
                    isDark = value;
                  });
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.chevron_left_rounded))),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.vertical(bottom:
                      Radius.circular(40),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: -100,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("USER\nuser.cse@aust.edu"), Spacer(), Icon(Icons.person)]),
                            Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Streak: 3 days"), Spacer(), Icon(Icons.local_fire_department_rounded, color: CustomColors.orangePrimary(context),)]),
                            Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Points: 100 pts"), Spacer(), Icon(Icons.paid_outlined, color: CustomColors.yellowPrimary(context),)]),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                      right: 0,
                    child: CircleAvatar(
                      backgroundColor: CustomColors.greyLight(context),
                      radius: 35,
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: ListView(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("General", style: Theme.of(context).textTheme.bodyMedium,)),
                      Card(
                        child: ListTile(
                           leading: Icon(Icons.eighteen_mp),
                          title: Text('data'),
                          subtitle: Text('data'),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right)),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.eighteen_mp),
                          title: Text('data'),
                          subtitle: Text('data'),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right)),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.eighteen_mp),
                          title: Text('data'),
                          subtitle: Text('data'),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right)),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(padding: const EdgeInsets.only(left: 10),child: Text("Additional Settings")),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.eighteen_mp),
                          title: Text('data'),
                          subtitle: Text('data'),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right)),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.eighteen_mp),
                          title: Text('data'),
                          subtitle: Text('data'),
                          trailing: Icon(Icons.eighteen_mp),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(padding: const EdgeInsets.only(left: 10),child: Text("Others")),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.eighteen_mp),
                          title: Text('data'),
                          subtitle: Text('data'),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.chevron_left_rounded, size: 30,),
        ),
        title: Text('Notifications'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: null
            ),
            ListTile(
              leading: Icon(Symbols.exercise),
              title: Text("You have 7 exercises left"),
              trailing: null
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

