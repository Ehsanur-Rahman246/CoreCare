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
  Widget build(BuildContext context) {
    final day = context.watch<TimeProvider>();
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
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
        leading: Icon(Symbols.dinner_dining),
        title: Text('Diet Module'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case 0:
                  Navigator.pushNamed(context, '/dietH');
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
              Navigator.pushNamed(context, '/recipe');
            },
            child: Icon(Symbols.menu_book_rounded),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.small(
            heroTag: 'add',
            onPressed: () {},
            child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Symbols.room_service_rounded), Icon(Icons.add, size: 14,)]),
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
                  style: th.bodyLarge,
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
                  style: th.bodyLarge,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ch.surface,
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
                              style: th.bodySmall,
                            ),
                            Text(
                              "7 / 20 left",
                              style: th.labelMedium,
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
                        color: ch.surface,
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
                              style: th.bodySmall,
                            ),
                            Text(
                              "100 kcal",
                              style: th.labelMedium,
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
                            style: th.labelMedium
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
                              color: ch.onSurface,
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
                            style: th.labelMedium
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
                              color: ch.onSurface,
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
                            style: th.labelMedium
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
                              color: ch.onSurface,
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
                    MealBoxes(title: 'Breakfast', name: 'Food', icon: Symbols.breakfast_dining_rounded, onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => SwapMealScreen()));}, trail: Symbols.hand_meal_rounded,),
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

class MealBoxes extends StatefulWidget {
  final IconData icon;
  final String title;
  final String name;
  final VoidCallback onTap;
  final IconData trail;
  const MealBoxes({super.key, required this.title, required this.name, required this.icon, required this.onTap, required this.trail});

  @override
  State<MealBoxes> createState() => _MealBoxesState();
}

class _MealBoxesState extends State<MealBoxes> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(widget.title),
        leading: Icon(widget.icon),
        subtitle: Text(widget.name),
        trailing: Icon(widget.trail),
        onTap: widget.onTap,
      ),
    );
  }
}

class SwapMealScreen extends StatefulWidget {
  const SwapMealScreen({super.key});

  @override
  State<SwapMealScreen> createState() => _SwapMealScreenState();
}

class _SwapMealScreenState extends State<SwapMealScreen> {
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

class MealModel{
  String? meal;
  String? name;
  int? cal;
  int? carb;
  int? protein;
  int? fat;
  List<String>? tags;
  String? description;
  int? serving;
  Image? photo;

  MealModel({required this.meal, required  this.name, required this.cal, required this.carb, required this.protein, required this.fat, required this.tags, required this.description, required this.serving, required this.photo});
}

class MealProvider extends ChangeNotifier{
  int waterGlass = 12;
  int totalCalories = 0;
  int calorieTaken = 0;
  int carbTaken = 0;
  int proteinTaken = 0;
  int fatTaken = 0;
  int takenMeal = 0;

  late MealModel selectedBreakfast;
  late MealModel selectedLunch;
  late MealModel selectedDinner;

