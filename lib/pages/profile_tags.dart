import 'package:core_care/data_provider.dart';
import 'package:core_care/main.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class ProfileTags extends StatefulWidget {
  const ProfileTags({super.key});

  @override
  State<ProfileTags> createState() => _ProfileTagsState();
}

class _ProfileTagsState extends State<ProfileTags> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<DataProvider>().currentUser!;

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
            user.goalType,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          shape: StadiumBorder(),
          backgroundColor: CustomColors.greenMuted(context),
          side: BorderSide(color: CustomColors.greenOutline(context)),
          labelPadding: EdgeInsets.all(0),
        ),
      ],
    );
  }
}
