import 'package:core_care/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:core_care/main.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

enum DietState { taken, remaining, normal, fasting, today }

class _DietScreenState extends State<DietScreen> {
  @override
  Widget build(BuildContext context) {
    final day = context.watch<TimeProvider>();
    
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Symbols.dinner_dining),
        title: Text('Diet Module'),
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
            const SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (i){
                  final now = day.now;
                  final firstDayOfWeek = now.subtract(Duration(days: now.weekday % 7));
                  final date = firstDayOfWeek.add(Duration(days: i));
                  DietState state;
                  if(date.day == now.day && date.month == now.month && date.year == now.year){
                    state = DietState.today;
                  }
                  else{
                    state = DietState.normal;
                  }
                  final dayName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
                  final text = "$dayName\n${date.day}";

                  return weekBox(text, state);
                })
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Today\'s meals',
                style: Theme.of(context).textTheme.titleSmall,
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
        icon = null;
        color = null;
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