  final List<MealModel> meals = [
    MealModel(meal: 'Breakfast', name: "Egg & oat power bowl", cal: 490, carb: 52, protein: 30, fat: 16, tags: ['VIT-D', 'B12', 'B1', 'VIT-C', 'CA', 'MG', 'FE'], description: '3 eggs scrambled + 80g oats (cooked, water) + 200ml milk + 1 orange', serving: 1, photo: Image.asset('assets/meals/b1.png'),),
    MealModel(meal: 'Breakfast', name: "Oat banana milk bowl", cal: 510, carb: 72, protein: 18, fat: 20, tags: ['B1', 'CA', 'VIT-D', 'MG', 'K', 'VIT-E', 'FIBER-S'], description: '100g oats + 250ml milk + 1 banana + 30g almond butter', serving: 1, photo: Image.asset('assets/meals/b2.png'),),
    MealModel(meal: 'Breakfast', name: "Shakshuka & toast", cal: 560, carb: 40, protein: 28, fat: 18, tags: ['B12', 'VIT-C', 'VIT-K', 'FE', 'B6'], description: '4 eggs poached in tomato-onion sauce + 2 WW toast + herbs', serving: 1, photo: Image.asset('assets/meals/b3.png'),),
    MealModel(meal: 'Breakfast', name: "Masala omelette & chapati", cal: 480, carb: 40, protein: 24, fat: 20, tags: ['B12', 'B6', 'VIT-C', 'VIT-K', 'FE'], description: '3 eggs + onion + tomato + green chili + 1 chapati + 1 tsp oil', serving: 1, photo: Image.asset('assets/meals/b4.png'),),
    MealModel(meal: 'Lunch', name: "Chicken quinoa bowl", cal: 580, carb: 54, protein: 46, fat: 12, tags: ['B3', 'B6', 'VIT-C', 'VIT-K', 'MG', 'B9', 'FIBER-I'], description: '180g chicken breast (grilled) + 185g quinoa + 100g spinach + 100g broccoli + 1 tsp olive oil', serving: 1, photo: Image.asset('assets/meals/l1.png'),),
    MealModel(meal: 'Lunch', name: "Beef rice bowl", cal: 610, carb: 60, protein: 44, fat: 16, tags: ['B12', 'ZN', 'FE', 'VIT-C', 'MG', 'FIBER-I'], description: '150g lean halal beef mince + 200g brown rice + 150g broccoli + 1 tsp oil', serving: 1, photo: Image.asset('assets/meals/l2.png'),),
    MealModel(meal: 'Lunch', name: "Lentil dal + rice", cal: 580, carb: 96, protein: 22, fat: 8, tags: ['B9', 'FE', 'MG', 'K', 'VIT-K', 'FIBER-S'], description: '200g toor dal + 200g basmati rice + 100g spinach + 1 tsp ghee', serving: 1, photo: Image.asset('assets/meals/l3.png'),),
    MealModel(meal: 'Lunch', name: "Chicken curry + rice", cal: 620, carb: 66, protein: 44, fat: 14, tags: ['B3', 'B6', 'VIT-A', 'VIT-C', 'MG'], description: '180g chicken + 200g basmati + curry base + spinach + 1 tsp oil', serving: 1, photo: Image.asset('assets/meals/l4.png'),),
    MealModel(meal: 'Dinner', name: "Lamb & sweet potato", cal: 490, carb: 58, protein: 38, fat: 16, tags: ['B12', 'FE', 'ZN', 'VIT-A', 'VIT-K', 'MG', 'ANTI-I'], description: '150g lamb mince (lean) + 200g sweet potato (baked) + 100g kale + 1 tsp olive oil', serving: 1, photo: Image.asset('assets/meals/d1.png'),),
    MealModel(meal: 'Dinner', name: "Beef stir-fry & brown rice", cal: 490, carb: 68, protein: 40, fat: 14, tags: ['B12', 'ZN', 'FE', 'MG', 'K', 'VIT-C'], description: '150g lean beef + 200g brown rice + 150g mixed veg + soy', serving: 1, photo: Image.asset('assets/meals/d2.png'),),
    MealModel(meal: 'Dinner', name: "Beef & vegetable bowl", cal: 490, carb: 52, protein: 44, fat: 16, tags: ['B12', 'ZN', 'FE', 'VIT-C', 'MG', 'B9'], description: '150g lean beef + 185g quinoa + 150g roasted veg + 1 tsp oil', serving: 1, photo: Image.asset('assets/meals/d3.png'),),
    MealModel(meal: 'Dinner', name: "Grilled fish & chapati", cal: 490, carb: 54, protein: 38, fat: 18, tags: ['OMEGA3', 'D', 'B12', 'CA', 'SE', 'MG'], description: '180g pomfret/rohu + 2 chapati + 100g vegetables + 1 tsp oil', serving: 1, photo: Image.asset('assets/meals/d4.png'),),
  ];

  MealProvider(){
    selectedBreakfast = getMeal('Breakfast').first;
    selectedLunch = getMeal('Lunch').first;
    selectedDinner = getMeal('Dinner').first;
  }

  void selectMeal(MealModel meal){
    switch(meal.meal){
      case 'Breakfast' : selectedBreakfast = meal; break;
      case 'Lunch' : selectedLunch = meal; break;
      case 'Dinner' : selectedDinner = meal; break;
    }
    notifyListeners();
  }

