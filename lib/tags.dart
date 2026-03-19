import 'package:core_care/main.dart';
import 'package:flutter/material.dart';

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
  final List<String> medCommon = [
    'High blood pressure', 'High cholesterol', 'Type 2 diabetes', 'Pre-diabetes',
    'Obesity', 'Acid reflux', 'Irritable bowel', 'Asthma', 'PCOS',
    'Painful periods', 'Chronic fatigue', 'Burnout', 'Post-illness',
    'Deconditioning', 'Tension headaches',
  ];

  final List<String> medMore = [
    'Low blood pressure', 'Anaemia', 'Insulin resistance', 'Metabolic syndrome',
    'Underactive thyroid', 'Overactive thyroid', 'Adrenal fatigue', 'Perimenopause',
    'Menopause', 'Low testosterone', 'Endometriosis', 'Pelvic floor weakness',
    'Diastasis recti', 'Post-partum', 'Pregnancy', 'Exercise-induced asthma',
    'COPD', 'Post-COVID', 'Low lung capacity', 'Osteopenia', 'Osteoporosis',
    'Scoliosis', 'Hypermobility', 'Celiac disease', "Crohn's disease",
    'Ulcerative colitis', 'Chronic constipation', 'SIBO', 'Sciatica',
    'Carpal tunnel', 'Peripheral neuropathy', 'Restless legs', 'Heart condition',
    'Multiple sclerosis', 'Post-surgery', 'Post-stroke', 'Post-cancer',
    'Sarcopenia', 'Spinal stenosis', 'Frailty', 'Osgood-Schlatter',
    "Sever's disease", "Parkinson's",
  ];

  final Set<String> selectedMeds = {};

  @override
  Widget build(BuildContext context) {
    final ch = Theme.of(context).colorScheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: medCommon.map((med){
            final isSelected = selectedMeds.contains(med);
            return FilterChip(label: Text(med),
                selected: isSelected,
                onSelected: (_) => setState(() {
                  if(isSelected){
                    selectedMeds.remove(med);
                  }else{
                    selectedMeds.add(med);
                  }
                }),
              showCheckmark: false,
              selectedColor: CustomColors.primaryMuted(context),
              side: BorderSide(
                color: isSelected ? ch.primary : ch.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class InjuryChips extends StatefulWidget {
  const InjuryChips({super.key});

  @override
  State<InjuryChips> createState() => _InjuryChipsState();
}

class _InjuryChipsState extends State<InjuryChips> {
  final List<String> injureCommon = [
    'Knee pain', 'Lower back pain', 'Shoulder pain', 'Neck strain', 'Hip pain',
    'Ankle sprain', 'Plantar fasciitis', 'Shin splints', 'Flat feet',
    'Muscle tightness', 'Upper back pain', 'Wrist pain',
  ];

  final List<String> injureMore = [
    "Runner's knee", "Jumper's knee", 'IT band pain', 'Knee arthritis',
    'Hip flexor strain', 'Hip bursitis', 'Hip impingement', 'Piriformis pain',
    'Sacroiliac pain', 'Rotator cuff strain', 'Shoulder impingement',
    'Frozen shoulder', 'Bicep tendinitis', 'Tennis elbow', "Golfer's elbow",
    'Achilles tendinitis', 'Back muscle strain', 'Disc bulge', 'Hamstring strain',
    'Quad strain', 'Calf strain', 'Groin strain', 'Tendon pain',
    'Post-knee replacement', 'Post-hip replacement', 'Post-shoulder surgery',
    'Post-spinal surgery', 'Post-fracture',
  ];

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
