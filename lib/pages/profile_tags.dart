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
        Chip(
          label: Text(
            user.ageGroup,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          avatar: Icon(
            Icons.cake_rounded,
            color: CustomColors.bluePrimary(context),
          ),
          shape: StadiumBorder(),
          backgroundColor: CustomColors.blueMuted(context),
          side: BorderSide(color: CustomColors.blueOutline(context)),
        ),
        Chip(
          label: Text(
            user.profileTag,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          avatar: Icon(
            Icons.person_rounded,
            color: CustomColors.purplePrimary(context),
          ),
          shape: StadiumBorder(),
          backgroundColor: CustomColors.purpleMuted(context),
          side: BorderSide(color: CustomColors.purpleOutline(context)),
        ),
        Chip(
          label: Text(
            user.goalType,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          avatar: Icon(
            Symbols.target_rounded,
            color: CustomColors.greenPrimary(context),
          ),
          shape: StadiumBorder(),
          backgroundColor: CustomColors.greenMuted(context),
          side: BorderSide(color: CustomColors.greenOutline(context)),
        ),
        Chip(
          label: Text(
            currStat,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          avatar: Icon(avatar),
          shape: StadiumBorder(),
          backgroundColor: CustomColors.primaryMuted(context),
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