  void logMeal(MealModel meal){
    takenMeal++;
    calorieTaken += meal.cal!;
    carbTaken += meal.carb!;
    proteinTaken += meal.protein!;
    fatTaken += meal.fat!;
    notifyListeners();
  }

  List<MealModel> getMeal(String type){
    return meals.where((m) => m.meal == type).toList();
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
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: RichText(text: TextSpan(children: [TextSpan(text: 'Recipes  ', style: th.titleLarge),WidgetSpan(child: Icon(Symbols.chef_hat_rounded))] )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(
                  children: [
                    WidgetSpan(child: Icon(Symbols.breakfast_dining_rounded)),
                    TextSpan(text: ' Breakfast Recipes', style: th.bodyLarge),
                  ]
                )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ch.surface,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                        Image.asset(
                            'assets/foods/r1.jpg',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10,),
                          Expanded(child: Text('Egg & Oat Power Bowl', style: th.bodyLarge)),
                          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe1()));}, child: Text('See Recipe')),
                        ],
                      ),
                    ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r2.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Shakshuka & Whole Wheat Toast', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe2()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r3.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Masala Omelette & Chapati', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe3()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r4.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Oat Banana Milk Bowl with Almond Butter', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe4()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                RichText(text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Symbols.meal_lunch_rounded)),
                      TextSpan(text: ' Lunch Recipes', style: th.bodyLarge),
                    ]
                )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r5.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Grilled Chicken & Rice', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe5()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r6.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Halal Beef & Lentil Soup', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe6()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r7.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Tuna & Veggie Whole Wheat Wrap', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe7()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r8.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('One-Pan Chicken & Chickpea Stew', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe8()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                RichText(text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Symbols.meal_dinner_rounded)),
                      TextSpan(text: ' Dinner Recipes', style: th.bodyLarge),
                    ]
                )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r9.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Baked Salmon with Roasted Vegetables', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe9()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r10.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Chicken Karahi Curry', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe10()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r11.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Keema Matar (Beef Mince & Peas)', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe11()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ch.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/foods/r12.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Text('Egg Fried Rice', style: th.bodyLarge)),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Recipe12()));}, child: Text('See Recipe')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Diet History'),
      ),
      body: SizedBox(),
    );
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
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
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
                    Text('A high-protein breakfast bowl combining scrambled eggs, oats, and fresh orange — perfect for a training day morning.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '3 eggs\n${val(2.9)}rolled oats (dry)\n0.8 cups of milk\n0.8 cups of water (for oats)\n1 orange\n1 pinch salt\n1 tablespoon olive oil or butter',
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
                              RichText(text: TextSpan(
                                children: [
                                  TextSpan(text: 'Cook the oats: ', style: th.bodyMedium),
                                  TextSpan(text: 'Combine ${val(2.9)}rolled oats (dry) and 0.8 cups water (for oats) in a saucepan over medium heat. Stir constantly and cook for 4–5 minutes until thick and creamy. Pour in 0.8 cups halal milk and stir for another minute. Remove from heat.', style: th.bodySmall),
                                ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Scramble the eggs: ', style: th.bodyMedium),
                                    TextSpan(text: 'Crack 3 eggs into a bowl, add a 1 pinch salt, and whisk well. Heat 1 teaspoons olive oil or butter in a non-stick pan over medium-low heat. Pour in eggs and gently fold with a spatula every few seconds until just set — don\'t overcook.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Assemble: ', style: th.bodyMedium),
                                    TextSpan(text: 'Spoon oats into a bowl, top with scrambled eggs on the side. Peel and slice 1 orange and serve alongside. Eat immediately.', style: th.bodySmall),
                                  ]
                              )),
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
                                text: micro(30),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(52),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(16),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                    'fat.\nAdd a pinch of black pepper or chilli flakes to the eggs for extra flavour.',
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
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Shakshuka & Whole Wheat Toast')),
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
                  'assets/foods/r2.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text('Eggs poached in a spiced tomato-onion sauce, served with whole wheat toast. A hearty, flavourful breakfast.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '4 eggs\n${val(7.1)}canned crushed tomatoes\n${val(2.1)}onion, finely diced\n2 garlic cloves, minced\n1 tablespoons olive oil\n0.5 teaspoons cumin\n0.5 teaspoons paprika\n1 pinch salt & black pepper\n${val(0.2)}fresh parsley or coriander\n2 whole wheat bread slices',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Sauté the base: ', style: th.bodyMedium),
                                    TextSpan(text: 'Heat 1 tablespoons olive oil in a wide skillet over medium heat. Add ${val(2.1)}onion, finely diced and cook for 3–4 minutes until softened and translucent. Add 2 garlic cloves, minced and stir for 1 minute until fragrant.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 240),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Build the sauce: ', style: th.bodyMedium),
                                    TextSpan(text: 'Add ${val(7.1)}canned crushed tomatoes, 0.5 teaspoons cumin, 0.5 teaspoons paprika, and 1 pinch salt & black pepper. Stir well and simmer on medium-low for 5 minutes until the sauce thickens slightly.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Poach the eggs: ', style: th.bodyMedium),
                                    TextSpan(text: 'Make 4 small wells in the sauce with a spoon. Crack 4 eggs one by one into each well. Cover the pan and cook for 5–5m 30s until the whites are fully set but yolks remain slightly runny.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 330),
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
                              '4',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Toast the bread: ', style: th.bodyMedium),
                                    TextSpan(text: 'While eggs cook, toast 2 whole wheat bread slices until golden. Set aside.', style: th.bodySmall),
                                  ]
                              )),
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
                              '5',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Serve: ', style: th.bodyMedium),
                                    TextSpan(text: 'Sprinkle ${val(0.2)}fresh parsley or coriander over the shakshuka. Scoop directly from the pan into a bowl and serve with toast on the side for dipping.', style: th.bodySmall),
                                  ]
                              )),
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
                                text: '~480kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: micro(28),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(40),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(18),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                'fat.\nUse a lid that fits snugly for perfectly poached eggs. Add a pinch of chilli flakes if you like heat.',
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

