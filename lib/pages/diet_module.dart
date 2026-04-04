import 'package:core_care/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:core_care/main.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'home_screen.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

enum DietState { taken, remaining, normal, fasting, today }

class _DietScreenState extends State<DietScreen> {
  late Status currentStatus;
  late IconData statusIcon;

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
        leading: Icon(Symbols.dinner_dining),
        title: Text('Diet Module'),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'recipe',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Recipe1()),
              );
            },
            child: Icon(Symbols.menu_book_rounded),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.small(
            heroTag: 'add',
            onPressed: () {},
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: Stack(
                  children: [
                    Icon(Symbols.room_service_rounded),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                        weight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                  DietState state;
                  if (date.day == now.day &&
                      date.month == now.month &&
                      date.year == now.year) {
                    state = DietState.today;
                  } else {
                    state = DietState.normal;
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
                  'Today\'s meals',
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
                              "Meals:",
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
                              "Calories Taken:",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              "100 kcal",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MicroLineWidget(carbs: 0.4, protein: 0.5, fats: 0.1),
              ),
              const SizedBox(height: 5),
              Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Carbs: ',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                          ),
                          TextSpan(
                            text: '40%',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Protein: ',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                          ),
                          TextSpan(
                            text: '50%',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Fats: ',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                          ),
                          TextSpan(
                            text: '10%',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    mealCard("Breakfast", "Egg", "Bread", "Banana"),
                    mealCard("Lunch", "Chicken", "Rice", "Salad"),
                    mealCard("Snacks", "Nuts", "Juice", "Apple"),
                    mealCard("Dinner", "Roti", "Vegetable", "Milk"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget weekBox(String date, DietState state) {
    Decoration decoration;
    IconData? icon;
    Color? color;
    bool isToday(DietState state) => state == DietState.today;

    switch (state) {
      case DietState.normal:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: BoxBorder.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        );
        icon = null;
        color = null;
        break;
      case DietState.today:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: BoxBorder.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        );
        icon = statusIcon;
        color = Theme.of(context).colorScheme.onPrimary;
        break;
      case DietState.remaining:
        decoration = BoxDecoration(
          color: CustomColors.redMuted(context),
          border: BoxBorder.all(color: CustomColors.redOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Symbols.no_meals;
        color = CustomColors.redOutline(context);
        break;
      case DietState.taken:
        decoration = BoxDecoration(
          color: CustomColors.greenMuted(context),
          border: BoxBorder.all(color: CustomColors.greenOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Icons.check_circle_outline;
        color = CustomColors.greenOutline(context);
        break;
      case DietState.fasting:
        decoration = BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: BoxBorder.all(color: CustomColors.blueOutline(context)),
          borderRadius: BorderRadius.circular(12),
        );
        icon = Symbols.award_meal;
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

  Widget mealCard(String title, String item1, String item2, String item3) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Divider(thickness: 5),
            itemRow(item1),
            Divider(),
            itemRow(item2),
            Divider(),
            itemRow(item3),
          ],
        ),
      ),
    );
  }

  Widget itemRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(children: [Text(name), Spacer(), Icon(Icons.chevron_right)]),
    );
  }
}

class MicroLine extends CustomPainter {
  final double carbs;
  final double protein;
  final double fats;
  final BuildContext context;

  MicroLine({
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.strokeWidth = 10;
    paint.strokeCap = StrokeCap.round;
    double startX = 0;

    paint.color = CustomColors.yellowOutline(context);
    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(startX + size.width * carbs, size.height / 2),
      paint,
    );
    startX += size.width * carbs;

    paint.color = CustomColors.blueOutline(context);
    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(startX + size.width * protein, size.height / 2),
      paint,
    );
    startX += size.width * protein;

    paint.color = CustomColors.orangeOutline(context);
    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(startX + size.width * fats, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant MicroLine oldDelegate) {
    return oldDelegate.carbs != carbs ||
        oldDelegate.protein != protein ||
        oldDelegate.fats != fats;
  }
}

class MicroLineWidget extends StatefulWidget {
  final double carbs;
  final double protein;
  final double fats;

  const MicroLineWidget({
    super.key,
    required this.carbs,
    required this.protein,
    required this.fats,
  });

  @override
  State<MicroLineWidget> createState() => _MicroLineWidgetState();
}

class _MicroLineWidgetState extends State<MicroLineWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 20),
      painter: MicroLine(
        carbs: widget.carbs,
        protein: widget.protein,
        fats: widget.fats,
        context: context,
      ),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DietHistory extends StatefulWidget {
  const DietHistory({super.key});

  @override
  State<DietHistory> createState() => _DietHistoryState();
}

class _DietHistoryState extends State<DietHistory> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe1 extends StatefulWidget {
  const Recipe1({super.key});

  @override
  State<Recipe1> createState() => _Recipe1State();
}

class _Recipe1State extends State<Recipe1> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String unit1 = 'grams';
    String unit2 = 'g';
    if (data) {
      unit1 = 'grams';
    } else {
      unit1 = 'ounces';
    }
    if (data) {
      unit2 = 'g';
    } else {
      unit2 = 'oz';
    }
    String val(double v) {
      final value = data ? v * 28.35 : v;
      return value.toStringAsFixed(1);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Egg & Oat Power Bowl')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/foods/r1.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Symbols.grocery_rounded, size: 20),
                        const SizedBox(width: 10),
                        Text('INGREDIENTS'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        '3 eggs\n${val(2.9)} $unit1 rolled oats (dry)\n0.8 cups of milk\n0.8 cups of water (for oats)\n1 orange\n1 pinch salt\n1 tablespoon olive oil or butter',
                        style: th.labelLarge,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Symbols.cooking_rounded, size: 20),
                        const SizedBox(width: 10),
                        Text('STEPS'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          child: Center(
                            child: Text(
                              '1',
                              style: th.labelLarge?.copyWith(
                                color: ch.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cook the oats: Combine ${val(2.9)} $unit1 rolled oats (dry) and 0.8 cups water (for oats) in a saucepan over medium heat. Stir constantly and cook for 4–5 minutes until thick and creamy. Pour in 0.8 cups halal milk and stir for another minute. Remove from heat.',
                                style: th.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 300),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          child: Center(
                            child: Text(
                              '2',
                              style: th.labelLarge?.copyWith(
                                color: ch.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scramble the eggs: Crack 3 eggs into a bowl, add a 1 pinch salt, and whisk well. Heat 1 teaspoons olive oil or butter in a non-stick pan over medium-low heat. Pour in eggs and gently fold with a spatula every few seconds until just set — don\'t overcook.',
                                style: th.bodySmall,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          child: Center(
                            child: Text(
                              '3',
                              style: th.labelLarge?.copyWith(
                                color: ch.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assemble: Spoon oats into a bowl, top with scrambled eggs on the side. Peel and slice 1 orange and serve alongside. Eat immediately.',
                                style: th.bodySmall,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'NOTES\n', style: th.bodyMedium),
                              TextSpan(
                                text: '~490kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: '${val(30)}$unit2 ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: '${val(52)}$unit2 ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: '${val(16)}$unit2 ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                    'fat. Add a pinch of black pepper or chilli flakes to the eggs for extra flavour.',
                                style: th.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Recipe2 extends StatefulWidget {
  const Recipe2({super.key});

  @override
  State<Recipe2> createState() => _Recipe2State();
}

class _Recipe2State extends State<Recipe2> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe3 extends StatefulWidget {
  const Recipe3({super.key});

  @override
  State<Recipe3> createState() => _Recipe3State();
}

class _Recipe3State extends State<Recipe3> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe4 extends StatefulWidget {
  const Recipe4({super.key});

  @override
  State<Recipe4> createState() => _Recipe4State();
}

class _Recipe4State extends State<Recipe4> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe5 extends StatefulWidget {
  const Recipe5({super.key});

  @override
  State<Recipe5> createState() => _Recipe5State();
}

class _Recipe5State extends State<Recipe5> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe6 extends StatefulWidget {
  const Recipe6({super.key});

  @override
  State<Recipe6> createState() => _Recipe6State();
}

class _Recipe6State extends State<Recipe6> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe7 extends StatefulWidget {
  const Recipe7({super.key});

  @override
  State<Recipe7> createState() => _Recipe7State();
}

class _Recipe7State extends State<Recipe7> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe8 extends StatefulWidget {
  const Recipe8({super.key});

  @override
  State<Recipe8> createState() => _Recipe8State();
}

class _Recipe8State extends State<Recipe8> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe9 extends StatefulWidget {
  const Recipe9({super.key});

  @override
  State<Recipe9> createState() => _Recipe9State();
}

class _Recipe9State extends State<Recipe9> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe10 extends StatefulWidget {
  const Recipe10({super.key});

  @override
  State<Recipe10> createState() => _Recipe10State();
}

class _Recipe10State extends State<Recipe10> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe11 extends StatefulWidget {
  const Recipe11({super.key});

  @override
  State<Recipe11> createState() => _Recipe11State();
}

class _Recipe11State extends State<Recipe11> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Recipe12 extends StatefulWidget {
  const Recipe12({super.key});

  @override
  State<Recipe12> createState() => _Recipe12State();
}

class _Recipe12State extends State<Recipe12> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class RecipeTimer extends StatefulWidget {
  final int seconds;

  const RecipeTimer({super.key, required this.seconds});

  @override
  State<RecipeTimer> createState() => _RecipeTimerState();
}

class _RecipeTimerState extends State<RecipeTimer> {
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
                style: Theme.of(context).textTheme.bodyMedium,
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
              iconSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
