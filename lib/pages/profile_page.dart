import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_care/pages/profile_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:core_care/data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:core_care/main.dart';
import 'package:core_care/profile_decoration.dart';
import 'package:core_care/decoration.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StreamSubscription? _linkGoogleSub;

  Future<void> _linkGoogle() async {
    if (kIsWeb) return;
    final provider = context.read<DataProvider>();
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final existing = await FirebaseFirestore.instance
          .collection('users')
          .where('googleId', isEqualTo: googleUser.id)
          .limit(1)
          .get();
      if (existing.docs.isNotEmpty) {
        await GoogleSignIn.instance.signOut();
        Fluttertoast.showToast(
          msg: 'This Google account is already linked to another user',
        );
        return;
      }
      await provider.updateGoogleLink(googleUser.id, googleUser.email);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google sign-in failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _linkGoogleSub = GoogleSignIn.instance.authenticationEvents.listen((
        event,
      ) async {
        if (!mounted) return;
        if (FirebaseAuth.instance.currentUser == null) return;
        final GoogleSignInAccount? user = switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          _ => null,
        };
        if (user == null) return;
        final provider = context.read<DataProvider>();
        final currentUser = provider.currentUser;
        if (currentUser == null || currentUser.googleId != null) return;
        final existing = await FirebaseFirestore.instance
            .collection('users')
            .where('googleId', isEqualTo: user.id)
            .limit(1)
            .get();
        if (existing.docs.isNotEmpty) {
          Fluttertoast.showToast(
            msg: 'This Google account is already linked to another user',
          );
          return;
        }
        await provider.updateGoogleLink(user.id, user.email);
      });
    }
  }

  @override
  void dispose() {
    _linkGoogleSub?.cancel();
    super.dispose();
  }

  Future<void> _unlinkGoogle() async {
    final provider = context.read<DataProvider>();
    final confirm = await _showUnlinkDialog('Google');
    if (!confirm) return;
    await GoogleSignIn.instance.signOut();
    await provider.updateGoogleLink(null, null);
  }

  Future<void> _linkApple() async {
    final provider = context.read<DataProvider>();
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );
      final existing = await FirebaseFirestore.instance
          .collection('users')
          .where('appleId', isEqualTo: appleCredential.userIdentifier)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'This Apple account is already linked to another user',
        );
        return;
      }
      await provider.updateAppleLink(
        appleCredential.userIdentifier,
        appleCredential.email,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Apple sign-in failed: $e');
    }
  }

  Future<void> _unlinkApple() async {
    final provider = context.read<DataProvider>();
    final confirm = await _showUnlinkDialog('Apple');
    if (!confirm) return;
    await provider.updateAppleLink(null, null);
  }

  Future<bool> _showUnlinkDialog(String provider) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Unlink $provider'),
            content: Text('This will remove your $provider connection.'),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Unlink'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<DataProvider>().currentUser;
    if (user == null) return const SizedBox.shrink();
    final isGoogleConnected = user.googleId != null;
    final isAppleConnected = user.appleId != null;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: ProfileHeader(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
                minHeight: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
            SliverPersistentHeader(
              delegate: SpacerDelegate(maxSpace: 200, minSpace: 20),
            ),
            SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ExpansionTile(
                    collapsedBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Emoji.profile,
                    ),
                    title: Text('Personal Information'),
                    subtitle: Text(
                      'Name & info',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    children: [
                      Divider(height: 1, color: CustomColors.greyDark(context)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Age',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  '${user.age}yrs',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gender',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.gender,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Group',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.ageGroup,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  const SizedBox(height: 10),
                  profileTile(
                    Emoji.stat,
                    'Body Stats',
                    'Height, Weight & BMI',
                    ProfileWidgets.statList(context),
                    "Body Stats",
                    EditSheets.statEdit,
                    context,
                  ),
                  const SizedBox(height: 10),
                  profileTile(
                    Emoji.fit,
                    'Fitness Profile',
                    'Activity & Goals',
                    ProfileWidgets.fitList(context),
                    "Fitness Profile",
                    EditSheets.fitEdit,
                    context,
                  ),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    collapsedBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Emoji.diet,
                    ),
                    title: Text('Diet Profile'),
                    subtitle: Text(
                      'Meal & Diet preferences',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    children: [
                      Divider(height: 1, color: CustomColors.greyDark(context)),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Diet Type',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.dietType,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Meals/Day',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.mealType,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Calorie Goal',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  '~${user.tdee.round()} kcal',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Regional Food',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.regionType.length > 1
                                      ? '${user.regionType.first} & ${user.regionType.length - 1} others'
                                      : user.regionType.first,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      Center(
                        child: OutlinedButton(
                          onPressed: () => EditSheets.dietEdit(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit),
                              const SizedBox(width: 8),
                              Text("Edit Diet Preferences"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Symbols.allergies_rounded),
                                const SizedBox(width: 10),
                                Text('Your Allergies'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ProfileAllergyChips(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Symbols.gastroenterology_rounded),
                                const SizedBox(width: 10),
                                Text('Your Intolerances'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ProfileIntoleranceChips(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Symbols.sentiment_dissatisfied_rounded),
                                const SizedBox(width: 10),
                                Text('Your Dislikes in food'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ProfileDislikeChips(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    collapsedBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Emoji.med,
                    ),
                    title: Text('Health & Conditions'),
                    subtitle: Text(
                      'Medical Conditions and injuries',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    children: [
                      Divider(height: 1, color: CustomColors.greyDark(context)),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.medical_services_outlined),
                                const SizedBox(width: 10),
                                Text('Medical Conditions'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ProfileMedChips(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.personal_injury_outlined),
                                const SizedBox(width: 10),
                                Text('Current Injuries'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ProfileInjuryChips(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  profileTile(
                    Emoji.time,
                    'Schedule',
                    'Daily routine & workout timing',
                    ProfileWidgets.timeList(context),
                    "Schedule",
                    EditSheets.timeEdit,
                    context,
                  ),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    collapsedBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Emoji.id,
                    ),
                    title: Text('Account Settings'),
                    subtitle: Text(
                      'User account information',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    children: [
                      Divider(height: 1, color: CustomColors.greyDark(context)),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Username',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.username,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Email',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.email,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mobile no.',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  user.phone ?? 'None',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 0.5,
                              color: CustomColors.greyDark(context),
                            ),
                            const SizedBox(height: 15),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 15,
                              runSpacing: 10,
                              children: [
                                OutlinedButton(
                                  onPressed: () => EditSheets.userEdit(context),
                                  child: Padding(
                                    padding: const EdgeInsetsGeometry.symmetric(
                                      vertical: 15,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.person),
                                        const SizedBox(width: 10),
                                        Text('Edit username or email'),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                OutlinedButton(
                                  onPressed: () =>
                                      EditSheets.phoneEdit(context),
                                  child: Padding(
                                    padding: const EdgeInsetsGeometry.symmetric(
                                      vertical: 15,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.phone),
                                        const SizedBox(width: 10),
                                        Text('Edit mobile no'),
                                      ],
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: CustomColors.orangeOutline(
                                        context,
                                      ),
                                    ),
                                    foregroundColor: CustomColors.orangeOutline(
                                      context,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Padding(
                                    padding: const EdgeInsetsGeometry.symmetric(
                                      vertical: 15,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.edit),
                                        const SizedBox(width: 10),
                                        Text('Change Password'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Emoji.google,
                                title: Text('Google ID'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isGoogleConnected
                                          ? 'connected'
                                          : 'not connected',
                                      style: TextStyle(
                                        color: isGoogleConnected
                                            ? CustomColors.greenOutline(context)
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                      ),
                                    ),
                                    isGoogleConnected
                                        ? Text('Email: ${user.googleEmail}')
                                        : SizedBox(),
                                  ],
                                ),
                                subtitleTextStyle: Theme.of(
                                  context,
                                ).textTheme.labelMedium,
                                trailing: isGoogleConnected
                                    ? IconButton(
                                        onPressed: _unlinkGoogle,
                                        icon: Icon(Icons.link_off),
                                      )
                                    : kIsWeb
                                    ? SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Stack(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.sync),
                                            ),
                                            Opacity(
                                              opacity: 0.005,
                                              child: SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: web.renderButton(
                                                  configuration:
                                                      GSIButtonConfiguration(
                                                        size: web
                                                            .GSIButtonSize
                                                            .large,
                                                        shape:
                                                            GSIButtonShape.pill,
                                                        minimumWidth: 5000,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: _linkGoogle,
                                        icon: Icon(Icons.sync),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Emoji.apple,
                                title: Text('Apple ID'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAppleConnected
                                          ? 'connected'
                                          : 'not connected',
                                      style: TextStyle(
                                        color: isAppleConnected
                                            ? CustomColors.greenOutline(context)
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                      ),
                                    ),
                                    isAppleConnected
                                        ? Text('Email: ${user.appleEmail}')
                                        : SizedBox(),
                                  ],
                                ),
                                subtitleTextStyle: Theme.of(
                                  context,
                                ).textTheme.labelMedium,
                                trailing: IconButton(
                                  onPressed: isAppleConnected
                                      ? _unlinkApple
                                      : _linkApple,
                                  icon: Icon(
                                    isAppleConnected
                                        ? Icons.link_off
                                        : Icons.sync,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 50,
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Log Out'),
                              content: Text(
                                'Do you want to sign out from the account?',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                  onPressed: () async {
                                    await HomeScreen.logUserOut();
                                    if (context.mounted) {
                                      Navigator.of(
                                        context,
                                      ).pushNamedAndRemoveUntil(
                                        '/auth',
                                        (route) => false,
                                      );
                                      context.read<DataProvider>().clearUser();
                                    }
                                  },
                                  child: Text('Log out'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            const SizedBox(width: 10),
                            Text('Log Out'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 50,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Delete Account',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Do you want to delete your account?',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'All the data of your account will be deleted.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await context
                                          .read<DataProvider>()
                                          .deleteUserAccount();
                                      await FirebaseAuth.instance.currentUser
                                          ?.delete();
                                      await FirebaseAuth.instance.signOut();
                                      if (context.mounted) {
                                        Navigator.of(
                                          context,
                                        ).pushNamedAndRemoveUntil(
                                          '/auth',
                                          (route) => false,
                                        );
                                        context
                                            .read<DataProvider>()
                                            .clearUser();
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                          msg: 'Failed to delete account: $e',
                                        );
                                      }
                                    }
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            const SizedBox(width: 10),
                            Text('Delete Account'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileTile(
    Image img,
    String title,
    String sub,
    Widget list,
    String edit,
    Function(BuildContext) function,
    BuildContext context,
  ) {
    return ExpansionTile(
      collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      leading: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: img,
      ),
      title: Text(title),
      subtitle: Text(sub, style: Theme.of(context).textTheme.labelSmall),
      children: [
        Divider(height: 1, color: CustomColors.greyDark(context)),
        list,
        Center(
          child: OutlinedButton(
            onPressed: () => function(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit),
                const SizedBox(width: 8),
                Text("Edit $edit"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class ProfileHeader extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;

  ProfileHeader({required this.maxHeight, required this.minHeight});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isCollapsed = shrinkOffset >= (maxExtent - minExtent);
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    if (isCollapsed) {
      return Opacity(opacity: progress, child: CollapsedProfileHeader());
    } else {
      return Opacity(opacity: 1 - progress, child: ExpandedProfileHeader());
    }
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SpacerDelegate extends SliverPersistentHeaderDelegate {
  final double maxSpace;
  final double minSpace;

  SpacerDelegate({required this.maxSpace, required this.minSpace});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final space = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
    return Container(height: space, color: Colors.transparent);
  }

  @override
  double get maxExtent => maxSpace;

  @override
  double get minExtent => minSpace;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class ExpandedProfileHeader extends StatefulWidget {
  static bool hasImage = false;
  static Uint8List imageBytes = Uint8List(0);

  const ExpandedProfileHeader({super.key});

  @override
  State<ExpandedProfileHeader> createState() => _ExpandedProfileHeaderState();
}

class _ExpandedProfileHeaderState extends State<ExpandedProfileHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImageFromUrl();
      setState(() {});
    });
  }

  void _loadImageFromUrl() {
    final base64 = context.read<DataProvider>().profileImageBase64;
    if (base64 == null || base64.isEmpty) return;
    final bytes = base64Decode(base64);
    ExpandedProfileHeader.imageBytes = bytes;
    ExpandedProfileHeader.hasImage = true;
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      maxHeight: 300,
      maxWidth: 300,
      imageQuality: 50,
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      final imageFile = await XFile(pickedImage.path).readAsBytes();
      ExpandedProfileHeader.imageBytes = imageFile;
      setState(() => ExpandedProfileHeader.hasImage = true);
      if (mounted) {
        await context.read<DataProvider>().uploadProfileImage(imageFile);
      }
    }
  }

  void removeImage() {
    setState(() {
      ExpandedProfileHeader.hasImage = false;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            AlertDialog(
              title: Text("Edit Profile Image"),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    removeImage();
                    Navigator.pop(context);
                  },
                  child: Text('Remove Image'),
                ),
                FilledButton(
                  onPressed: () {
                    pickImage();
                    Navigator.pop(context);
                  },
                  child: Text('Change Image'),
                ),
              ],
            ),
            Align(
              alignment: Alignment(0.6, -0.09),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<DataProvider>().currentUser!;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "Profile",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: -190,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 15),
              child: Column(
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Divider(color: Theme.of(context).colorScheme.tertiary),
                  ProfileTags(),
                  Divider(color: Theme.of(context).colorScheme.tertiary),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.tertiary,
                            child: Emoji.starter,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Starter",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "110 XP",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.tertiary,
                            child: Emoji.fire,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "3 day",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "Streak",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.tertiary,
                            child: Emoji.coin,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "100 FC",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "FitCoins",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded, size: 40),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.greyDark(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsetsGeometry.all(5),
                child: Emoji.settings,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (!ExpandedProfileHeader.hasImage)
                  CircleAvatar(
                    backgroundColor: CustomColors.greyLight(context),
                    radius: 37,
                    child: Icon(Icons.person, size: 40),
                  )
                else
                  CircleAvatar(
                    radius: 37,
                    foregroundImage: MemoryImage(
                      ExpandedProfileHeader.imageBytes,
                    ),
                  ),
                Positioned(
                  right: -5,
                  bottom: -5,
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        if (ExpandedProfileHeader.hasImage) {
                          _showDialog();
                        } else {
                          pickImage();
                        }
                      },
                      icon: ExpandedProfileHeader.hasImage
                          ? Icon(Icons.edit)
                          : Icon(Icons.camera_alt),
                      iconSize: 18,
                      tooltip: "Add",
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CollapsedProfileHeader extends StatefulWidget {
  const CollapsedProfileHeader({super.key});

  @override
  State<CollapsedProfileHeader> createState() => _CollapsedProfileHeaderState();
}

class _CollapsedProfileHeaderState extends State<CollapsedProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();
    final user = provider.currentUser!;

    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left_rounded, size: 40),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: ExpandedProfileHeader.hasImage
                ? CircleAvatar(
                    radius: 18,
                    foregroundImage: MemoryImage(
                      ExpandedProfileHeader.imageBytes,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: CustomColors.greyDark(context),
                    radius: 18,
                    child: Icon(
                      Icons.person,
                      color: CustomColors.greyLight(context),
                    ),
                  ),
          ),
          const SizedBox(width: 15),
          Text(
            user.name,
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.greyDark(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsetsGeometry.all(5),
                  child: Emoji.settings,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