class Recipe3 extends StatefulWidget {
  const Recipe3({super.key});

  @override
  State<Recipe3> createState() => _Recipe3State();
}

class _Recipe3State extends State<Recipe3> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Masala Omelette & Chapati')),
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
                  'assets/foods/r3.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text('A spiced egg and veggie omelette folded into a warm chapati — a satisfying South Asian-style halal breakfast.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '3 eggs\n${val(1.4)}onion, finely chopped\n${val(1.8)}tomato, diced\n1 green chili (optional), minced\n${val(0.2)}fresh coriander, chopped\n0.3 tablespoons turmeric\n1 pinch salt\n1 teaspoons oil or ghee\n2 medium chapati (store-bought or homemade)',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Beat the eggs: ', style: th.bodyMedium),
                                    TextSpan(text: 'Crack 3 eggs into a bowl. Add 0.3 teaspoons turmeric and 1 pinch salt and beat well with a fork until fully mixed.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Cook the vegetables: ', style: th.bodyMedium),
                                    TextSpan(text: 'Heat 1 teaspoons oil or ghee in a non-stick pan over medium heat. Add ${val(1.4)}onion, finely chopped and sauté for 4 minutes. Add ${val(1.8)}tomato, diced and 1 green chilli (optional), minced (if using) and cook for another 2 minutes until softened.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 240),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Make the omelette: ', style: th.bodyMedium),
                                    TextSpan(text: 'Pour the egg mixture over the vegetables. Let it set for 2 minutes, then gently fold and scramble together. Cook until just done — about 2 minutes. Top with ${val(0.2)}fresh coriander, chopped.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 120),
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
                              '4',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Warm chapati & serve: ', style: th.bodyMedium),
                                    TextSpan(text: 'Warm 2 medium chapati (store-bought or homemade) directly on a dry pan or gas flame for 40 seconds each side. Wrap the masala egg inside the chapatis and serve hot.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 40),
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
                                text: '~460kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: micro(24),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(40),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(20),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                'fat.\nUse ghee instead of oil for a richer, more traditional flavour.',
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

class Recipe4 extends StatefulWidget {
  const Recipe4({super.key});

  @override
  State<Recipe4> createState() => _Recipe4State();
}

class _Recipe4State extends State<Recipe4> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Oat Banana Milk Bowl with Almond Butter')),
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
                  'assets/foods/r4.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text('Creamy oats cooked in milk with banana slices and almond butter — a filling, nutrient-dense breakfast that requires zero cooking skill.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '${val(3.6)}rolled oats (dry)\n1 cups milk\n0.6 cups water\n1 ripe banana\n${val(1.1)}almond butter\n1 teaspoons honey (optional)\n0.3 teaspoons cinnamon',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Start the oats: ', style: th.bodyMedium),
                                    TextSpan(text: 'Add ${val(3.6)}rolled oats (dry), 1 cups milk, and 0.6 cups water to a saucepan. Stir together and bring to a gentle boil over medium heat.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Cook until creamy: ', style: th.bodyMedium),
                                    TextSpan(text: 'Reduce heat to medium-low. Stir constantly for 4–5 minutes until oats are thick and creamy. Add 0.3 teaspoons cinnamon and stir through. Remove from heat.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Top & serve: ', style: th.bodyMedium),
                                    TextSpan(text: 'Slice 1 ripe banana and arrange on top of the oats. Dollop${val(1.1)}almond butter over the top. Drizzle with 1 teaspoons honey (optional) if using. Serve immediately.', style: th.bodySmall),
                                  ]
                              )),
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
                                text: '~560kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: micro(18),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(72),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(20),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                'fat.\nUse extra-ripe banana for natural sweetness and skip the honey.',
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

