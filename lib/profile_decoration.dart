import 'package:flutter/material.dart';
import 'package:core_care/data_provider.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ProfileWidgets{
  static Widget statList(BuildContext context){
    final user = context.watch<DataProvider>().currentUser!;
    String displayHeight;
    if(user.wantMetricUnit){
      displayHeight = '${user.heightCm} cm';
    }else{
      final totalInches = user.heightCm / 2.54;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      displayHeight = '$feet ft $inches in';
    }
    String displayWeight;
    if(user.wantMetricUnit){
      displayWeight = '${user.weightKg} kg';
    }else{
      final lbs = (user.weightKg / 0.453592).toStringAsFixed(1);
      displayWeight = '$lbs lbs';
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Height', style: Theme.of(context).textTheme.labelLarge,), Text(displayHeight, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Weight', style: Theme.of(context).textTheme.labelLarge,), Text(displayWeight, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('BMI', style: Theme.of(context).textTheme.labelLarge,), Text('${user.bmi}-${user.bmiCategory}', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('BMR', style: Theme.of(context).textTheme.labelLarge,), Text('${user.bmr.round()} kcal', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
  static Widget fitList(BuildContext context){
    final user = context.watch<DataProvider>().currentUser!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Fitness Level', style: Theme.of(context).textTheme.labelLarge,), Text(user.fitType, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Activity Level', style: Theme.of(context).textTheme.labelLarge,), Text(user.activityLevel, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Work Type', style: Theme.of(context).textTheme.labelLarge,), Text(user.workType, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Workout Style', style: Theme.of(context).textTheme.labelLarge,), Text(user.styleType.length > 1 ? '${user.styleType.first} & ${user.styleType.length -1} others' : user.styleType.first, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Fundamental', style: Theme.of(context).textTheme.labelLarge,), Text(user.fundType, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Goal', style: Theme.of(context).textTheme.labelLarge,), Text(user.goalType, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 15,),
          if(user.planType == 'Timed')
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Progress to goal', style: Theme.of(context).textTheme.labelLarge,), Text('70%', style: Theme.of(context).textTheme.bodyMedium,)],),
                const SizedBox(height: 10,),
                SizedBox(height: 8,child: LinearProgressIndicator(value: 0.7,backgroundColor: Theme.of(context).colorScheme.tertiary, color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(10),)),
                const SizedBox(height: 8,),
              ],),
        ],
      ),
    );
  }
  static Widget dietList(BuildContext context){
    final user = context.watch<DataProvider>().currentUser!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Diet Type', style: Theme.of(context).textTheme.labelLarge,), Text(user.dietType, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Meals/Day', style: Theme.of(context).textTheme.labelLarge,), Text(user.mealType, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Calorie Goal', style: Theme.of(context).textTheme.labelLarge,), Text('~${user.tdee.round()} kcal', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Regional Food', style: Theme.of(context).textTheme.labelLarge,), Text(user.regionType.length > 1 ? '${user.regionType.first} & ${user.regionType.length -1} others' : user.regionType.first, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
  static Widget medList(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medical Conditions'),
          const SizedBox(height: 8,),
          Wrap(children: [Chip(label: Text('Hypertension')),Chip(label: Text('Hypertension')),Chip(label: Text('Hypertension')),Chip(label: Text('Hypertension')),Chip(label: Text('Hypertension')),]),
          const SizedBox(height: 15,),
          Text('Allergies'),
          const SizedBox(height: 8,),
          Wrap(children: [Chip(label: Text('Gluten')),Chip(label: Text('Lactose')),Chip(label: Text('Nuts')),]),
          const SizedBox(height: 15,),
          Text('Injuries'),
          const SizedBox(height: 8,),
          Wrap(children: [Chip(label: Text('None')),]),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }
  static Widget timeList(BuildContext context){
    final user = context.watch<DataProvider>().currentUser!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Sleep time', style: Theme.of(context).textTheme.labelLarge,), Text(user.sleepPattern, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Total Hrs of sleep', style: Theme.of(context).textTheme.labelLarge,), Text(user.sleepPattern, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Workout time', style: Theme.of(context).textTheme.labelLarge,), Text(user.timeType.length > 1 ? '${user.timeType.first} & ${user.timeType.length -1} others' : user.timeType.first, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Workout Session', style: Theme.of(context).textTheme.labelLarge,), Text(user.durationType, style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Workout Per Week', style: Theme.of(context).textTheme.labelLarge,), Text('${user.dayType} days', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Free days', style: Theme.of(context).textTheme.labelLarge,), Text(user.freeType.length > 2 ? '${user.freeType.first} & ${user.freeType.length -1} more' : '${user.freeType.first}, ${user.freeType[1]}', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
}


class EditSheets{
  static void Function(BuildContext) statEdit = (BuildContext context){
    showModalBottomSheet(context: context,isScrollControlled: true, builder: (ctx){
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
      );
    });
  };
  static void Function(BuildContext) fitEdit = (BuildContext context){
    showModalBottomSheet(context: context,isScrollControlled: true, builder: (ctx){
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
      );
    });
  };
  static void Function(BuildContext) dietEdit = (BuildContext context){
    showModalBottomSheet(context: context,isScrollControlled: true, builder: (ctx){
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
      );
    });
  };
  static void Function(BuildContext) medEdit = (BuildContext context){
    showModalBottomSheet(context: context,isScrollControlled: true, builder: (ctx){
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
      );
    });
  };
  static void Function(BuildContext) timeEdit = (BuildContext context){
    showModalBottomSheet(context: context,isScrollControlled: true, builder: (ctx){
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
      );
    });
  };
}