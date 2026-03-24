import 'package:core_care/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tags extends StatelessWidget {
  const Tags({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MedChips extends StatefulWidget {
  const MedChips({super.key});

  @override
  State<MedChips> createState() => _MedChipsState();
}

class _MedChipsState extends State<MedChips> {
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

  late List<String> meds;

  @override
  void initState() {
    super.initState();
    final gender = context.read<DataProvider>().pageOne.gender;
    meds = gender == 1 ? maleMeds : femaleMeds;
    final saved = context.read<DataProvider>().pageTwo.selectedMeds;
    selectedMeds.addAll(saved);
  }

  final Set<String> selectedMeds = {};

  void updateMeds(){
    final data = context.read<DataProvider>().pageTwo;
    data.selectedMeds = selectedMeds.toList();
    context.read<DataProvider>().updatePageTwo(data);
  }

  Future<List<String>?> openBottomSheet(
    BuildContext context,
    List<String> list,
  ) {
    List<String> tempSelection = [];
    return showModalBottomSheet<List<String>>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            List<Widget> chips = [];
            for (int i = 0; i < list.length; i++) {
              String med = list[i];
              bool isSelected = tempSelection.contains(med);

              chips.add(
                InputChip(
                  label: Text(med, style: TextStyle(fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400),),
                  selected: isSelected,
                  showCheckmark: false,
                  avatar: isSelected ? Icon(Icons.close) : Icon(Icons.add,),
                  onPressed: () {
                    setModalState(() {
                      if (isSelected) {
                        tempSelection.remove(med);
                      } else {
                        tempSelection.add(med);
                      }
                    });
                  },
                ),
              );
            }
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
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Other Medical Conditions'),
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
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: chips,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelection);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: Text('Save'),
                      ),
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

  List<String> getRemainingMeds() {
    List<String> remains = [];
    for (int i = 8; i < meds.length; i++) {
      String med = meds[i];
      if (!selectedMeds.contains(med)) {
        remains.add(med);
      }
    }
    return remains;
  }

  Future<void> handleOpenSheet() async {
    List<String> remainingMeds = getRemainingMeds();
    final sheet = await openBottomSheet(context, remainingMeds);
    if (sheet != null) {
      setState(() {
        for (int i = 0; i < sheet.length; i++) {
          selectedMeds.add(sheet[i]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    for (int i = 0; i <= 7; i++) {
      String med = meds[i];
      chips.add(
        FilterChip(
          label: Text(med),
          selected: selectedMeds.contains(med),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedMeds.add(med);
              } else {
                selectedMeds.remove(med);
              }
            });
          },
        ),
      );
    }
    for (int i = 8; i < meds.length; i++) {
      String med = meds[i];
      if (selectedMeds.contains(med)) {
        chips.add(
          FilterChip(
            label: Text(med),
            selected: true,
            onSelected: (bool selected) {
              setState(() {
                selectedMeds.remove(med);
              });
            },
          ),
        );
      }
    }
    chips.add(
      OutlinedButton(
        onPressed: () {
          handleOpenSheet();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.add), const SizedBox(width: 8), Text('Other')],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(spacing: 10, runSpacing: 10, children: chips),
    );
  }
}

class InjuryChips extends StatefulWidget {
  const InjuryChips({super.key});

  @override
  State<InjuryChips> createState() => _InjuryChipsState();
}

class _InjuryChipsState extends State<InjuryChips> {
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

  @override
  void initState() {
    super.initState();
    final saved = context.read<DataProvider>().pageTwo.selectedInjuries;
    selectedIns.addAll(saved);
  }

  final Set<String> selectedIns = {};

  void updateInjuries(){
    final data = context.read<DataProvider>().pageTwo;
    data.selectedInjuries = selectedIns.toList();
    context.read<DataProvider>().updatePageTwo(data);
  }

  Future<List<String>?> openBottomSheet(
    BuildContext context,
    List<String> list,
  ) {
    List<String> tempSelection = [];
    return showModalBottomSheet<List<String>>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            List<Widget> chips = [];
            for (int i = 0; i < list.length; i++) {
              String ins = list[i];
              bool isSelected = tempSelection.contains(ins);

              chips.add(
                InputChip(
                  label: Text(ins, style: TextStyle(fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400),),
                  selected: isSelected,
                  showCheckmark: false,
                  avatar: isSelected ? Icon(Icons.close) : Icon(Icons.add,),
                  onPressed: () {
                    setModalState(() {
                      if (isSelected) {
                        tempSelection.remove(ins);
                      } else {
                        tempSelection.add(ins);
                      }
                    });
                  },
                ),
              );
            }
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
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Other Injuries'),
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
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: chips,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelection);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: Text('Save'),
                      ),
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

  List<String> getRemainingMeds() {
    List<String> remains = [];
    for (int i = 8; i < injuries.length; i++) {
      String ins = injuries[i];
      if (!selectedIns.contains(ins)) {
        remains.add(ins);
      }
    }
    return remains;
  }

  Future<void> handleOpenSheet() async {
    List<String> remainingMeds = getRemainingMeds();
    final sheet = await openBottomSheet(context, remainingMeds);
    if (sheet != null) {
      setState(() {
        for (int i = 0; i < sheet.length; i++) {
          selectedIns.add(sheet[i]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    for (int i = 0; i <= 7; i++) {
      String ins = injuries[i];
      chips.add(
        FilterChip(
          label: Text(ins),
          selected: selectedIns.contains(ins),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedIns.add(ins);
              } else {
                selectedIns.remove(ins);
              }
            });
          },
        ),
      );
    }
    for (int i = 8; i < injuries.length; i++) {
      String ins = injuries[i];
      if (selectedIns.contains(ins)) {
        chips.add(
          FilterChip(
            label: Text(ins),
            selected: true,
            onSelected: (bool selected) {
              setState(() {
                selectedIns.remove(ins);
              });
            },
          ),
        );
      }
    }
    chips.add(
      OutlinedButton(
        onPressed: () {
          handleOpenSheet();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.add), const SizedBox(width: 8), Text('Other')],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(spacing: 10, runSpacing: 10, children: chips),
    );
  }
}

class AllergenChips extends StatefulWidget {
  const AllergenChips({super.key});

  @override
  State<AllergenChips> createState() => _AllergenChipsState();
}

class _AllergenChipsState extends State<AllergenChips> {
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

  final Set<String> selectedAllergens = {};

  Future<List<String>?> openBottomSheet(
    BuildContext context,
    List<String> list,
  ) {
    List<String> tempSelection = [];
    return showModalBottomSheet<List<String>>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            List<Widget> chips = [];
            for (int i = 0; i < list.length; i++) {
              String allergy = list[i];
              bool isSelected = tempSelection.contains(allergy);

              chips.add(
                InputChip(
                  label: Text(allergy, style: TextStyle(fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400),),
                  selected: isSelected,
                  showCheckmark: false,
                  avatar: isSelected ? Icon(Icons.close) : Icon(Icons.add,),
                  onPressed: () {
                    setModalState(() {
                      if (isSelected) {
                        tempSelection.remove(allergy);
                      } else {
                        tempSelection.add(allergy);
                      }
                    });
                  },
                ),
              );
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
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
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Other Allergies'),
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
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: chips,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelection);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: Text('Save'),
                      ),
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

  List<String> getRemainingMeds() {
    List<String> remains = [];
    for (int i = 8; i < allergens.length; i++) {
      String allergy = allergens[i];
      if (!selectedAllergens.contains(allergy)) {
        remains.add(allergy);
      }
    }
    return remains;
  }

  Future<void> handleOpenSheet() async {
    List<String> remainingMeds = getRemainingMeds();
    final sheet = await openBottomSheet(context, remainingMeds);
    if (sheet != null) {
      setState(() {
        for (int i = 0; i < sheet.length; i++) {
          selectedAllergens.add(sheet[i]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    for (int i = 0; i <= 7; i++) {
      String allergy = allergens[i];
      chips.add(
        FilterChip(
          label: Text(allergy),
          selected: selectedAllergens.contains(allergy),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedAllergens.add(allergy);
              } else {
                selectedAllergens.remove(allergy);
              }
            });
          },
        ),
      );
    }
    for (int i = 8; i < allergens.length; i++) {
      String allergy = allergens[i];
      if (selectedAllergens.contains(allergy)) {
        chips.add(
          FilterChip(
            label: Text(allergy),
            selected: true,
            onSelected: (bool selected) {
              setState(() {
                selectedAllergens.remove(allergy);
              });
            },
          ),
        );
      }
    }
    chips.add(
      OutlinedButton(
        onPressed: () {
          handleOpenSheet();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.add), const SizedBox(width: 8), Text('Other')],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(spacing: 10, runSpacing: 10, children: chips),
    );
  }
}

class IntoleranceChips extends StatefulWidget {
  const IntoleranceChips({super.key});

  @override
  State<IntoleranceChips> createState() => _IntoleranceChipsState();
}

class _IntoleranceChipsState extends State<IntoleranceChips> {
  final List<String> intolerances = [
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

  final Set<String> selectedIntolerances = {};

  Future<List<String>?> openBottomSheet(
    BuildContext context,
    List<String> list,
  ) {
    List<String> tempSelection = [];
    return showModalBottomSheet<List<String>>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            List<Widget> chips = [];
            for (int i = 0; i < list.length; i++) {
              String ints = list[i];
              bool isSelected = tempSelection.contains(ints);

              chips.add(
                InputChip(
                  label: Text(ints, style: TextStyle(fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400),),
                  selected: isSelected,
                  showCheckmark: false,
                  avatar: isSelected ? Icon(Icons.close) : Icon(Icons.add,),
                  onPressed: () {
                    setModalState(() {
                      if (isSelected) {
                        tempSelection.remove(ints);
                      } else {
                        tempSelection.add(ints);
                      }
                    });
                  },
                ),
              );
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
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
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Other Intolerances'),
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
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: chips,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelection);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: Text('Save'),
                      ),
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

  List<String> getRemainingMeds() {
    List<String> remains = [];
    for (int i = 8; i < intolerances.length; i++) {
      String ints = intolerances[i];
      if (!selectedIntolerances.contains(ints)) {
        remains.add(ints);
      }
    }
    return remains;
  }

  Future<void> handleOpenSheet() async {
    List<String> remainingMeds = getRemainingMeds();
    final sheet = await openBottomSheet(context, remainingMeds);
    if (sheet != null) {
      setState(() {
        for (int i = 0; i < sheet.length; i++) {
          selectedIntolerances.add(sheet[i]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    for (int i = 0; i <= 7; i++) {
      String ints = intolerances[i];
      chips.add(
        FilterChip(
          label: Text(ints),
          selected: selectedIntolerances.contains(ints),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedIntolerances.add(ints);
              } else {
                selectedIntolerances.remove(ints);
              }
            });
          },
        ),
      );
    }
    for (int i = 8; i < intolerances.length; i++) {
      String ints = intolerances[i];
      if (selectedIntolerances.contains(ints)) {
        chips.add(
          FilterChip(
            label: Text(ints),
            selected: true,
            onSelected: (bool selected) {
              setState(() {
                selectedIntolerances.remove(ints);
              });
            },
          ),
        );
      }
    }
    chips.add(
      OutlinedButton(
        onPressed: () {
          handleOpenSheet();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.add), const SizedBox(width: 8), Text('Other')],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(spacing: 10, runSpacing: 10, children: chips),
    );
  }
}

class DislikedChips extends StatefulWidget {
  const DislikedChips({super.key});

  @override
  State<DislikedChips> createState() => _DislikedChipsState();
}

class _DislikedChipsState extends State<DislikedChips> {
  final List<String> omnivoreDislikes = [
    "Meat",
    "Lamb",
    "Pork",
    "Organ meats",
    "Game meats",
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
    "Slimy",
    "Chewy",
    "Seedy / grainy",
  ];
  final List<String> vegetarianDislikes = [
    "Eggs",
    "Milk",
    "Yogurt",
    "Cheese",
    "Cottage cheese",
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
    "Slimy",
    "Chewy",
    "Seedy / grainy",
  ];
  final List<String> veganDislikes = [
    "Tofu / tempeh",
    "Lentils / beans",
    "Nutritional yeast",
    "Seitan",
    "Spirulina / chlorella",
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
    "Slimy",
    "Chewy",
    "Seedy / grainy",
  ];
  final List<String> pescatarianDislikes = [
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
    "Slimy",
    "Chewy",
    "Seedy / grainy",
  ];
  final List<String> paleoDislikes = [
    "Lamb",
    "Pork",
    "Organ meats",
    "Game meats",
    "All fish",
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
    "Slimy",
    "Chewy",
    "Seedy / grainy",
  ];
  final List<String> ketoDislikes = [
    "Lamb",
    "Pork",
    "Organ meats",
    "Game meats",
    "All fish",
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
    "Slimy",
    "Chewy",
    "Seedy / grainy",
  ];

  late List<String> dislikes;

  // {
  //   super.initState();
  //   final gender = context.read<DataProvider>().pageOne.gender;
  //   meds = gender == 1 ? maleMeds : femaleMeds;
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   final diet = context.read<DataProvider>().pageSeven.diet;
  //
  // }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