class Recipe5 extends StatefulWidget {
  const Recipe5({super.key});

  @override
  State<Recipe5> createState() => _Recipe5State();
}

class _Recipe5State extends State<Recipe5> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Grilled Chicken & Rice')),
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
                  'assets/foods/r5.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text('Marinated halal chicken grilled and served over fragrant rice with a simple salad — a protein-packed midday staple.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '${val(5.4)}boneless chicken breast\n${val(3.6)}basmati rice (dry)\n1 lemon, juiced\n2 garlic cloves, minced\n1 tablespoons olive oil\n0.5 teaspoons cumin\n0.5 teaspoons paprika\n1 pinch salt & pepper\n${val(1.8)}cucumber, sliced\n${val(1.8)}tomato, diced\n${val(0.2)}fresh parsley, chopped',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Marinate the chicken: ', style: th.bodyMedium),
                                    TextSpan(text: 'Combine 1 tablespoons olive oil, 1 lemon, juiced, 2 garlic cloves, minced, 0.5 teaspoons cumin, 0.5 teaspoons paprika, and 1 pinch salt & pepper in a bowl. Add ${val(5.4)}boneless chicken breast and coat well. Cover and marinate for at least 20 minutes (or overnight in the fridge).', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 1200),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Cook the rice: ', style: th.bodyMedium),
                                    TextSpan(text: 'Rinse ${val(3.6)}basmati rice (dry) under cold water. Add to a pot with 0.8 cups water, bring to a boil, then reduce to low. Cover and cook for 17 minutes. Remove from heat and let steam for 5 minutes with the lid on.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 1020),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Grill the chicken: ', style: th.bodyMedium),
                                    TextSpan(text: 'Heat a grill pan or skillet over medium-high heat. Cook the chicken for 5–12 minutes per side until golden and cooked through (internal temp 75°C/167°F). Rest for 3 minutes, then slice.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 720),
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
                              '4',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Make the salad: ', style: th.bodyMedium),
                                    TextSpan(text: 'Toss ${val(1.8)}cucumber, sliced and ${val(1.8)}tomato, diced together with a squeeze of lemon and a pinch of salt.', style: th.bodySmall),
                                  ]
                              )),
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
                              '5',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Plate & serve: ', style: th.bodyMedium),
                                    TextSpan(text: 'Plate the rice, lay sliced chicken on top, add salad on the side, and garnish with ${val(0.2)}fresh parsley, chopped.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 720),
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
                                text: '~550kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: micro(45),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(62),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(12),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                'fat.\nMarinate the chicken the night before for deeper flavour. Works great with brown rice too.',
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

class Recipe6 extends StatefulWidget {
  const Recipe6({super.key});

  @override
  State<Recipe6> createState() => _Recipe6State();
}

class _Recipe6State extends State<Recipe6> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Beef & Lentil Soup')),
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
                  'assets/foods/r6.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text('A hearty one-pot beef and lentil soup — warming, high in protein and iron, and easy to batch cook for the week.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '${val(4.3)}lean beef, cubed\n${val(2.1)}red lentils (dry)\n${val(2.1)}onion, diced\n${val(1.8)}carrot, diced\n${val(1.8)}tomato, diced\n2 garlic cloves, minced\n2.5 cups water or beef stock\n1 teaspoons oil\n0.5 teaspoons cumin\n0.5 teaspoons coriander powder\n1 pinch salt & pepper\n1 lemon wedge (to serve)',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Sear the beef: ', style: th.bodyMedium),
                                    TextSpan(text: 'Heat 1 teaspoons oil in a medium pot over medium-high. Add ${val(4.3)}lean beef, cubed and sear for 3–4 minutes, turning until browned on all sides. Remove and set aside.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 240),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Cook the aromatics: ', style: th.bodyMedium),
                                    TextSpan(text: 'In the same pot, add ${val(2.1)}onion, diced and cook for 5 minutes until softened. Add 2 garlic cloves, minced, ${val(1.8)}carrot, diced, and ${val(1.8)}tomato, diced. Cook for another 2 minutes, stirring.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Add lentils and stock: ', style: th.bodyMedium),
                                    TextSpan(text: 'Return beef to the pot. Add 0.5 teaspoons cumin, 0.5 teaspoons coriander powder, 1 pinch salt & pepper, and rinsed ${val(2.1)}red lentils (dry). Pour in 2.5 cups water or halal beef stock and stir everything together.', style: th.bodySmall),
                                  ]
                              )),
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
                              '4',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Simmer until done: ', style: th.bodyMedium),
                                    TextSpan(text: 'Bring to a boil, then reduce to a gentle simmer. Cover and cook for 25–30 minutes until lentils are completely soft and beef is tender.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 1800),
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
                              '5',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Serve: ', style: th.bodyMedium),
                                    TextSpan(text: 'Ladle into a bowl. Squeeze 1 lemon wedge (to serve) over the top and serve hot, optionally with a slice of whole wheat bread.', style: th.bodySmall),
                                  ]
                              )),
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
                                text: '~520kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: micro(42),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(50),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(14),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                'fat.\nGreat for meal prep — doubles well and keeps in the fridge for 3 days.',
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

