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

  static final List<String> meds = [
    'High blood pressure', 'High cholesterol', 'Type 2 diabetes', 'Pre-diabetes',
    'Obesity', 'Acid reflux', 'Irritable bowel', 'Asthma', 'PCOS',
    'Painful periods', 'Chronic fatigue', 'Burnout', 'Post-illness',
    'Deconditioning', 'Tension headaches', 'Low blood pressure', 'Anaemia', 'Insulin resistance', 'Metabolic syndrome',
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

  static Future<List<String>?> openBottomSheet(BuildContext context, List<String> list){
    List<String> tempSelection = [];
    return showModalBottomSheet<List<String>>(isScrollControlled: true,context: context, builder: (context){
      return StatefulBuilder(
          builder: (context, setModalState){
            List<Widget> chips = [];
            for(int i=0;i<list.length;i++){
              String med = list[i];
              bool isSelected = tempSelection.contains(med);

              chips.add(
                InputChip(label: Text(med),
                selected: isSelected,
                onPressed: (){
                  setModalState((){
                    if(isSelected){
                      tempSelection.remove(med);
                    }else{
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
                    const SizedBox(height: 10,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Other Medical Conditions',), IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.close))]),
                    Divider(),
                    const SizedBox(height: 15,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: chips,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    FilledButton(onPressed: (){
                      Navigator.pop(context, tempSelection);
                    }, child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: Text('Save')))
                  ],
                ),
              ),
            );
          }
      );
    });
  }

  List<String> getRemainingMeds(){
    List<String> remains = [];
    for(int i=8;i<meds.length;i++){
      String med = meds[i];
      if(!selectedMeds.contains(med)){
        remains.add(med);
      }
    }
    return remains;
  }

  Future<void> handleOpenSheet() async{
    List<String> remainingMeds = getRemainingMeds();
    final sheet = await openBottomSheet(context, remainingMeds);
    if(sheet != null){
      setState(() {
        for(int i=0;i<sheet.length;i++){
          selectedMeds.add(sheet[i]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ch = Theme.of(context).colorScheme;
    List<Widget> chips = [];

    for(int i=0;i<=7;i++){
      String med = meds[i];
      chips.add(
        FilterChip(
            label: Text(med),
            selected: selectedMeds.contains(med),
            onSelected: (bool selected){
              setState(() {
                if(selected){
                  selectedMeds.add(med);
                }else{
                  selectedMeds.remove(med);
                }
              });
            }
        ),
      );
    }
    for(int i=8;i<meds.length;i++){
      String med = meds[i];
      if(selectedMeds.contains(med)){
        chips.add(
          FilterChip(
              label: Text(med),
              selected: true,
              onSelected: (bool selected){
                setState(() {
                  selectedMeds.remove(med);
                });
              }
          )
        );
      }
    }
    chips.add(
      OutlinedButton(onPressed: (){
        handleOpenSheet();
      }, child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add),
          const SizedBox(width: 8,),
          Text('Other'),
        ],
      )),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: chips,
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
