import 'package:flutter/material.dart';
import 'package:core_care/data_provider.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'decoration.dart';
import 'main.dart';
import 'package:core_care/pages/sign_up_pages.dart';

class ProfileWidgets {
  static Widget statList(BuildContext context) {
    final user = context.watch<DataProvider>().currentUser!;
    String displayHeight;
    if (user.wantMetricUnit) {
      displayHeight = '${user.heightCm} cm';
    } else {
      final totalInches = user.heightCm / 2.54;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      displayHeight = '$feet ft $inches in';
    }
    String displayWeight;
    if (user.wantMetricUnit) {
      displayWeight = '${user.weightKg} kg';
    } else {
      final lbs = (user.weightKg / 0.453592).toStringAsFixed(1);
      displayWeight = '$lbs lbs';
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Height', style: Theme.of(context).textTheme.labelLarge),
              Text(
                displayHeight,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weight', style: Theme.of(context).textTheme.labelLarge),
              Text(
                displayWeight,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('BMI', style: Theme.of(context).textTheme.labelLarge),
              Text(
                '${user.bmi}-${user.bmiCategory}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('BMR', style: Theme.of(context).textTheme.labelLarge),
              Text(
                '${user.bmr.round()} kcal',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static Widget fitList(BuildContext context) {
    final user = context.watch<DataProvider>().currentUser!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fitness Level',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(user.fitType, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Level',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                user.activityLevel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Work Type', style: Theme.of(context).textTheme.labelLarge),
              Text(
                user.workType,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout Style',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                user.styleType.length > 1
                    ? '${user.styleType.first} & ${user.styleType.length - 1} others'
                    : user.styleType.first,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Equipment', style: Theme.of(context).textTheme.labelLarge),
              Text(
                user.equipType,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fundamental',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                user.fundType,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Goal', style: Theme.of(context).textTheme.labelLarge),
              Text(
                user.goalType,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 15),
          if (user.planType == 'Timed')
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress to goal',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text('70%', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
        ],
      ),
    );
  }

  static Widget timeList(BuildContext context) {
    final user = context.watch<DataProvider>().currentUser!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Hrs of sleep',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                user.sleepPattern,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout time',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                user.timeType.length > 1
                    ? '${user.timeType.first} & ${user.timeType.length - 1} others'
                    : user.timeType.first,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout Session',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                user.durationType,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout Place',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                user.placeType,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout Per Week',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                '${user.dayType} days',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Free days', style: Theme.of(context).textTheme.labelLarge),
              Text(
                user.freeType.length > 2
                    ? '${user.freeType.first} & ${user.freeType.length - 1} more'
                    : '${user.freeType.first}, ${user.freeType[1]}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 0.5, color: CustomColors.greyDark(context)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class ProfileMedChips extends StatefulWidget {
  const ProfileMedChips({super.key});

  @override
  State<ProfileMedChips> createState() => _ProfileMedChipsState();
}

class _ProfileMedChipsState extends State<ProfileMedChips> {
  final List<String> maleMeds = [
    'High blood pressure',
    'High cholesterol',
    'Type 2 diabetes',
    'Pre-diabetes',
    'Obesity',
    'Acid reflux',
    'Irritable bowel',
    'Asthma',
    'Chronic fatigue',
    'Burnout',
    'Post-illness',
    'Deconditioning',
    'Tension headaches',
    'Low blood pressure',
    'Anaemia',
    'Insulin resistance',
    'Metabolic syndrome',
    'Underactive thyroid',
    'Overactive thyroid',
    'Adrenal fatigue',
    'Low testosterone',
    'Exercise-induced asthma',
    'Post-COVID',
    'Osteopenia',
    'Osteoporosis',
    'Scoliosis',
    'Hypermobility',
    'Celiac disease',
    "Crohn's disease",
    'Ulcerative colitis',
    'Chronic constipation',
    'SIBO',
    'Sciatica',
    'Restless legs',
    'Post-surgery',
    'Post-cancer',
    'Sarcopenia',
    'Frailty',
  ];

  final List<String> femaleMeds = [
    'High blood pressure',
    'High cholesterol',
    'Type 2 diabetes',
    'Pre-diabetes',
    'Obesity',
    'Acid reflux',
    'Irritable bowel',
    'Asthma',
    'PCOS',
    'Painful periods',
    'Chronic fatigue',
    'Burnout',
    'Post-illness',
    'Deconditioning',
    'Tension headaches',
    'Low blood pressure',
    'Anaemia',
    'Insulin resistance',
    'Metabolic syndrome',
    'Underactive thyroid',
    'Overactive thyroid',
    'Adrenal fatigue',
    'Perimenopause',
    'Menopause',
    'Endometriosis',
    'Pelvic floor weakness',
    'Diastasis recti',
    'Post-partum',
    'Pregnancy',
    'Exercise-induced asthma',
    'Post-COVID',
    'Osteopenia',
    'Osteoporosis',
    'Scoliosis',
    'Hypermobility',
    'Celiac disease',
    "Crohn's disease",
    'Ulcerative colitis',
    'Chronic constipation',
    'SIBO',
    'Sciatica',
    'Restless legs',
    'Post-surgery',
    'Post-cancer',
    'Sarcopenia',
    'Frailty',
  ];

  late List<String> allMeds;
  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    final user = context.read<DataProvider>().currentUser!;
    allMeds = user.gender == 'Male' ? maleMeds : femaleMeds;
    selected = user.selectedMeds.toSet();
  }

  List<String> get selectedList =>
      allMeds.where((m) => selected.contains(m)).toList();

  List<String> get remainingList =>
      allMeds.where((m) => !selected.contains(m)).toList();

  Future<void> _openEditSheet() async {
    final Set<String> sheetSelected = Set.from(selected);

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final ch = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setSheet) {
            final sheetSelectedList = allMeds
                .where((m) => sheetSelected.contains(m))
                .toList();
            final sheetRemainingList = allMeds
                .where((m) => !sheetSelected.contains(m))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Medical Conditions',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sheetSelectedList.isNotEmpty) ...[
                              Text(
                                'Your conditions',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetSelectedList.map((med) {
                                  return InputChip(
                                    selectedColor: ch.surface,
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.error),
                                    label: Text(med),
                                    labelStyle: TextStyle(color: ch.onSurface),
                                    selected: true,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.close, color: ch.error),
                                    onPressed: () {
                                      setSheet(() => sheetSelected.remove(med));
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                            ],

                            if (sheetRemainingList.isNotEmpty) ...[
                              Text(
                                'Other conditions',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetRemainingList.map((med) {
                                  return InputChip(
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.primary),
                                    label: Text(med),
                                    selected: false,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.add, color: ch.primary),
                                    onPressed: () {
                                      setSheet(() => sheetSelected.add(med));
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            setState(() => selected = sheetSelected);
                            try {
                              await context
                                  .read<DataProvider>()
                                  .updateProfileField(
                                    'medicals',
                                    sheetSelected.toList(),
                                  );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save: $e')),
                                );
                              }
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedList.isEmpty)
          Text(
            'None',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        else
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: selectedList
                .map(
                  (med) => Chip(
                    shape: StadiumBorder(),
                    backgroundColor: CustomColors.blueMuted(context),
                    side: BorderSide(color: CustomColors.blueOutline(context)),
                    label: Text(
                      med,
                      style: TextStyle(
                        color: CustomColors.bluePrimary(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 10),
        ActionChip(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: StadiumBorder(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          avatar: const Icon(Icons.edit, size: 16),
          label: const Text(
            'Edit',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: _openEditSheet,
        ),
      ],
    );
  }
}

class ProfileInjuryChips extends StatefulWidget {
  const ProfileInjuryChips({super.key});

  @override
  State<ProfileInjuryChips> createState() => _ProfileInjuryChipsState();
}

class _ProfileInjuryChipsState extends State<ProfileInjuryChips> {
  final List<String> injuries = [
    'Knee pain',
    'Lower back pain',
    'Shoulder pain',
    'Neck strain',
    'Hip pain',
    'Ankle sprain',
    'Plantar fasciitis',
    'Shin splints',
    'Flat feet',
    'Muscle tightness',
    'Upper back pain',
    'Wrist pain',
    "Runner's knee",
    "Jumper's knee",
    'IT band pain',
    'Knee arthritis',
    'Hip flexor strain',
    'Hip bursitis',
    'Hip impingement',
    'Piriformis pain',
    'Sacroiliac pain',
    'Rotator cuff strain',
    'Shoulder impingement',
    'Frozen shoulder',
    'Bicep tendinitis',
    'Tennis elbow',
    "Golfer's elbow",
    'Achilles tendinitis',
    'Back muscle strain',
    'Disc bulge',
    'Hamstring strain',
    'Quad strain',
    'Calf strain',
    'Groin strain',
    'Tendon pain',
    'Post-knee replacement',
    'Post-hip replacement',
    'Post-shoulder surgery',
    'Post-spinal surgery',
    'Post-fracture',
  ];

  late List<String> allInjuries;
  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    final user = context.read<DataProvider>().currentUser!;
    allInjuries = injuries;
    selected = user.selectedInjuries.toSet();
  }

  List<String> get selectedList =>
      allInjuries.where((i) => selected.contains(i)).toList();

  List<String> get remainingList =>
      allInjuries.where((i) => !selected.contains(i)).toList();

  Future<void> _openEditSheet() async {
    final Set<String> sheetSelected = Set.from(selected);

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final ch = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setSheet) {
            final sheetSelectedList = allInjuries
                .where((i) => sheetSelected.contains(i))
                .toList();
            final sheetRemainingList = allInjuries
                .where((i) => !sheetSelected.contains(i))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Injuries',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sheetSelectedList.isNotEmpty) ...[
                              Text(
                                'Your injuries',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetSelectedList.map((ins) {
                                  return InputChip(
                                    selectedColor: ch.surface,
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.error),
                                    label: Text(ins),
                                    labelStyle: TextStyle(color: ch.onSurface),
                                    selected: true,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.close, color: ch.error),
                                    onPressed: () {
                                      setSheet(() => sheetSelected.remove(ins));
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                            ],

                            if (sheetRemainingList.isNotEmpty) ...[
                              Text(
                                'Other injuries',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetRemainingList.map((ins) {
                                  return InputChip(
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.primary),
                                    label: Text(ins),
                                    selected: false,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.add, color: ch.primary),
                                    onPressed: () {
                                      setSheet(() => sheetSelected.add(ins));
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            setState(() => selected = sheetSelected);
                            try {
                              await context
                                  .read<DataProvider>()
                                  .updateProfileField(
                                    'injuries',
                                    sheetSelected.toList(),
                                  );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save: $e')),
                                );
                              }
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedList.isEmpty)
          Text(
            'None',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        else
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: selectedList
                .map(
                  (ins) => Chip(
                    shape: StadiumBorder(),
                    backgroundColor: CustomColors.redMuted(context),
                    side: BorderSide(color: CustomColors.redOutline(context)),
                    label: Text(
                      ins,
                      style: TextStyle(
                        color: CustomColors.redPrimary(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 10),
        ActionChip(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: StadiumBorder(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          avatar: const Icon(Icons.edit, size: 16),
          label: const Text(
            'Edit',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: _openEditSheet,
        ),
      ],
    );
  }
}

class ProfileAllergyChips extends StatefulWidget {
  const ProfileAllergyChips({super.key});

  @override
  State<ProfileAllergyChips> createState() => _ProfileAllergyChipsState();
}

class _ProfileAllergyChipsState extends State<ProfileAllergyChips> {
  final List<String> allergens = [
    "Peanuts",
    "Tree nuts",
    "Almonds",
    "Cashews",
    "Walnuts",
    "Dairy",
    "Eggs",
    "Wheat",
    "Gluten",
    "Soy",
    "Fish",
    "Shellfish",
    "Sesame",
    "Mustard",
    "Sulfites",
    "Corn",
    "Celery",
    "Lupin",
    "Molluscs",
    "Coconut",
    "Sunflower seeds",
    "Poppy seeds",
  ];

  final List<Image> allergenIcons = [
    Emoji.al1,
    Emoji.al2,
    Emoji.al3,
    Emoji.al4,
    Emoji.al5,
    Emoji.al6,
    Emoji.al7,
    Emoji.al8,
    Emoji.al9,
    Emoji.al10,
    Emoji.al11,
    Emoji.al12,
    Emoji.al13,
    Emoji.al14,
    Emoji.al15,
    Emoji.al16,
    Emoji.al17,
    Emoji.al18,
    Emoji.al19,
    Emoji.al20,
    Emoji.al21,
    Emoji.al22,
  ];

  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    final user = context.read<DataProvider>().currentUser!;
    selected = user.selectedAllergens.toSet();
  }

  List<String> get selectedList =>
      allergens.where((a) => selected.contains(a)).toList();

  List<String> get remainingList =>
      allergens.where((a) => !selected.contains(a)).toList();

  Future<void> _openEditSheet() async {
    final Set<String> sheetSelected = Set.from(selected);

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final ch = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setSheet) {
            final sheetSelectedList = allergens
                .where((a) => sheetSelected.contains(a))
                .toList();
            final sheetRemainingList = allergens
                .where((a) => !sheetSelected.contains(a))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Allergies',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sheetSelectedList.isNotEmpty) ...[
                              Text(
                                'Your allergies',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetSelectedList.map((als) {
                                  final icon =
                                      allergenIcons[allergens.indexOf(als)];
                                  return InputChip(
                                    selectedColor: ch.surface,
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.error),
                                    label: Text(als),
                                    labelStyle: TextStyle(color: ch.onSurface),
                                    selected: true,
                                    showCheckmark: false,
                                    avatar: icon,
                                    deleteButtonTooltipMessage: '',
                                    deleteIcon: Icon(
                                      Icons.close,
                                      color: ch.error,
                                      size: 18,
                                    ),
                                    onDeleted: () {
                                      setSheet(() => sheetSelected.remove(als));
                                    },
                                    onPressed: () {
                                      setSheet(() => sheetSelected.remove(als));
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                            ],

                            if (sheetRemainingList.isNotEmpty) ...[
                              Text(
                                'Other allergies',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetRemainingList.map((als) {
                                  final icon =
                                      allergenIcons[allergens.indexOf(als)];
                                  return InputChip(
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.primary),
                                    label: Text(als),
                                    selected: false,
                                    showCheckmark: false,
                                    avatar: icon,
                                    deleteButtonTooltipMessage: '',
                                    deleteIcon: Icon(
                                      Icons.add,
                                      color: ch.primary,
                                      size: 18,
                                    ),
                                    onDeleted: () {
                                      setSheet(() => sheetSelected.add(als));
                                    },
                                    onPressed: () {
                                      setSheet(() => sheetSelected.add(als));
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            setState(() => selected = sheetSelected);
                            try {
                              await context
                                  .read<DataProvider>()
                                  .updateProfileField(
                                    'allergens',
                                    sheetSelected.toList(),
                                  );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save: $e')),
                                );
                              }
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedList.isEmpty)
          Text(
            'None',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        else
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: selectedList.map((ins) {
              final icon = allergenIcons[allergens.indexOf(ins)];
              return Chip(
                shape: StadiumBorder(),
                backgroundColor: CustomColors.orangeMuted(context),
                avatar: icon,
                side: BorderSide(color: CustomColors.orangeOutline(context)),
                label: Text(
                  ins,
                  style: TextStyle(
                    color: CustomColors.orangePrimary(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 10),
        ActionChip(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: StadiumBorder(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          avatar: const Icon(Icons.edit, size: 16),
          label: const Text(
            'Edit',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: _openEditSheet,
        ),
      ],
    );
  }
}

class ProfileIntoleranceChips extends StatefulWidget {
  const ProfileIntoleranceChips({super.key});

  @override
  State<ProfileIntoleranceChips> createState() =>
      _ProfileIntoleranceChipsState();
}

class _ProfileIntoleranceChipsState extends State<ProfileIntoleranceChips> {
  final List<String> omnivoreIntolerances = [
    "Lactose",
    "Gluten",
    "Fructose",
    "FODMAP",
    "Histamine",
    "Salicylates",
    "Nightshades",
    "Caffeine",
    "Legumes",
    "Coconut",
    "Spicy food",
    "Raw garlic / onion",
    "Cruciferous vegetables",
    "Carbonated drinks",
    "Artificial sweeteners",
  ];

  final List<String> vegetarianIntolerances = [
    "Lactose",
    "Gluten",
    "Fructose",
    "FODMAP",
    "Histamine",
    "Salicylates",
    "Nightshades",
    "Caffeine",
    "Legumes",
    "Coconut",
    "Spicy food",
    "Raw garlic / onion",
    "Cruciferous vegetables",
    "Carbonated drinks",
    "Artificial sweeteners",
  ];

  final List<String> veganIntolerances = [
    "Gluten",
    "Fructose",
    "FODMAP",
    "Histamine",
    "Salicylates",
    "Nightshades",
    "Caffeine",
    "Legumes",
    "Coconut",
    "Spicy food",
    "Raw garlic / onion",
    "Cruciferous vegetables",
    "Carbonated drinks",
    "Artificial sweeteners",
  ];

  final List<String> pescatarianIntolerances = [
    "Lactose",
    "Gluten",
    "Fructose",
    "FODMAP",
    "Histamine",
    "Salicylates",
    "Nightshades",
    "Caffeine",
    "Legumes",
    "Coconut",
    "Spicy food",
    "Raw garlic / onion",
    "Cruciferous vegetables",
    "Carbonated drinks",
    "Artificial sweeteners",
  ];

  final List<String> paleoIntolerances = [
    "Fructose",
    "Histamine",
    "Salicylates",
    "Nightshades",
    "Caffeine",
    "Coconut",
    "Spicy food",
    "Raw garlic / onion",
    "Cruciferous vegetables",
    "Carbonated drinks",
    "Artificial sweeteners",
  ];

  final List<String> ketoIntolerances = [
    "Lactose",
    "Histamine",
    "Salicylates",
    "Nightshades",
    "Caffeine",
    "Coconut",
    "Spicy food",
    "Raw garlic / onion",
    "Cruciferous vegetables",
    "Carbonated drinks",
    "Artificial sweeteners",
  ];

  late List<String> allIntolerances;
  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    final user = context.read<DataProvider>().currentUser!;
    allIntolerances = _intolerancesFor(user.dietType);
    selected = user.selectedIntolerances
        .where((i) => allIntolerances.contains(i))
        .toSet();
  }

  List<String> _intolerancesFor(String diet) => switch (diet) {
    'Vegetarian' => vegetarianIntolerances,
    'Vegan' => veganIntolerances,
    'Pescatarian' => pescatarianIntolerances,
    'Paleo' => paleoIntolerances,
    'Keto' => ketoIntolerances,
    _ => omnivoreIntolerances,
  };

  List<String> get selectedList =>
      allIntolerances.where((i) => selected.contains(i)).toList();

  List<String> get remainingList =>
      allIntolerances.where((i) => !selected.contains(i)).toList();

  Future<void> _openEditSheet() async {
    final Set<String> sheetSelected = Set.from(selected);

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final ch = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setSheet) {
            final sheetSelectedList = allIntolerances
                .where((i) => sheetSelected.contains(i))
                .toList();
            final sheetRemainingList = allIntolerances
                .where((i) => !sheetSelected.contains(i))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Intolerances',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sheetSelectedList.isNotEmpty) ...[
                              Text(
                                'Your intolerances',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetSelectedList.map((ins) {
                                  return InputChip(
                                    selectedColor: ch.surface,
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.error),
                                    label: Text(ins),
                                    labelStyle: TextStyle(color: ch.onSurface),
                                    selected: true,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.close, color: ch.error),
                                    onPressed: () {
                                      setSheet(() => sheetSelected.remove(ins));
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                            ],

                            if (sheetRemainingList.isNotEmpty) ...[
                              Text(
                                'Other intolerances',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetRemainingList.map((ins) {
                                  return InputChip(
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.primary),
                                    label: Text(ins),
                                    selected: false,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.add, color: ch.primary),
                                    onPressed: () {
                                      setSheet(() => sheetSelected.add(ins));
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            setState(() => selected = sheetSelected);
                            try {
                              await context
                                  .read<DataProvider>()
                                  .updateProfileField(
                                    'intolerances',
                                    sheetSelected.toList(),
                                  );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save: $e')),
                                );
                              }
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<DataProvider>().currentUser!;
    if (_intolerancesFor(user.dietType) != allIntolerances) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          allIntolerances = _intolerancesFor(user.dietType);
          selected = user.selectedIntolerances
              .where((i) => allIntolerances.contains(i))
              .toSet();
        });
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedList.isEmpty)
          Text(
            'None',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        else
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: selectedList
                .map(
                  (ins) => Chip(
                    shape: StadiumBorder(),
                    backgroundColor: CustomColors.yellowMuted(context),
                    side: BorderSide(
                      color: CustomColors.yellowOutline(context),
                    ),
                    label: Text(
                      ins,
                      style: TextStyle(
                        color: CustomColors.yellowPrimary(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 10),
        ActionChip(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: StadiumBorder(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          avatar: const Icon(Icons.edit, size: 16),
          label: const Text(
            'Edit',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: _openEditSheet,
        ),
      ],
    );
  }
}

class ProfileDislikeChips extends StatefulWidget {
  const ProfileDislikeChips({super.key});

  @override
  State<ProfileDislikeChips> createState() => _ProfileDislikeChipsState();
}

class _ProfileDislikeChipsState extends State<ProfileDislikeChips> {
  final List<String> omnivoreDislikes = [
    "Meat",
    "Lamb",
    "Pork",
    "Organ meats",
    "Game meats",
    "Slimy texture",
    "Chewy texture",
    "Seedy / grainy texture",
    "Seafood",
    "All fish",
    "All shellfish",
    "Oily fish",
    "Squid / octopus",
    "Eggs",
    "Milk",
    "Yogurt",
    "Cheese",
    "Cottage cheese",
    "Tofu / tempeh",
    "Lentils / beans",
    "Nutritional yeast",
    "Seitan",
    "Bitter greens",
    "Broccoli / cauliflower",
    "Mushrooms",
    "Eggplant",
    "Okra",
    "Beetroot",
    "Raw onion",
    "Celery / fennel",
    "Oats",
    "Quinoa",
    "Brown rice",
    "Rye / barley / millet",
    "Banana",
    "Dried fruits",
    "Coconut",
    "Durian",
    "Papaya / jackfruit",
    "Avocado",
    "Olives",
    "Peanut butter",
    "Nut butters",
    "Chia / flax / sesame",
    "Cilantro",
    "Spicy food",
    "Strong ginger",
    "Fermented foods",
    "Fish sauce",
    "Soy sauce",
    "Coffee",
    "Green tea / matcha",
    "Beet juice",
    "Kombucha",
    "Plant milks",
  ];
  final List<String> vegetarianDislikes = [
    "Eggs",
    "Milk",
    "Yogurt",
    "Cheese",
    "Cottage cheese",
    "Slimy texture",
    "Chewy texture",
    "Seedy / grainy texture",
    "Paneer",
    "Tofu / tempeh",
    "Lentils / beans",
    "Nutritional yeast",
    "Seitan",
    "Bitter greens",
    "Broccoli / cauliflower",
    "Mushrooms",
    "Eggplant",
    "Okra",
    "Beetroot",
    "Raw onion",
    "Celery / fennel",
    "Oats",
    "Quinoa",
    "Brown rice",
    "Rye / barley / millet",
    "Banana",
    "Dried fruits",
    "Coconut",
    "Durian",
    "Papaya / jackfruit",
    "Avocado",
    "Olives",
    "Peanut butter",
    "Nut butters",
    "Chia / flax / sesame",
    "Cilantro",
    "Spicy food",
    "Strong ginger",
    "Fermented foods",
    "Soy sauce",
    "Coffee",
    "Green tea / matcha",
    "Beet juice",
    "Kombucha",
    "Plant milks",
  ];
  final List<String> veganDislikes = [
    "Tofu / tempeh",
    "Lentils / beans",
    "Nutritional yeast",
    "Seitan",
    "Spirulina / chlorella",
    "Slimy texture",
    "Chewy texture",
    "Seedy / grainy texture",
    "Bitter greens",
    "Broccoli / cauliflower",
    "Mushrooms",
    "Eggplant",
    "Okra",
    "Beetroot",
    "Raw onion",
    "Celery / fennel",
    "Oats",
    "Quinoa",
    "Brown rice",
    "Rye / barley / millet",
    "Banana",
    "Dried fruits",
    "Coconut",
    "Durian",
    "Papaya / jackfruit",
    "Avocado",
    "Olives",
    "Peanut butter",
    "Nut butters",
    "Chia / flax / sesame",
    "Cilantro",
    "Spicy food",
    "Strong ginger",
    "Fermented foods",
    "Soy sauce",
    "Coffee",
    "Green tea / matcha",
    "Beet juice",
    "Kombucha",
    "Plant milks",
  ];
  final List<String> pescatarianDislikes = [
    "All fish",
    "All shellfish",
    "Oily fish",
    "Squid / octopus",
    "Eggs",
    "Slimy texture",
    "Chewy texture",
    "Seedy / grainy texture",
    "Milk",
    "Yogurt",
    "Cheese",
    "Cottage cheese",
    "Tofu / tempeh",
    "Lentils / beans",
    "Nutritional yeast",
    "Seitan",
    "Bitter greens",
    "Broccoli / cauliflower",
    "Mushrooms",
    "Eggplant",
    "Okra",
    "Beetroot",
    "Raw onion",
    "Celery / fennel",
    "Oats",
    "Quinoa",
    "Brown rice",
    "Rye / barley / millet",
    "Banana",
    "Dried fruits",
    "Coconut",
    "Durian",
    "Papaya / jackfruit",
    "Avocado",
    "Olives",
    "Peanut butter",
    "Nut butters",
    "Chia / flax / sesame",
    "Cilantro",
    "Spicy food",
    "Strong ginger",
    "Fermented foods",
    "Fish sauce",
    "Soy sauce",
    "Coffee",
    "Green tea / matcha",
    "Beet juice",
    "Kombucha",
    "Plant milks",
  ];
  final List<String> paleoDislikes = [
    "Lamb",
    "Pork",
    "Organ meats",
    "Game meats",
    "All fish",
    "Slimy texture",
    "Chewy texture",
    "Seedy / grainy texture",
    "All shellfish",
    "Oily fish",
    "Squid / octopus",
    "Eggs",
    "Bitter greens",
    "Broccoli / cauliflower",
    "Mushrooms",
    "Eggplant",
    "Okra",
    "Beetroot",
    "Raw onion",
    "Celery / fennel",
    "Banana",
    "Dried fruits",
    "Coconut",
    "Durian",
    "Papaya / jackfruit",
    "Avocado",
    "Olives",
    "Peanut butter",
    "Nut butters",
    "Chia / flax / sesame",
    "Coconut oil",
    "Cilantro",
    "Spicy food",
    "Strong ginger",
    "Fermented foods",
    "Fish sauce",
    "Coffee",
    "Green tea / matcha",
    "Beet juice",
    "Kombucha",
  ];
  final List<String> ketoDislikes = [
    "Lamb",
    "Pork",
    "Organ meats",
    "Game meats",
    "All fish",
    "Slimy texture",
    "Chewy texture",
    "Seedy / grainy texture",
    "All shellfish",
    "Oily fish",
    "Squid / octopus",
    "Eggs",
    "Milk",
    "Yogurt",
    "Cheese",
    "Cottage cheese",
    "Cream",
    "Tofu / tempeh",
    "Nutritional yeast",
    "Seitan",
    "Bitter greens",
    "Broccoli / cauliflower",
    "Mushrooms",
    "Eggplant",
    "Okra",
    "Raw onion",
    "Celery / fennel",
    "Berries",
    "Coconut",
    "Avocado",
    "Olives",
    "Peanut butter",
    "Nut butters",
    "Chia / flax / sesame",
    "Coconut oil",
    "Cilantro",
    "Spicy food",
    "Strong ginger",
    "Fermented foods",
    "Fish sauce",
    "Soy sauce",
    "Coffee",
    "Green tea / matcha",
    "Kombucha",
    "Bone broth",
  ];

  late List<String> allDislikes;
  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    final user = context.read<DataProvider>().currentUser!;
    allDislikes = _dislikesFor(user.dietType);
    selected = user.selectedDislikes
        .where((i) => allDislikes.contains(i))
        .toSet();
  }

  List<String> _dislikesFor(String diet) => switch (diet) {
    'Vegetarian' => vegetarianDislikes,
    'Vegan' => veganDislikes,
    'Pescatarian' => pescatarianDislikes,
    'Paleo' => paleoDislikes,
    'Keto' => ketoDislikes,
    _ => omnivoreDislikes,
  };

  List<String> get selectedList =>
      allDislikes.where((d) => selected.contains(d)).toList();

  List<String> get remainingList =>
      allDislikes.where((d) => !selected.contains(d)).toList();

  Future<void> _openEditSheet() async {
    final Set<String> sheetSelected = Set.from(selected);

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final ch = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setSheet) {
            final sheetSelectedList = allDislikes
                .where((d) => sheetSelected.contains(d))
                .toList();
            final sheetRemainingList = allDislikes
                .where((d) => !sheetSelected.contains(d))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Dislikes',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sheetSelectedList.isNotEmpty) ...[
                              Text(
                                'Your dislikes',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetSelectedList.map((item) {
                                  return InputChip(
                                    selectedColor: ch.surface,
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.error),
                                    label: Text(item),
                                    labelStyle: TextStyle(color: ch.onSurface),
                                    selected: true,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.close, color: ch.error),
                                    onPressed: () {
                                      setSheet(
                                        () => sheetSelected.remove(item),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                            ],

                            if (sheetRemainingList.isNotEmpty) ...[
                              Text(
                                'Other dislikes',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: sheetRemainingList.map((item) {
                                  return InputChip(
                                    shape: StadiumBorder(),
                                    side: BorderSide(color: ch.primary),
                                    label: Text(item),
                                    selected: false,
                                    showCheckmark: false,
                                    avatar: Icon(Icons.add, color: ch.primary),
                                    onPressed: () {
                                      setSheet(() => sheetSelected.add(item));
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            setState(() => selected = sheetSelected);
                            try {
                              await context
                                  .read<DataProvider>()
                                  .updateProfileField(
                                    'dislikes',
                                    sheetSelected.toList(),
                                  );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save: $e')),
                                );
                              }
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<DataProvider>().currentUser!;
    if (_dislikesFor(user.dietType) != allDislikes) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          allDislikes = _dislikesFor(user.dietType);
          selected = user.selectedIntolerances
              .where((d) => allDislikes.contains(d))
              .toSet();
        });
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedList.isEmpty)
          Text(
            'None',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        else
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: selectedList
                .map(
                  (ins) => Chip(
                    shape: StadiumBorder(),
                    backgroundColor: CustomColors.purpleMuted(context),
                    side: BorderSide(
                      color: CustomColors.purpleOutline(context),
                    ),
                    label: Text(
                      ins,
                      style: TextStyle(
                        color: CustomColors.purplePrimary(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 10),
        ActionChip(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: StadiumBorder(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          avatar: const Icon(Icons.edit, size: 16),
          label: const Text(
            'Edit',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: _openEditSheet,
        ),
      ],
    );
  }
}

class EditSheets {
  static void Function(BuildContext) statEdit = (BuildContext context) {
    final user = context.read<DataProvider>().currentUser!;
    bool isHeightFt = user.wantMetricUnit ? false : true;
    bool isWeightKg = user.wantMetricUnit ? true : false;
    final totalInches = user.heightCm / 2.54;
    int initFeet = (totalInches / 12).floor().clamp(3, 8);
    int initInches = (totalInches % 12).round().clamp(0, 11);

    int selectedFeet = initFeet;
    int selectedInches = initInches;
    final heightController = TextEditingController(
      text: user.heightCm.toStringAsFixed(1),
    );
    final weightController = TextEditingController(
      text: user.weightKg.toStringAsFixed(1),
    );

    String? heightError;
    String? weightError;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final ch = Theme.of(ctx).colorScheme;
        final th = Theme.of(ctx).textTheme;
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Body Stats',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Height', style: th.labelLarge),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isHeightFt) ...[
                                  Expanded(
                                    child: SizedBox(
                                      height: 56,
                                      child: DropdownButtonFormField<int>(
                                        initialValue: selectedFeet,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: CustomColors.greyLight(
                                            context,
                                          ),
                                          labelText: 'Feet',
                                          prefixIcon: Icon(
                                            Icons.height_rounded,
                                          ),
                                          errorText: heightError,
                                        ),
                                        items: List.generate(6, (i) => i + 3)
                                            .map(
                                              (f) => DropdownMenuItem(
                                                value: f,
                                                child: Text(
                                                  '$f ft',
                                                  style: th.bodyLarge,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) {
                                          setSheet(() {
                                            selectedFeet = v!;
                                            heightError = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 56,
                                      child: DropdownButtonFormField<int>(
                                        initialValue: selectedInches,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: CustomColors.greyLight(
                                            context,
                                          ),
                                          labelText: 'Inches',
                                        ),
                                        items: List.generate(12, (i) => i)
                                            .map(
                                              (i) => DropdownMenuItem(
                                                value: i,
                                                child: Text(
                                                  '$i in',
                                                  style: th.bodyLarge,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) {
                                          setSheet(() => selectedInches = v!);
                                        },
                                      ),
                                    ),
                                  ),
                                ] else
                                  Expanded(
                                    child: TextField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d{0,2}'),
                                        ),
                                      ],
                                      controller: heightController,
                                      onChanged: (_) {
                                        if (heightError != null) {
                                          setSheet(() {
                                            heightError = null;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: CustomColors.greyLight(
                                          context,
                                        ),
                                        labelText: 'Height',
                                        prefixIcon: Icon(Icons.height_rounded),
                                        errorText: heightError,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setSheet(() {
                                      isHeightFt = true;
                                      heightError = null;
                                    });
                                  },
                                  child: Container(
                                    height: 56,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: isHeightFt
                                          ? ch.primary
                                          : ch.surface,
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(10),
                                      ),
                                      border: Border(
                                        top: BorderSide(color: ch.primary),
                                        bottom: BorderSide(color: ch.primary),
                                        left: BorderSide(color: ch.primary),
                                        right: BorderSide.none,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ft',
                                        style: TextStyle(
                                          color: !isHeightFt
                                              ? ch.onSurface
                                              : ch.onPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setSheet(() {
                                      isHeightFt = false;
                                      heightError = null;
                                    });
                                  },
                                  child: Container(
                                    height: 56,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: !isHeightFt
                                          ? ch.primary
                                          : ch.surface,
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(10),
                                      ),
                                      border: Border(
                                        top: BorderSide(color: ch.primary),
                                        bottom: BorderSide(color: ch.primary),
                                        right: BorderSide(color: ch.primary),
                                        left: BorderSide.none,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'cm',
                                        style: TextStyle(
                                          color: isHeightFt
                                              ? ch.onSurface
                                              : ch.onPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('Weight', style: th.labelLarge),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    controller: weightController,
                                    onChanged: (_) {
                                      if (weightError != null) {
                                        setSheet(() {
                                          weightError = null;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: CustomColors.greyLight(
                                        context,
                                      ),
                                      labelText: 'Weight',
                                      prefixIcon: Icon(Symbols.weight_rounded),
                                      errorText: weightError,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setSheet(() {
                                      isWeightKg = true;
                                      weightError = null;
                                    });
                                  },
                                  child: Container(
                                    height: 56,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: isWeightKg
                                          ? ch.primary
                                          : ch.surface,
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(10),
                                      ),
                                      border: Border(
                                        top: BorderSide(color: ch.primary),
                                        bottom: BorderSide(color: ch.primary),
                                        left: BorderSide(color: ch.primary),
                                        right: BorderSide.none,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'kg',
                                        style: TextStyle(
                                          color: !isWeightKg
                                              ? ch.onSurface
                                              : ch.onPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setSheet(() {
                                      isWeightKg = false;
                                      weightError = null;
                                    });
                                  },
                                  child: Container(
                                    height: 56,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: !isWeightKg
                                          ? ch.primary
                                          : ch.surface,
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(10),
                                      ),
                                      border: Border(
                                        top: BorderSide(color: ch.primary),
                                        bottom: BorderSide(color: ch.primary),
                                        right: BorderSide(color: ch.primary),
                                        left: BorderSide.none,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'lb',
                                        style: TextStyle(
                                          color: isWeightKg
                                              ? ch.onSurface
                                              : ch.onPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  bool isValid = true;
                                  if (!isHeightFt) {
                                    final h = double.tryParse(
                                      heightController.text,
                                    );
                                    if (heightController.text.isEmpty) {
                                      setSheet(
                                        () =>
                                            heightError = 'Height is required',
                                      );
                                      isValid = false;
                                    } else if (h == null ||
                                        h < 100 ||
                                        h > 250) {
                                      setSheet(
                                        () => heightError =
                                            'Please enter valid height',
                                      );
                                      isValid = false;
                                    }
                                  }

                                  final w = double.tryParse(
                                    weightController.text,
                                  );
                                  if (weightController.text.isEmpty) {
                                    setSheet(
                                      () => weightError = 'Weight is required',
                                    );
                                    isValid = false;
                                  } else if (isWeightKg &&
                                      (w == null || w < 30 || w > 300)) {
                                    setSheet(
                                      () => weightError =
                                          'Please enter valid weight',
                                    );
                                    isValid = false;
                                  } else if (!isWeightKg &&
                                      (w == null || w < 66 || w > 660)) {
                                    setSheet(
                                      () => weightError =
                                          'Please enter valid weight',
                                    );
                                    isValid = false;
                                  }

                                  if (!isValid) return;
                                  final double heightCm = isHeightFt
                                      ? (selectedFeet * 30.48) +
                                            (selectedInches * 2.54)
                                      : double.parse(heightController.text);
                                  final double weightKg = isWeightKg
                                      ? double.parse(weightController.text)
                                      : double.parse(weightController.text) *
                                            0.453592;

                                  setSheet(() => isSaving = true);
                                  try {
                                    await context
                                        .read<DataProvider>()
                                        .updateBodyStats(
                                          heightCm: heightCm,
                                          weightKg: weightKg,
                                        );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to save: $e'),
                                        ),
                                      );
                                    }
                                  } finally {
                                    setSheet(() => isSaving = false);
                                  }
                                  if (context.mounted) Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: isSaving
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  };

  static void Function(BuildContext) fitEdit = (BuildContext context) {
    final user = context.read<DataProvider>().currentUser!;

    String selectedWork = user.workType;
    String selectedActive = user.activityLevel;
    String selectedFit = user.fitType;
    Set<String> selectedStyle = user.styleType.toSet();
    String selectedEquip = user.equipType;
    int selectedFundIndex = [
      'Energy & Fuel',
      'Strength & build',
      'Mobility & ease',
      'Stability & control',
      'Composition & vitals',
      'Function & posture',
      'Growth & adaptation',
    ].indexOf(user.fundType).clamp(0, 6);
    final Map<int, String> goalPerFund = {selectedFundIndex: user.goalType};

    const workOptions = ['Sedentary', 'Moderately Active', 'Physically Active'];
    const activeOptions = ['Low', 'Moderate', 'High'];
    const fitOptions = ['Beginner', 'Intermediate', 'Advanced'];
    const styleOptions = [
      'Strength Training',
      'Cardio',
      'HIIT',
      'Yoga & Stretching',
      'Pilates',
      'Calisthenics',
      'Sports & Athletics',
      'Functional Training',
      'Low Impact',
      'Mixed',
    ];
    const equipOptions = ['None', 'Minimal', 'Full Gym'];
    const fundLabels = [
      'Energy & Fuel',
      'Strength & build',
      'Mobility & ease',
      'Stability & control',
      'Composition & vitals',
      'Function & posture',
      'Growth & adaptation',
    ];

    final workIcons = [Emoji.o1, Emoji.o2, Emoji.o3];
    final activeIcons = [Emoji.a1, Emoji.a2, Emoji.a3];
    final fitIcons = [Emoji.f1, Emoji.f2, Emoji.f3];
    final equipIcons = [Emoji.e1, Emoji.e2, Emoji.e3];
    final styleIcons = [
      Emoji.style1,
      Emoji.style2,
      Emoji.style3,
      Emoji.style4,
      Emoji.style5,
      Emoji.style6,
      Emoji.style7,
      Emoji.style8,
      Emoji.style9,
      Emoji.style10,
    ];
    final fundIcons = [
      Emoji.fund1,
      Emoji.fund2,
      Emoji.fund3,
      Emoji.fund4,
      Emoji.fund5,
      Emoji.fund6,
      Emoji.fund7,
    ];

    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final ch = Theme.of(ctx).colorScheme;
        final th = Theme.of(ctx).textTheme;

        return StatefulBuilder(
          builder: (context, setSheet) {
            const timedFunds = [0, 1, 4, 6];
            final String planType = timedFunds.contains(selectedFundIndex)
                ? 'Timed'
                : 'Ongoing';
            final List<String> currentGoals =
                goalPreviews[user.ageGroup]?[selectedFundIndex] ?? [];
            final String selectedGoal =
                goalPerFund[selectedFundIndex] ??
                (currentGoals.isNotEmpty ? currentGoals[0] : '');

            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Fitness Profile',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Work / Occupation Type',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: workOptions.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final opt = entry.value;
                                final isSelected = selectedWork == opt;
                                return ChoiceChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  showCheckmark: false,
                                  avatar: workIcons[index],
                                  selected: isSelected,
                                  onSelected: (_) =>
                                      setSheet(() => selectedWork = opt),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Daily Activity Level',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: activeOptions.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final opt = entry.value;
                                final isSelected = selectedActive == opt;
                                return ChoiceChip(
                                  label: Text(opt),
                                  selected: isSelected,
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  showCheckmark: false,
                                  avatar: activeIcons[index],
                                  onSelected: (_) =>
                                      setSheet(() => selectedActive = opt),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Fitness Level',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: fitOptions.asMap().entries.map((entry) {
                                final index = entry.key;
                                final opt = entry.value;
                                final isSelected = selectedFit == opt;
                                return ChoiceChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  avatar: fitIcons[index],
                                  showCheckmark: false,
                                  onSelected: (_) =>
                                      setSheet(() => selectedFit = opt),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Training Style',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: styleOptions.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final opt = entry.value;
                                final isSelected = selectedStyle.contains(opt);
                                return FilterChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  avatar: styleIcons[index],
                                  showCheckmark: false,
                                  onSelected: (selected) {
                                    setSheet(() {
                                      const mixedLabel = 'Mixed';
                                      if (opt == mixedLabel) {
                                        if (selected) {
                                          selectedStyle.clear();
                                          selectedStyle.add(mixedLabel);
                                        } else {
                                          selectedStyle.remove(mixedLabel);
                                        }
                                      } else {
                                        if (selected) {
                                          selectedStyle.add(opt);
                                          selectedStyle.remove(mixedLabel);
                                        } else {
                                          selectedStyle.remove(opt);
                                        }
                                        final allSelected = styleOptions
                                            .where((s) => s != mixedLabel)
                                            .every(
                                              (s) => selectedStyle.contains(s),
                                            );
                                        if (allSelected) {
                                          selectedStyle.clear();
                                          selectedStyle.add(mixedLabel);
                                        }
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Equipment Access',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: equipOptions.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final opt = entry.value;
                                final isSelected = selectedEquip == opt;
                                return ChoiceChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  avatar: CircleAvatar(
                                    backgroundColor: CustomColors.greyLight(
                                      context,
                                    ),
                                    child: equipIcons[index],
                                  ),
                                  showCheckmark: false,
                                  onSelected: (_) =>
                                      setSheet(() => selectedEquip = opt),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Focus Area',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: fundLabels.asMap().entries.map((entry) {
                                final index = entry.key;
                                final label = entry.value;
                                final isSelected = selectedFundIndex == index;
                                return ChoiceChip(
                                  label: Text(label),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  avatar: CircleAvatar(
                                    backgroundColor: CustomColors.greyLight(
                                      context,
                                    ),
                                    child: fundIcons[index],
                                  ),
                                  showCheckmark: false,
                                  onSelected: (_) => setSheet(() {
                                    selectedFundIndex = index;
                                    if (!goalPerFund.containsKey(index)) {
                                      final newGoals =
                                          goalPreviews[user.ageGroup]?[index] ??
                                          [];
                                      goalPerFund[index] = newGoals.isNotEmpty
                                          ? newGoals[0]
                                          : '';
                                    }
                                  }),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Goals',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: currentGoals.map((goal) {
                                final isSelected = selectedGoal == goal;
                                return ChoiceChip(
                                  label: Text(goal),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  avatar: Emoji.goal,
                                  showCheckmark: false,
                                  onSelected: (_) => setSheet(
                                    () => goalPerFund[selectedFundIndex] = goal,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Text('Plan Type: ', style: th.labelLarge),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: planType == 'Timed'
                                        ? CustomColors.blueMuted(context)
                                        : CustomColors.greenMuted(context),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: planType == 'Timed'
                                          ? CustomColors.blueOutline(context)
                                          : CustomColors.greenOutline(context),
                                    ),
                                  ),
                                  child: Text(
                                    planType,
                                    style: TextStyle(
                                      color: planType == 'Timed'
                                          ? CustomColors.bluePrimary(context)
                                          : CustomColors.greenPrimary(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  setSheet(() => isSaving = true);
                                  try {
                                    final String finalGoal =
                                        goalPerFund[selectedFundIndex] ??
                                        (currentGoals.isNotEmpty
                                            ? currentGoals[0]
                                            : '');
                                    await context
                                        .read<DataProvider>()
                                        .updateFitnessProfile(
                                          fitType: selectedFit,
                                          workType: selectedWork,
                                          activityLevel: selectedActive,
                                          styleType: selectedStyle.toList(),
                                          equipType: selectedEquip,
                                          fundType:
                                              fundLabels[selectedFundIndex],
                                          goalType: finalGoal,
                                          planType: planType,
                                        );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to save: $e'),
                                        ),
                                      );
                                    }
                                  } finally {
                                    setSheet(() => isSaving = false);
                                  }
                                  if (context.mounted) Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: isSaving
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  };

  static void Function(BuildContext) dietEdit = (BuildContext context) {
    final user = context.read<DataProvider>().currentUser!;
    String sheetDiet = user.dietType;
    String sheetMeals = user.mealType;
    Set<String> sheetRegions = user.regionType.toSet();

    final List<String> allMeals = ['2', '3', '4', '5+'];
    final List<Map<String, dynamic>> allDiets = [
      {'label': 'Omnivore', 'avatar': Emoji.omni},
      {'label': 'Vegetarian', 'avatar': Emoji.veg},
      {'label': 'Vegan', 'avatar': Emoji.vegan},
      {'label': 'Pescatarian', 'avatar': Emoji.fish},
      {'label': 'Paleo', 'avatar': Emoji.paleo},
      {'label': 'Keto', 'avatar': Emoji.keto},
    ];
    final List<Map<String, dynamic>> allRegions = [
      {'label': 'South Asian', 'icon': Symbols.temple_hindu_rounded},
      {'label': 'East Asian', 'icon': Symbols.temple_buddhist_rounded},
      {'label': 'Southeast Asian', 'icon': Symbols.forest_rounded},
      {'label': 'Middle Eastern', 'icon': Symbols.mosque_rounded},
      {'label': 'Mediterranean', 'icon': Symbols.waves_rounded},
      {'label': 'East African', 'icon': Symbols.landscape_2_rounded},
      {'label': 'North African', 'icon': Symbols.sunny_rounded},
      {'label': 'Western', 'icon': Symbols.account_balance_rounded},
      {'label': 'No preference', 'icon': Symbols.all_inclusive_rounded},
    ];

    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final ch = Theme.of(ctx).colorScheme;
        return StatefulBuilder(
          builder: (context, setSheet) {
            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Diet Preferences',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diet Preference',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: allDiets.map((diet) {
                                final isSelected = sheetDiet.contains(
                                  diet['label'],
                                );
                                return ChoiceChip(
                                  label: Text(diet['label']),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  showCheckmark: false,
                                  selected: sheetDiet == diet['label'],
                                  avatar: diet['avatar'],
                                  onSelected: (_) =>
                                      setSheet(() => sheetDiet = diet['label']),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Meals per day',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: allMeals.map((meal) {
                                final isSelected = sheetMeals == meal;
                                return ChoiceChip(
                                  label: Text(meal),
                                  selected: sheetMeals == meal,
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  showCheckmark: false,
                                  onSelected: (_) =>
                                      setSheet(() => sheetMeals = meal),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Regional food preference',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: allRegions.map((region) {
                                final isSelected = sheetRegions.contains(
                                  region['label'],
                                );
                                return FilterChip(
                                  label: Text(region['label']),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: sheetRegions.contains(
                                    region['label'],
                                  ),
                                  showCheckmark: false,
                                  avatar: Icon(region['icon']),
                                  onSelected: (selected) {
                                    setSheet(() {
                                      const noPreference = 'No preference';
                                      if (region['label'] == noPreference) {
                                        sheetRegions.clear();
                                        if (selected)
                                          sheetRegions.add(noPreference);
                                      } else {
                                        selected
                                            ? sheetRegions.add(region['label'])
                                            : sheetRegions.remove(
                                                region['label'],
                                              );
                                        sheetRegions.remove(noPreference);
                                        if (allRegions
                                            .where(
                                              (r) => r['label'] != noPreference,
                                            )
                                            .every(
                                              (r) => sheetRegions.contains(
                                                r['label'],
                                              ),
                                            )) {
                                          sheetRegions
                                            ..clear()
                                            ..add(noPreference);
                                        }
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  setSheet(() => isSaving = true);
                                  try {
                                    final dietChanged =
                                        sheetDiet != user.dietType;
                                    await context
                                        .read<DataProvider>()
                                        .updateDietPreference(
                                          newDiet: dietChanged
                                              ? sheetDiet
                                              : null,
                                          newMeals: sheetMeals,
                                          newRegions: sheetRegions.toList(),
                                        );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to save: $e'),
                                        ),
                                      );
                                    }
                                  } finally {
                                    setSheet(() => isSaving = false);
                                  }
                                  if (context.mounted) Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: isSaving
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  };

  static void Function(BuildContext) timeEdit = (BuildContext context) {
    final provider = context.read<DataProvider>();
    final user = provider.currentUser!;

    String selectedSleepPattern = user.sleepPattern;
    List<String> selectedTimeType = List.from(user.timeType);
    String selectedDurationType = user.durationType;
    String selectedDayType = user.dayType;
    List<String> selectedFreeType = List.from(user.freeType);

    const sleepPatternOptions = [
      'Less than 5 hours',
      '5 to 7 hours',
      '7 to 9 hours',
      'More than 9 hours',
    ];

    const timeTypeOptions = [
      'Early Morning',
      'Late Morning',
      'Afternoon',
      'Evening',
    ];
    final timeAvatars = [Emoji.s1, Emoji.s2, Emoji.s3, Emoji.s4];
    final placeOptions = ['Home', 'Gym', 'Outdoors', 'Any'];
    final placeIcons = [
      Emoji.place1,
      Emoji.place2,
      Emoji.place3,
      Emoji.style10,
    ];
    const durationOptions = ['15-30 min', '30-45 min', '45-60 min', '60+ min'];
    const dayOptions = ['2', '3', '4', '5', '6'];
    const freeDayOptions = ['Son', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final ch = Theme.of(ctx).colorScheme;
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Schedule',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Hrs of Sleep',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: sleepPatternOptions.map((opt) {
                                final isSelected = selectedSleepPattern == opt;
                                return ChoiceChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : ch.primary,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  showCheckmark: false,
                                  selected: isSelected,
                                  onSelected: (_) => setSheet(
                                    () => selectedSleepPattern = opt,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Workout Time',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: timeTypeOptions.map((opt) {
                                final isSelected = selectedTimeType.contains(
                                  opt,
                                );
                                final index = timeTypeOptions.indexOf(opt);
                                return FilterChip(
                                  label: Text(opt),
                                  selected: isSelected,
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  avatar: timeAvatars[index],
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : ch.primary,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  showCheckmark: false,
                                  onSelected: (selected) => setSheet(() {
                                    selected
                                        ? selectedTimeType.add(opt)
                                        : selectedTimeType.remove(opt);
                                  }),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Workout Session',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: durationOptions.map((opt) {
                                final isSelected = selectedDurationType == opt;
                                return ChoiceChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : ch.primary,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  showCheckmark: false,
                                  onSelected: (_) {
                                    setSheet(() => selectedDurationType = opt);
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Workout Place',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: placeOptions.map((opt) {
                                final isSelected = selectedDurationType == opt;
                                final index = placeOptions.indexOf(opt);
                                return ChoiceChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : ch.primary,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  avatar: placeIcons[index],
                                  showCheckmark: false,
                                  onSelected: (_) {
                                    setSheet(() => selectedDurationType = opt);
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Workout Per Week',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: dayOptions.map((opt) {
                                final isSelected = selectedDayType == opt;
                                return ChoiceChip(
                                  label: Text(opt),
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : ch.primary,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  selected: isSelected,
                                  showCheckmark: false,
                                  onSelected: (_) {
                                    setSheet(() => selectedDayType = opt);
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Free Days',
                              style: Theme.of(ctx).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: freeDayOptions.map((opt) {
                                final isSelected = selectedFreeType.contains(
                                  opt,
                                );
                                return FilterChip(
                                  label: Text(opt),
                                  selected: isSelected,
                                  shape: StadiumBorder(),
                                  backgroundColor: ch.surface,
                                  selectedColor: CustomColors.primaryMuted(
                                    context,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : ch.primary,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? ch.primary
                                        : ch.onSurface,
                                  ),
                                  showCheckmark: false,
                                  onSelected: (selected) => setSheet(() {
                                    selected
                                        ? selectedFreeType.add(opt)
                                        : selectedFreeType.remove(opt);
                                  }),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  setSheet(() => isSaving = true);
                                  try {
                                    await context
                                        .read<DataProvider>()
                                        .updateSchedule(
                                          sleepPattern: selectedSleepPattern,
                                          timeType: selectedTimeType,
                                          durationType: selectedDurationType,
                                          dayType: selectedDayType,
                                          freeType: selectedFreeType,
                                        );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to save: $e'),
                                        ),
                                      );
                                    }
                                  } finally {
                                    setSheet(() => isSaving = false);
                                  }
                                  if (context.mounted) Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: isSaving
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  };

  static void Function(BuildContext) userEdit = (BuildContext context) {
    final user = context.read<DataProvider>().currentUser!;
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);

    String? usernameError;
    String? emailError;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final ch = Theme.of(ctx).colorScheme;
        final th = Theme.of(ctx).textTheme;
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ch.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Username or Email',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username', style: th.labelLarge),
                            const SizedBox(height: 10),
                            TextField(
                              controller: usernameController,
                              onChanged: (_) {
                                if (usernameError != null) {
                                  setSheet(() {
                                    usernameError = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: CustomColors.greyLight(context),
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.height_rounded),
                                errorText: usernameError,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('Email', style: th.labelLarge),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailController,
                              onChanged: (_) {
                                if (emailError != null) {
                                  setSheet(() {
                                    emailError = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: CustomColors.greyLight(context),
                                labelText: 'Email',
                                prefixIcon: Icon(Symbols.weight_rounded),
                                errorText: emailError,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  bool isValid = true;
                                  final u = usernameController.text.trim();
                                  if (u.isEmpty) {
                                    usernameError = 'Username is required';
                                    isValid = false;
                                  } else if (!RegExp(
                                    r'^[a-zA-Z0-9_]+$',
                                  ).hasMatch(u)) {
                                    usernameError =
                                        'Only letters, numbers and underscore';
                                    isValid = false;
                                  } else {
                                    usernameError = null;
                                  }

                                  final e = emailController.text.trim();
                                  if (e.isEmpty) {
                                    emailError = 'Email is required';
                                    isValid = false;
                                  } else if (!RegExp(
                                    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(e)) {
                                    emailError = 'Enter a valid email';
                                    isValid = false;
                                  } else {
                                    emailError = null;
                                  }

                                  if (!isValid) return;

                                  setSheet(() => isSaving = true);
                                  try {
                                    await context
                                        .read<DataProvider>()
                                        .updateUsernameAndEmail(
                                          username: usernameController.text,
                                          email: emailController.text,
                                        );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to save: $e'),
                                        ),
                                      );
                                    }
                                  } finally {
                                    setSheet(() => isSaving = false);
                                  }
                                  if (context.mounted) Navigator.pop(ctx);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            child: isSaving
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  };

  static void Function(BuildContext) phoneEdit = (BuildContext context) {
    final user = context.read<DataProvider>().currentUser!;

    final List<Map<String, String>> codes = [
      {'name': 'BAN', 'code': '+880'},
      {'name': 'US/CAN', 'code': '+1'},
      {'name': 'UK', 'code': '+44'},
      {'name': 'IN', 'code': '+91'},
      {'name': 'AUS', 'code': '+61'},
      {'name': 'GER', 'code': '+49'},
      {'name': 'FRA', 'code': '+33'},
      {'name': 'UAE', 'code': '+971'},
      {'name': 'SAU', 'code': '+966'},
    ];
    String selectedCode = '+880';
    String initialNumber = '';
    if (user.phone != null && user.phone != 'None' && user.phone!.isNotEmpty) {
      final allCodes = codes.map((c) => c['code']!).toList();
      allCodes.sort((a, b) => b.length.compareTo(a.length));
      final matchedCode = allCodes.firstWhere(
        (code) => user.phone!.startsWith(code),
        orElse: () => '+880',
      );
      selectedCode = matchedCode;
      initialNumber = user.phone!.substring(matchedCode.length);
    }
    final phoneController = TextEditingController(text: initialNumber);
    String? phoneError;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final ch = Theme.of(ctx).colorScheme;
        final th = Theme.of(ctx).textTheme;
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsetsGeometry.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ch.tertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Phone Number',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      Divider(),
                      const SizedBox(height: 15),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone Number', style: th.labelLarge),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 56,
                                        width: 90,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: CustomColors.greyLight(
                                              context,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    isDense: true,
                                                    elevation: 0,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                    value: selectedCode,
                                                    items: codes
                                                        .map<
                                                          DropdownMenuItem<
                                                            String
                                                          >
                                                        >((country) {
                                                          return DropdownMenuItem<
                                                            String
                                                          >(
                                                            value:
                                                                country['code'],
                                                            child: Text(
                                                              '${country['name']} (${country['code']})',
                                                            ),
                                                          );
                                                        })
                                                        .toList(),
                                                    onChanged:
                                                        (String? newCode) {
                                                          setSheet(() {
                                                            selectedCode =
                                                                newCode!;
                                                            if (phoneError !=
                                                                null)
                                                              phoneError = null;
                                                          });
                                                        },
                                                    selectedItemBuilder:
                                                        (BuildContext context) {
                                                          return codes.map<
                                                            Widget
                                                          >((country) {
                                                            return Text(
                                                              country['code']!,
                                                            );
                                                          }).toList();
                                                        },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (phoneError != null)
                                        const SizedBox(height: 18),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      onChanged: (_) {
                                        if (phoneError != null) {
                                          setSheet(() => phoneError = null);
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: CustomColors.greyLight(
                                          context,
                                        ),
                                        prefixIcon: Icon(Icons.phone),
                                        labelText: 'Phone no',
                                        hintText: 'XXXXXXXXXX',
                                        helperText: '*Leave Empty to remove',
                                        errorText: phoneError,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: isSaving
                                ? null
                                : () {
                                    Navigator.pop(ctx);
                                  },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          FilledButton(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    final number = phoneController.text.trim();
                                    if (number.isNotEmpty &&
                                        number.length != 10) {
                                      setSheet(
                                        () => phoneError =
                                            'Please enter a valid phone no',
                                      );
                                      return;
                                    }
                                    final merged = number.isNotEmpty
                                        ? '$selectedCode$number'
                                        : null;

                                    setSheet(() => isSaving = true);
                                    try {
                                      await context
                                          .read<DataProvider>()
                                          .updateProfileField(
                                            'phone',
                                            merged ?? 'None',
                                          );
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Failed to save: $e'),
                                          ),
                                        );
                                      }
                                    } finally {
                                      setSheet(() => isSaving = false);
                                    }
                                    if (context.mounted) Navigator.pop(ctx);
                                  },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              child: isSaving
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Save',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  };

  static void Function(BuildContext) passEdit = (BuildContext context) {};
}