class Recipe7 extends StatefulWidget {
  const Recipe7({super.key});

  @override
  State<Recipe7> createState() => _Recipe7State();
}

class _Recipe7State extends State<Recipe7> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Tuna & Veggie Whole Wheat Wrap')),
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
                  'assets/foods/r7.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text('A quick tuna salad stuffed into a whole wheat wrap with crisp vegetables — ideal for a fast, high-protein lunch.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '${val(4.3)}canned tuna in water, drained\n2 whole wheat wraps or chapati\n${val(1.1)}plain yoghurt or low-fat mayo\n${val(1.8)}cucumber, sliced\n${val(1.8)}lettuce or spinach leaves\n${val(1.4)}tomato, sliced\nhalf lemon, juiced\n1 pinch salt & black pepper\n0.5 teaspoons garlic powder',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Mix the tuna filling: ', style: th.bodyMedium),
                                    TextSpan(text: 'In a bowl, combine ${val(4.3)}canned tuna in water, drained, ${val(1.1)}plain yoghurt or low-fat mayo, half lemon, juiced, 1 pinch salt & black pepper, and 0.5 teaspoons garlic powder. Mix well until the tuna is evenly coated.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Warm the wraps: ', style: th.bodyMedium),
                                    TextSpan(text: 'Warm 2 whole wheat wraps or chapati briefly in a dry pan or microwave for 20 seconds to make them pliable and easier to roll.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 20),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Layer the fillings: ', style: th.bodyMedium),
                                    TextSpan(text: 'Lay each wrap flat. Spread tuna filling down the centre. Layer ${val(1.8)}lettuce or spinach leaves, ${val(1.8)}cucumber, sliced, and ${val(1.4)}tomato, sliced on top.', style: th.bodySmall),
                                  ]
                              )),
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
                              '4',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Roll & serve: ', style: th.bodyMedium),
                                    TextSpan(text: 'Fold in the sides of each wrap, then roll tightly from the bottom up. Cut diagonally in half and serve immediately.', style: th.bodySmall),
                                  ]
                              )),
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
                                text: '~480kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: micro(40),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(48),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(12),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                'fat.\nUse yoghurt instead of mayo to keep it lighter and higher in protein. Great packed for work.',
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

