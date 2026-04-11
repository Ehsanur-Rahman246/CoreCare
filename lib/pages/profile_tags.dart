import 'package:core_care/data_provider.dart';
import 'package:core_care/main.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class ProfileTags extends StatefulWidget {
  const ProfileTags({super.key});

  @override
  State<ProfileTags> createState() => _ProfileTagsState();
}

class _ProfileTagsState extends State<ProfileTags> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<DataProvider>().currentUser!;
    final status = context.watch<StatusProvider>().status;
    String currStat = '';
    IconData? avatar;

    switch (status) {
      case Status.fasting:
        currStat = 'Fasting';
        avatar = Symbols.hourglass_arrow_down_rounded;
        break;
      case Status.travelling:
        currStat = 'Travelling';
        avatar = Symbols.travel_rounded;
        break;
      case Status.injured:
        currStat = 'Injured';
        avatar = Symbols.healing_rounded;
        break;
      case Status.sick:
        currStat = 'Sick';
        avatar = Symbols.sick_rounded;
        break;
      case Status.active:
        currStat = 'Active';
        avatar = Symbols.directions_run_rounded;
        break;
      case Status.rest:
        currStat = 'On Rest';
        avatar = Symbols.bed_rounded;
        break;
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 5,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: ShapeDecoration(
            color: CustomColors.blueMuted(context),
            shape: StadiumBorder(
              side: BorderSide(color: CustomColors.blueOutline(context)),
            ),),
          child: RichText(text: TextSpan(children: [WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
            Icons.cake_rounded,
            size: 14,
            color: CustomColors.bluePrimary(context),
          ),),
            TextSpan(text: ' '),
            TextSpan(text: user.ageGroup,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),),])),),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: ShapeDecoration(
            color: CustomColors.purpleMuted(context),
            shape: StadiumBorder(
              side: BorderSide(color: CustomColors.purpleOutline(context)),
            ),),
          child: RichText(text: TextSpan(children: [WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              Icons.person_rounded,
              size: 14,
              color: CustomColors.purplePrimary(context),
            ),),
            TextSpan(text: ' '),
            TextSpan(text: user.profileTag,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),),])),),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: ShapeDecoration(
            color: CustomColors.greenMuted(context),
            shape: StadiumBorder(
              side: BorderSide(color: CustomColors.greenOutline(context)),
            ),),
          child: RichText(text: TextSpan(children: [WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              Symbols.target_rounded,
              size: 14,
              color: CustomColors.greenPrimary(context),
            ),),
            TextSpan(text: ' '),
            TextSpan(text: user.goalType,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),),])),),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: ShapeDecoration(
            color: CustomColors.primaryMuted(context),
            shape: StadiumBorder(
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),),
          child: RichText(text: TextSpan(children: [WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              avatar,
              size: 14,
              color: CustomColors.greenPrimary(context),
            ),),
            TextSpan(text: ' '),
            TextSpan(text: currStat,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),),])),),
      ],
    );
  }
}
