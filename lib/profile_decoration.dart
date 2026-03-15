import 'package:flutter/material.dart';
import 'main.dart';

class ProfileWidgets{
  static Widget profileList(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Name', style: Theme.of(context).textTheme.labelLarge,), Text('User', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Age', style: Theme.of(context).textTheme.labelLarge,), Text('21 yrs', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Gender', style: Theme.of(context).textTheme.labelLarge,), Text('Male', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Country', style: Theme.of(context).textTheme.labelLarge,), Text('Bangladesh', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }

  static Widget statList(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Height', style: Theme.of(context).textTheme.labelLarge,), Text('170 cm', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Weight', style: Theme.of(context).textTheme.labelLarge,), Text('70 kg', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('BMI', style: Theme.of(context).textTheme.labelLarge,), Text('22.9-Normal', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('BMR', style: Theme.of(context).textTheme.labelLarge,), Text('1470 kcal/day', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
  static Widget fitList(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Fitness Level', style: Theme.of(context).textTheme.labelLarge,), Text('Beginner', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Activity Level', style: Theme.of(context).textTheme.labelLarge,), Text('Active', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Occupation', style: Theme.of(context).textTheme.labelLarge,), Text('Student', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Workout Style', style: Theme.of(context).textTheme.labelLarge,), Text('Calisthenics', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Primary Goal', style: Theme.of(context).textTheme.labelLarge,), Text('Casual', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Secondary Goal', style: Theme.of(context).textTheme.labelLarge,), Text('Sports', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 15,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Progress to goal', style: Theme.of(context).textTheme.labelLarge,), Text('70%', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 10,),
          SizedBox(height: 8,child: LinearProgressIndicator(value: 0.7,backgroundColor: Theme.of(context).colorScheme.tertiary, color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(10),)),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
  static Widget dietList(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Diet Type', style: Theme.of(context).textTheme.labelLarge,), Text('Paleo', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Meals/Day', style: Theme.of(context).textTheme.labelLarge,), Text('4 meals', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Calorie Goal', style: Theme.of(context).textTheme.labelLarge,), Text('~2100 kcal', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Region', style: Theme.of(context).textTheme.labelLarge,), Text('South Asian', style: Theme.of(context).textTheme.bodyMedium,)],),
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
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Wake up', style: Theme.of(context).textTheme.labelLarge,), Text('8:00 AM', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Sleep time', style: Theme.of(context).textTheme.labelLarge,), Text('1:00 PM', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Workout time', style: Theme.of(context).textTheme.labelLarge,), Text('Evening', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Work Hours', style: Theme.of(context).textTheme.labelLarge,), Text('11 AM - 4 PM', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Free days', style: Theme.of(context).textTheme.labelLarge,), Text('Fri, Sat', style: Theme.of(context).textTheme.bodyMedium,)],),
          const SizedBox(height: 8,),
          Divider(height: 0.5, color: CustomColors.greyDark(context),),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
}


class EditSheets{
  static void Function(BuildContext) profileEdit = (BuildContext context){
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