class Recipe8 extends StatefulWidget {
  const Recipe8({super.key});

  @override
  State<Recipe8> createState() => _Recipe8State();
}

class _Recipe8State extends State<Recipe8> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final data = context.watch<DataProvider>().currentUser!.wantMetricUnit;
    String val(double v) {
      final value = data ? v * 28.35 : v;
      final u = data ? 'grams' : 'ounces';
      return '${value.toStringAsFixed(1)} $u ';
    }
    String micro(double v) {
      final value = data ? v : v * 0.035 ;
      final u = data ? 'g' : 'oz';
      return '${value.toStringAsFixed(1)}$u ';
    }

    return Scaffold(
      appBar: AppBar(title: Text('One-Pan Chicken & Chickpea Stew')),
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
                  'assets/foods/r8.jpg',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text('Golden chicken thighs cooked with chickpeas and tomato in a fragrant one-pan sauce — great over rice or with bread.', style: th.labelMedium),
                    const SizedBox(height: 5,),
                    Text('Servings: 1', style: th.bodySmall,),
                    const SizedBox(height: 10,),
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
                        '${val(5.4)}chicken thighs (boneless)\n${val(4.3)}canned chickpeas, drained\n${val(5.4)}canned tomatoes\n${val(2.1)}onion, diced\n2 garlic cloves, minced\n1 teaspoons oil\n0.5 teaspoons turmeric\n0.5 teaspoons garam masala\n0.5 teaspoons cumin\n1 pinch salt & pepper\n${val(3.6)}basmati rice (dry, to serve)',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Season the chicken: ', style: th.bodyMedium),
                                    TextSpan(text: 'Season ${val(5.4)} chicken thighs (boneless) with 0.5 teaspoons turmeric, 0.5 teaspoons garam masala, 0.5 teaspoons cumin, and 1 pinch salt & pepper. Let sit for 5 minutes.', style: th.bodySmall),
                                  ]
                              )),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Sear the chicken: ', style: th.bodyMedium),
                                    TextSpan(text: 'Heat 1 teaspoons oil in a pan over medium-high heat. Add chicken and cook for 4–9 minutes per side until golden. Remove and set aside.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 540),
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Make the sauce: ', style: th.bodyMedium),
                                    TextSpan(text: 'In the same pan, add ${val(2.1)}onion, diced and cook for 4 minutes. Add 2 garlic cloves, minced and stir for 1 minute. Pour in ${val(5.4)}canned tomatoes and stir together.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 240),
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
                              '4',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Simmer together: ', style: th.bodyMedium),
                                    TextSpan(text: 'Add ${val(4.3)}canned chickpeas, drained and return the chicken to the pan. Reduce heat to medium-low, cover, and simmer for 15 minutes until the chicken is cooked through and the sauce has thickened.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 900),
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
                              '5',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Cook the rice: ', style: th.bodyMedium),
                                    TextSpan(text: 'While the dish simmers, rinse and cook ${val(3.6)}basmati rice (dry, to serve) with 200ml water: boil, then cover and steam on low for 12 minutes.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 720),
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
                              '6',
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
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Plate & serve: ', style: th.bodyMedium),
                                    TextSpan(text: 'Serve chicken and chickpeas over rice. Spoon extra sauce generously over the top.', style: th.bodySmall),
                                  ]
                              )),
                              const SizedBox(height: 8),
                              RecipeTimer(seconds: 900),
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
                                text: '~590kcal | ',
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.redPrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: micro(46),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.bluePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text: 'protein | ',
                                style: th.labelMedium,
                              ),
                              TextSpan(
                                text: micro(66),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.yellowPrimary(context),
                                ),
                              ),
                              TextSpan(text: 'carbs | ', style: th.labelMedium),
                              TextSpan(
                                text: micro(14),
                                style: th.labelMedium?.copyWith(
                                  color: CustomColors.orangePrimary(context),
                                ),
                              ),
                              TextSpan(
                                text:
                                'fat.\nChicken thighs stay juicier than breast in this dish. Swap to breast if you prefer lower fat.',
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
