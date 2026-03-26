import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_care/main.dart';
import 'package:core_care/tags.dart';
import 'package:flutter/material.dart';
import 'package:core_care/decoration.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:core_care/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignupPageOneData{
  String? name;
  DateTime? dob;
  int? gender;
  double? height;
  double? weight;
  bool isHeightFt;
  bool isWeightKg;
  double? bmi;
  double? bmr;
  String? ageGroup;
  int? age;
  String? category;

  SignupPageOneData({
    this.name,
    this.dob,
    this.gender,
    this.height,
    this.weight,
    this.isHeightFt = true,
    this.isWeightKg = true,
    this.bmi,
    this.bmr,
    this.ageGroup,
    this.age,
    this.category,
  });

  double toHeightCm(double value, bool isFt){
    return isFt ? value * 30.48 : value;
  }

  double toWeightKg(double value, bool isKg){
    return isKg ? value : value * 0.453592;
  }

  double calculateBMI(double h, double w){
    final height = h / 100;
    return w / (height * height);
  }
  double calculateBMR(double h, double w, int age, int gender){
    final base = (10 * w) + (6.25 * h) - (5 * age);
    return gender == 1 ? base + 5 : base - 161;
  }
  int calculateAge(DateTime dob){
    final today = DateTime.now();
    int age = today.year - dob.year;
    if(today.month < dob.month || (today.month == dob.month && today.day < dob.day)){
      age--;
    }
    return age;
  }

  String getAgeGroup(int age){
    if(age < 18) return 'Teen';
    if(age < 30) return 'Young Adult';
    if(age < 60) return 'Adult';
    return 'Senior';
  }
  String getCategory(double bmi){
    if(bmi < 18.5) return 'Underweight';
    if(bmi < 25) return 'Normal';
    if(bmi < 30) return 'Overweight';
    return 'Obese';
  }

  void calculateAndSave(){
    if(height != null && weight != null && dob != null && gender != null){
      final heightCm = toHeightCm(height!, isHeightFt);
      final weightKg = toWeightKg(weight!, isWeightKg);
      final calculatedAge = calculateAge(dob!);
      age = calculateAge(dob!);
      bmi = double.parse(calculateBMI(heightCm, weightKg).toStringAsFixed(1));
      bmr = double.parse(calculateBMR(heightCm, weightKg, calculatedAge, gender!).toStringAsFixed(1));
      ageGroup = getAgeGroup(calculatedAge);
      category = getCategory(bmi!);
    }
  }
}

class SignupPageOne extends StatefulWidget {
  final SignupPageOneData data;
  final VoidCallback onNext;
  const SignupPageOne({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageOne> createState() => _SignupPageOneState();
}

class _SignupPageOneState extends State<SignupPageOne> {
  late SignupPageOneData data;
  final nameKey = GlobalKey();
  final dobKey = GlobalKey();
  final genderKey = GlobalKey();
  final heightKey = GlobalKey();
  final weightKey = GlobalKey();
  String? nameError;
  String? dobError;
  String? genderError;
  String? heightError;
  String? weightError;
  int? genderSelected;
  bool isHeightUnitOne = true;
  bool isWeightUnitOne = true;
  DateTime? selectedDate;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> pickDate() async{
    DateTime? picked = await showDatePicker(context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: DateTime.now()
    );

    if(picked != null){
      setState(() {
        selectedDate = picked;
        dateController.text = formattedDate(picked);
      });
    }
  }

  String formattedDate(DateTime date){
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();

    return '$year-$month-$day';
  }

  void selectGender(int g){
    setState(() {
      genderSelected = g;
      if(genderError != null){
        genderError = null;
      }
    });
  }

  bool validateInput(){
    bool isValid = true;
    setState(() {
      if(nameController.text.isEmpty){
        nameError = 'Name is required';
        isValid = false;
      }else{
        nameError = null;
      }

      if(selectedDate == null){
        dobError = 'Date of birth is required';
        isValid = false;
      }else{
        dobError = null;

        final age = data.calculateAge(selectedDate!);
        if(age < 13){
          dobError = 'You must be at least 13 years old';
          isValid = false;
        }
      }

      if(genderSelected == null){
        genderError = 'Select gender';
        isValid = false;
      }else{
        genderError = null;
      }

      final h = double.tryParse(heightController.text);
      if(heightController.text.isEmpty){
        heightError = 'Height is required';
        isValid = false;
      }else if(h == null || h <= 0){
        heightError = 'Enter valid height';
        isValid = false;
      }else{
        heightError = null;
      }

      final w = double.tryParse(weightController.text);
      if(weightController.text.isEmpty){
        weightError = 'Weight is required';
        isValid = false;
      }else if(w == null || w <= 0){
        weightError = 'Enter valid weight';
        isValid = false;
      }else{
        weightError = null;
      }
    });

    return isValid;
  }

  void saveData(){
    data.name = nameController.text.trim();
    data.dob = selectedDate;
    data.gender = genderSelected;
    data.height = double.tryParse(heightController.text);
    data.weight = double.tryParse(weightController.text);
    data.isHeightFt = isHeightUnitOne;
    data.isWeightKg = isWeightUnitOne;
    data.calculateAndSave();
  }

  void _scrollToError(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  void handleNext(){
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = validateInput();
    if(!isValid){
      List<GlobalKey> errorKeys = [];
      if(nameError != null) errorKeys.add(nameKey);
      if(dobError != null) errorKeys.add(dobKey);
      if(genderError != null) errorKeys.add(genderKey);
      if(heightError != null) errorKeys.add(heightKey);
      if(weightError != null) errorKeys.add(weightKey);

      if(errorKeys.isNotEmpty) _scrollToError(errorKeys.first);
      return;
    }
    saveData();
    context.read<DataProvider>().updatePageOne(data);
    widget.onNext();
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;

    nameController.text = data.name ?? '';
    heightController.text = data.height?.toString() ?? '';
    weightController.text = data.weight?.toString() ?? '';
    selectedDate = data.dob;
    genderSelected = data.gender;
    isHeightUnitOne = data.isHeightFt;
    isWeightUnitOne = data.isWeightKg;
    if(selectedDate != null){
      dateController.text = formattedDate(selectedDate!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ch = Theme.of(context).colorScheme;
    final th = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,children: [
        Row(
          children: [
            Emoji.page1,
            const SizedBox(width: 10,),
            Text('Let\'s Get to Know You', style: th.displaySmall,),
          ],
        ),
        const SizedBox(height: 10,),
        Text('A few details to set things up for you', style: th.labelMedium,),
        const SizedBox(height: 20,),
        TextField(
          key: nameKey,
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person_rounded),
            errorText: nameError,
          ),
          onChanged: (_){
            if(nameError != null){
              setState(() {
                nameError = null;
              });
            }
          },
        ),
        const SizedBox(height: 20,),
        TextField(
          key: dobKey,
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            prefixIcon: Icon(Icons.calendar_month_outlined),
            errorText: dobError,
          ),
          onTap: pickDate,
          onChanged: (_){
            if(dobError != null){
              setState(() {
                dobError = null;
              });
            }
          },
        ),
        const SizedBox(height: 20,),
        Text(key: genderKey,'Gender'),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>  selectGender(1),
                child: Container(
                  decoration: BoxDecoration(
                    color: genderSelected != 1 ? ch.surface : CustomColors.primaryMuted(context),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: genderSelected == 1 ? ch.primary : Colors.transparent),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        children: [
                          Icon(Icons.male_rounded),
                          const SizedBox(height: 5,),
                          Text('Male'),
                          const SizedBox(height: 15,),
                          genderSelected == 1 ?
                          Icon(Icons.circle, color: ch.primary,) : Icon(Icons.circle_outlined),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20,),
            Expanded(
                child: GestureDetector(
                  onTap: () => selectGender(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: genderSelected != 2 ? ch.surface : CustomColors.primaryMuted(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: genderSelected == 2 ? ch.primary : Colors.transparent),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          children: [
                            Icon(Icons.female_rounded),
                            const SizedBox(height: 5,),
                            Text('Female'),
                            const SizedBox(height: 15,),
                            genderSelected == 2 ?
                            Icon(Icons.circle, color: ch.primary,) : Icon(Icons.circle_outlined),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ),
          ],
        ),
        if(genderError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(genderError!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                key: heightKey,
                controller: heightController,
                onChanged: (_){
                  if(heightError != null){
                    setState(() {
                      heightError = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Height',
                  prefixIcon: Icon(Icons.height_rounded),
                  errorText: heightError,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: (){
                setState(() {
                  isHeightUnitOne = true;
                });
              },
              child: Container(
                height: 56,
                width: 60,
                decoration: BoxDecoration(
                  color: isHeightUnitOne ? ch.primary : ch.surface,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                  border: Border(
                    top: BorderSide(color: ch.primary),
                    bottom: BorderSide(color: ch.primary),
                    left: BorderSide(color: ch.primary),
                    right: BorderSide.none,
                  ),
                ),
                child: Center(child: Text('ft', style: TextStyle(color: !isHeightUnitOne ? ch.onSurface : ch.onPrimary, fontSize: 16, fontWeight: FontWeight.w600),)),
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  isHeightUnitOne = false;
                });
              },
              child: Container(
                height: 56,
                width: 60,
                decoration: BoxDecoration(
                  color: !isHeightUnitOne ? ch.primary : ch.surface,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                  border: Border(
                    top: BorderSide(color: ch.primary),
                    bottom: BorderSide(color: ch.primary),
                    right: BorderSide(color: ch.primary),
                    left: BorderSide.none,
                  ),
                ),
                child: Center(child: Text('cm', style: TextStyle(color: isHeightUnitOne ? ch.onSurface : ch.onPrimary,  fontSize: 16, fontWeight: FontWeight.w600),)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                key: weightKey,
                controller: weightController,
                onChanged: (_){
                  if(weightError != null){
                    setState(() {
                      weightError = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Weight',
                  prefixIcon: Icon(Symbols.weight_rounded),
                  errorText: weightError,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: (){
                setState(() {
                  isWeightUnitOne = true;
                });
              },
              child: Container(
                height: 56,
                width: 60,
                decoration: BoxDecoration(
                  color: isWeightUnitOne ? ch.primary : ch.surface,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                  border: Border(
                    top: BorderSide(color: ch.primary),
                    bottom: BorderSide(color: ch.primary),
                    left: BorderSide(color: ch.primary),
                    right: BorderSide.none,
                  ),
                ),
                child: Center(child: Text('kg', style: TextStyle(color: !isWeightUnitOne ? ch.onSurface : ch.onPrimary, fontSize: 16, fontWeight: FontWeight.w600),)),
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  isWeightUnitOne = false;
                });
              },
              child: Container(
                height: 56,
                width: 60,
                decoration: BoxDecoration(
                  color: !isWeightUnitOne ? ch.primary : ch.surface,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                  border: Border(
                    top: BorderSide(color: ch.primary),
                    bottom: BorderSide(color: ch.primary),
                    right: BorderSide(color: ch.primary),
                    left: BorderSide.none,
                  ),
                ),
                child: Center(child: Text('lb', style: TextStyle(color: isWeightUnitOne ? ch.onSurface : ch.onPrimary,  fontSize: 16, fontWeight: FontWeight.w600),)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: handleNext,
            child: Text("Next",),
          ),
        ),
      ],),
      ),
    );
  }
}

class SignupPageTwoData{
  List<String> selectedMeds = [];
  List<String> selectedInjuries = [];

  SignupPageTwoData({
    List<String>? selectedMeds,
    List<String>? selectedInjuries,
  }) : selectedMeds = selectedMeds ?? [],
       selectedInjuries = selectedInjuries ?? [];
}

class SignupPageTwo extends StatefulWidget {
  final SignupPageTwoData data;
  final VoidCallback onNext;
  const SignupPageTwo({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageTwo> createState() => _SignupPageTwoState();
}

class _SignupPageTwoState extends State<SignupPageTwo> {
  void handleNext(){
    widget.onNext();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page2,
              const SizedBox(width: 10,),
              Text('Health Considerations', style: Theme.of(context).textTheme.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('Share anything we should be aware of', style: Theme.of(context).textTheme.labelMedium,),
          const SizedBox(height: 20,),
          Text('Select those which applies, tap next if none applies', style: Theme.of(context).textTheme.labelLarge,),
          const SizedBox(height: 10,),
          Row(children: [
            Icon(Icons.medical_services_rounded),
            const SizedBox(width: 10,),
            Text('Medical Conditions'),
          ],),
          const SizedBox(height: 10,),
          MedChips(),
          const SizedBox(height: 20,),
          Row(children: [
            Icon(Icons.personal_injury_rounded),
            const SizedBox(width: 10,),
            Text('Current Injuries'),
          ],),
          const SizedBox(height: 10,),
          InjuryChips(),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }
}

class SignupPageThreeData{
  int? workIndex;
  int? activeIndex;
  int? sleepIndex;

  SignupPageThreeData({
    this.workIndex,
    this.activeIndex,
    this.sleepIndex,
  });

  String get workType{
    const types = ['Sedentary', 'Moderately Active', 'Physically Active'];
    return types[workIndex!];
  }
  String get activityLevel{
    const levels = ['Low', 'Moderate', 'High'];
    return levels[activeIndex!];
  }
  String get sleepPattern{
    const patterns = ['Less than 5 hours', '5 to 7 hours', '7 to 9 hours', 'More than 9 hours'];
    return patterns[sleepIndex!];
  }
  double get workFactor{
    const factors = [1.2, 1.35, 1.55];
    return factors[workIndex!];
  }
  double get activeFactor{
    const factors = [1.0, 1.1, 1.2];
    return factors[activeIndex!];
  }
}

class SignupPageThree extends StatefulWidget {
  final SignupPageThreeData data;
  final VoidCallback onNext;
  const SignupPageThree({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageThree> createState() => _SignupPageThreeState();
}

class _SignupPageThreeState extends State<SignupPageThree> {
  final workKey = GlobalKey();
  final activeKey = GlobalKey();
  final sleepKey = GlobalKey();
  int selectedWork = -1;
  int selectedActive = -1;
  int selectedSleep = -1;
  String? workError;
  String? activeError;
  String? sleepError;

  bool validateInput(){
    bool isValid = true;
    setState(() {
      if(selectedWork == -1) {
        workError = 'Select your work type';
        isValid = false;
      }else{
        workError = null;
      }
      if(selectedActive == -1) {
        activeError = 'Select your activity level';
        isValid = false;
      }else{
        activeError = null;
      }
      if(selectedSleep == -1) {
        sleepError = 'Select your average sleep time';
        isValid = false;
      }else{
        sleepError = null;
      }
    });
    return isValid;
  }

  void saveData(){
    widget.data.workIndex = selectedWork;
    widget.data.activeIndex = selectedActive;
    widget.data.sleepIndex = selectedSleep;
  }

  void _scrollToError(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  void handleNext(){
    final isValid = validateInput();
    if(!isValid){
      List<GlobalKey> errorKeys = [];
      if(workError != null) errorKeys.add(workKey);
      if(activeError != null) errorKeys.add(activeKey);
      if(sleepError != null) errorKeys.add(sleepKey);

      if(errorKeys.isNotEmpty) _scrollToError(errorKeys.first);
      return;
    }
    saveData();
    context.read<DataProvider>().updatePageThree(widget.data);
    widget.onNext();
  }

  @override
  void initState() {
    super.initState();
    selectedWork = widget.data.workIndex ?? -1;
    selectedActive = widget.data.activeIndex ?? -1;
    selectedSleep = widget.data.sleepIndex ?? -1;
  }
  
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page3,
              const SizedBox(width: 10,),
              Text('Your Daily Routine', style: th.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('This helps match your plan to your lifestyle', style: th.labelMedium,),
          const SizedBox(height: 20,),
          Text(key: workKey,'Work / Occupation type'),
          if(workError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(workError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Text('What is your everyday work?', style: th.labelSmall,),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedWork = 0;
                if(workError != null){
                  workError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: selectedWork != 0 ? ch.surface : CustomColors.primaryMuted(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: selectedWork == 0 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: ch.tertiary,
                      borderRadius: BorderRadius.circular(12),
                    ),child: Emoji.o1,
                ),
                title: Text('Sedentary'),
                subtitle: Text('desk job . student . driver'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedWork == 0 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedWork = 1;
                if(workError != null){
                  workError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedWork != 1 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedWork == 1 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.o2,
                ),
                title: Text('Moderately Active'),
                subtitle: Text('teacher . retail worker . nurse'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedWork == 1 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedWork = 2;
                if(workError != null){
                  workError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedWork != 2 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedWork == 2 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.o3,
                ),
                title: Text('Physically Active'),
                subtitle: Text('construction worker . farmer . athlete'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedWork == 2 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Text(key: activeKey,'Daily activity level'),
          if(activeError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(activeError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Text('How often do you exercise?', style: th.labelSmall,),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedActive = 0;
                if(activeError != null){
                  activeError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedActive != 0 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedActive == 0 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.a1,
                ),
                title: Text('Low'),
                subtitle: Text('rarely'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedActive == 0 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedActive = 1;
                if(activeError != null){
                  activeError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedActive != 1 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedActive == 1 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.a2,
                ),
                title: Text('Moderate'),
                subtitle: Text('2-4 days/week'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedActive == 1 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedActive = 2;
                if(activeError != null){
                  activeError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedActive != 2 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedActive == 2 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.a3,
                ),
                title: Text('High'),
                subtitle: Text('5-7 days/week'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedActive == 2 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Text(key: sleepKey,'Sleep Pattern'),
          if(sleepError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(sleepError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Text('How much sleep do you get everyday?', style: th.labelSmall,),
          const SizedBox(height: 10,),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedSleep = 0;
                    if(sleepError != null){
                      sleepError = null;
                    }
                  });
                },
                child: Container(
                  height: 70,
                  width: (MediaQuery.of(context).size.width - 80) / 4,
                  decoration: BoxDecoration(
                      color: selectedSleep != 0 ? ch.surface : CustomColors.primaryMuted(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selectedSleep == 0 ? ch.primary : Colors.transparent)
                  ),
                  child: Center(child: Text('< 5h')),
                ),
              ),
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedSleep = 1;
                    if(sleepError != null){
                      sleepError = null;
                    }
                  });
                },
                child: Container(
                  height: 70,
                  width: (MediaQuery.of(context).size.width - 80) / 4,
                  decoration: BoxDecoration(
                      color: selectedSleep != 1 ? ch.surface : CustomColors.primaryMuted(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selectedSleep == 1 ? ch.primary : Colors.transparent)
                  ),
                  child: Center(child: Text('5 - 7h')),
                ),
              ),
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedSleep = 2;
                    if(sleepError != null){
                      sleepError = null;
                    }
                  });
                },
                child: Container(
                  height: 70,
                  width: (MediaQuery.of(context).size.width - 80) / 4,
                  decoration: BoxDecoration(
                      color: selectedSleep != 2 ? ch.surface : CustomColors.primaryMuted(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selectedSleep == 2 ? ch.primary : Colors.transparent)
                  ),
                  child: Center(child: Text('7 - 9h')),
                ),
              ),
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedSleep = 3;
                    if(sleepError != null){
                      sleepError = null;
                    }
                  });
                },
                child: Container(
                  height: 70,
                  width: (MediaQuery.of(context).size.width - 80) / 4,
                  decoration: BoxDecoration(
                      color: selectedSleep != 3 ? ch.surface : CustomColors.primaryMuted(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selectedSleep == 3 ? ch.primary : Colors.transparent)
                  ),
                  child: Center(child: Text('9h +')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }
}

class SignupPageFourData{
  int? fitIndex;
  double? tdee;
  SignupPageFourData({
    this.fitIndex,
  });

  String get fitType{
    const types = ['Beginner', 'Intermediate', 'Advanced'];
    return types[fitIndex!];
  }
  double get fitFactor{
    const factors = [0.95, 1.0, 1.05];
    return factors[fitIndex!];
  }
}

class SignupPageFour extends StatefulWidget {
  final SignupPageFourData data;
  final VoidCallback onNext;
  const SignupPageFour({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageFour> createState() => _SignupPageFourState();
}

class _SignupPageFourState extends State<SignupPageFour> {
  final fitKey = GlobalKey();
  int selectedFit = -1;
  String? fitError;
  late Color? bmiColor;

  double? get previewTDEE{
    if(selectedFit == -1) return null;
    final data1 = context.read<DataProvider>().pageOne;
    final data3 = context.read<DataProvider>().pageThree;
    const factors = [0.95, 1.0, 1.05];
    return double.parse((data1.bmr! * data3.workFactor * data3.activeFactor * factors[selectedFit]).toStringAsFixed(1));
  }

  bool validateInput() {
   bool isValid = true;
   setState(() {
     if(selectedFit == -1){
       fitError = 'Select your fitness level';
       isValid = false;
     }else{
       fitError= null;
     }
   });
   return isValid;
  }

  void saveData(){
    widget.data.fitIndex = selectedFit;
    widget.data.tdee = previewTDEE;
  }
  void _scrollToError(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  void handleNext(){
    final isValid = validateInput();
    if(!isValid){
      if(fitError != null) _scrollToError(fitKey);
      return;
    }
    saveData();
    context.read<DataProvider>().updatePageFour(widget.data);
    widget.onNext();
  }

  @override
  void initState() {
    super.initState();
    selectedFit = widget.data.fitIndex ?? -1;
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final p = context.read<DataProvider>().pageOne;
    if(p.bmi! < 18.5){
      bmiColor = CustomColors.bluePrimary(context);
    }else if(p.bmi! < 25){
      bmiColor = CustomColors.greenPrimary(context);
    }else if(p.bmi! < 30){
      bmiColor = CustomColors.yellowPrimary(context);
    }else{
      bmiColor = CustomColors.redPrimary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data1 = context.read<DataProvider>().pageOne;
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page4,
              const SizedBox(width: 10,),
              Text('Your fitness experience', style: th.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('Tell us where you’re starting from.', style: th.labelMedium,),
          const SizedBox(height: 20,),
          Text(key: fitKey, 'Workout Level'),
          if(fitError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(fitError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Text('What is your current fitness ability?', style: th.labelSmall,),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedFit = 0;
                if(fitError != null){
                  fitError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedFit != 0 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedFit == 0 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.f1,
                ),
                title: Text('Beginner'),
                subtitle: Text('new to exercise'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedFit == 0 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedFit = 1;
                if(fitError != null){
                  fitError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedFit != 1 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedFit == 1 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.f2,
                ),
                title: Text('Intermediate'),
                subtitle: Text('Regular workouts'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedFit == 1 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedFit = 2;
                if(fitError != null){
                  fitError = null;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: selectedFit != 2 ? ch.surface : CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedFit == 2 ? ch.primary : Colors.transparent)
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ch.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),child: Emoji.f3,
                ),
                title: Text('Advanced'),
                subtitle: Text('Intense training'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedFit == 2 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          if(selectedFit != -1)
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.primaryMuted(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CustomColors.yellowOutline(context)),
                ),
                child: RichText(text: TextSpan(children: [
                  TextSpan(text: 'Based on your given data,\n\n', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(text: 'Your BMI is ', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(text: '${data1.bmi} - ${data1.category}.\n\n', style: TextStyle(color: bmiColor)),
                  TextSpan(text: 'Your body needs ', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(text: '${data1.bmr}', style: TextStyle(color: CustomColors.orangePrimary(context))),
                  TextSpan(text: ' calories at rest and total of ', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(text: '$previewTDEE', style: TextStyle(color: CustomColors.orangePrimary(context))),
                  TextSpan(text: ' calories are burnt in a day.\n\n', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(text: 'You belong to the age group ', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(text: '${data1.ageGroup}', style: TextStyle(color: CustomColors.bluePrimary(context))),
                ],),
                textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 5,),
              Text('See our recommendation next, or choose your own focus.', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
            ]),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }
}

const Map<String, Map<int, List<String>>> goalPreviews = {
  'Teen': {
    0: ['Get fit', 'Build stamina', 'Sport performance'],
    1: ['Build strength', 'Sport performance'],
    2: ['Improve flexibility', 'Sport mobility'],
    3: ['Core strength', 'Agility'],
    4: ['Healthy weight'],
    5: ['Active lifestyle', 'Better posture'],
    6: ['Safe training', 'Growth-stage nutrition'],
  },
  'Young Adult': {
    0: ['Get fit', 'Build stamina', 'Sport performance'],
    1: ['Build muscle', 'Bulk up', 'Sport performance'],
    2: ['Improve flexibility', 'Sport mobility'],
    3: ['Core strength', 'Agility'],
    4: ['Lose weight', 'Tone up', 'Cut & define'],
    5: ['Active lifestyle', 'Better posture'],
    6: ['Peak performance', 'Metabolic optimization'],
  },
  'Adult': {
    0: ['Build stamina', 'Sport performance'],
    1: ['Build muscle', 'Bulk up'],
    2: ['Improve flexibility', 'Posture & mobility'],
    3: ['Core strength', 'Injury prevention'],
    4: ['Lose weight', 'Tone up', 'Cut & define'],
    5: ['Functional fitness', 'Daily posture'],
    6: ['Hormonal health', 'Metabolic health'],
  },
  'Senior': {
    0: ['Stay active', 'Build stamina'],
    1: ['Stay strong', 'Lean muscle'],
    2: ['Improve flexibility', 'Posture & mobility'],
    3: ['Balance & stability', 'Injury prevention'],
    4: ['Healthy weight'],
    5: ['Functional fitness', 'Daily independence'],
    6: ['Bone density', 'Longevity & vitality'],
  },
};

class SignupPageFiveData{
  int? fundIndex;
  int? goalIndex;
  SignupPageFiveData({
    this.fundIndex,
    this.goalIndex,
  });

  String get fundType{
    const types = ['Energy & Fuel', 'Strength & build', 'Mobility & ease', 'Stability & control', 'Composition & vitals', 'Function & posture', 'Growth & adaptation'];
    return types[fundIndex!];
  }
}

class SignupPageFive extends StatefulWidget {
  final SignupPageFiveData data;
  final VoidCallback onNext;
  const SignupPageFive({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageFive> createState() => _SignupPageFiveState();
}

class _SignupPageFiveState extends State<SignupPageFive> {
  final goalKey = GlobalKey();
  late int selectedFund;
  int selectedGoal = -1;
  String? goalError;

  void selectFund (int f){
    setState(() {
      selectedFund = f;
      selectedGoal = -1;
      goalError = null;
    });
  }

  List<String> get currentGoals{
    final data = context.read<DataProvider>().pageOne;
    final group = data.ageGroup;
    return goalPreviews[group]?[selectedFund] ?? [];
  }

  void saveData(){
    widget.data.fundIndex = selectedFund;
    widget.data.goalIndex = selectedGoal;
  }
  bool validateInput(){
    bool isValid = true;
    setState(() {
      if(selectedGoal == -1){
        goalError = 'Select your goal to continue';
        isValid = false;
      }else{
        goalError = null;
      }
    });
    return isValid;
  }

  void _scrollToError(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  void handleNext(){
    final isValid = validateInput();
    if(!isValid){
      if(goalError != null) _scrollToError(goalKey);
      return;
    }
    saveData();
    context.read<DataProvider>().updatePageFive(widget.data);
    widget.onNext();
  }

  @override
  void initState() {
    super.initState();
    final rec = context.read<DataProvider>().finalRecommendation;
    selectedFund = widget.data.fundIndex ?? rec.code;
    selectedGoal = widget.data.goalIndex ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final rec = context.read<DataProvider>().finalRecommendation;
    final goals = currentGoals;

    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page5,
              const SizedBox(width: 10,),
              Column(children: [Text('What are your goals?', style: th.displaySmall,)]),
            ],
          ),
          const SizedBox(height: 10,),
          Text('We’ll use this to guide your plan', style: th.labelMedium,),
          const SizedBox(height: 20,),
          Text('Focus Area'),
          const SizedBox(height: 5,),
          Column(children: [Text('We have selected a starting point for you. Continue or choose yourself.', style: th.labelSmall,)]),
          const SizedBox(height: 10,),
          Row(
            children: [
              selectFundamental(context, 0, Emoji.fund1, 'Energy & Fuel'),
              const SizedBox(width: 10,),
              selectFundamental(context, 1, Emoji.fund2, 'Strength & build'),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              selectFundamental(context, 2, Emoji.fund3, 'Mobility & ease'),
              const SizedBox(width: 10,),
              selectFundamental(context, 3, Emoji.fund4, 'Stability & control'),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              selectFundamental(context, 4, Emoji.fund5, 'Composition & vitals'),
              const SizedBox(width: 10,),
              selectFundamental(context, 5, Emoji.fund6, 'Function & posture'),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
              children: [selectFundamental(context, 6, Emoji.fund7, 'Growth & adaptation'),
                const SizedBox(width: 10,),
                Expanded(child: const SizedBox(),),
              ],
          ),
          const SizedBox(height: 20,),
          Column(children: [
            RichText(text: TextSpan(children: [
              TextSpan(text: 'You are categorized as the ', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(text: '${rec.profile}.', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
            ],),),
          ]),
          Text(key: goalKey, 'Choose your goal to start', style: th.labelMedium,),
          if(goalError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(goalError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 10,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate((goals.length), (i){
              final isSelected = selectedGoal == i;
              return goalSelectionChip(goals[i], isSelected, i);
            }),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }

  Widget selectFundamental(BuildContext context, int select, Image icon, String label){
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
    final rec = context.read<DataProvider>().finalRecommendation;
    final isSelected = selectedFund == select;
    final isRecommended = rec.code == select;
    Color bgColor = ch.surface;
    Color borderColor = Colors.transparent;
    if(isSelected){
      bgColor = CustomColors.primaryMuted(context);
      borderColor = ch.primary;
    }else if(isRecommended){
      bgColor = CustomColors.yellowMuted(context);
      borderColor = Colors.transparent;
    }


    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectFund(select);
        },
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor,),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  const SizedBox(height: 5,),
                  Text(label, style: th.labelMedium,),
                  if(isRecommended && !isSelected)
                    Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Recommended', style: TextStyle(color: CustomColors.yellowOutline(context), fontSize: 10),)),
                  const SizedBox(height: 15,),
                  selectedFund == select ?
                  Icon(Icons.circle, color: ch.primary,) : Icon(Icons.circle_outlined),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget goalSelectionChip(String label, bool selected, int index){
    return ChoiceChip(
        label: Text(label),
        selected: selected,
      showCheckmark: false,
      avatar: Emoji.goal,
      onSelected: (select){
          setState(() {
            selectedGoal = select ? index : -1;
            if(select) goalError = null;
          });
      },
      selectedColor: CustomColors.primaryMuted(context),
      side: BorderSide(color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline),
      labelStyle: TextStyle(
        color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
        fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
      ),
    );
  }
}

class SignupPageSixData{
  List<int> styleIndex;
  int? equipIndex;
  int? placeIndex;
  int? dayIndex;
  int? durationIndex;
  List<int> timeIndex;
  List<int> freeIndex;

  SignupPageSixData({
    this.styleIndex = const [],
    this.equipIndex,
    this.placeIndex,
    this.dayIndex,
    this.durationIndex,
    this.timeIndex = const [],
    this.freeIndex = const [],
  });

  List<String> get styleType{
    const styles = ['Strength Training', 'Cardio', 'HIIT', 'Yoga & Stretching', 'Pilates', 'Calisthenics', 'Sports & Athletics', 'Functional Training', 'Low Impact', 'Any'];
    return styleIndex.map((i) => styles[i]).toList();
  }
  String get equipType{
    const equips = ['None', 'Minimal', 'Full Gym'];
    return equips[equipIndex!];
  }
  String get placeType{
    const places = ['Home', 'Gym', 'Outdoors', 'Any'];
    return places[placeIndex!];
  }
  String get dayType{
    const days = ['2', '3', '4', '5', '6'];
    return days[dayIndex!];
  }
  String get durationType{
    const durations = ['15-30 min', '30-45 min', '45-60 min', '60+ min'];
    return durations[durationIndex!];
  }
  List<String> get timeType{
    const times = ['Early Morning', 'Late Morning', 'Afternoon', 'Evening'];
    return timeIndex.map((i) => times[i]).toList();
  }
  List<String> get freeType{
    const frees = ['Son', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return freeIndex.map((i) => frees[i]).toList();
  }
}

class SignupPageSix extends StatefulWidget {
  final SignupPageSixData data;
  final VoidCallback onNext;
  const SignupPageSix({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageSix> createState() => _SignupPageSixState();
}

class _SignupPageSixState extends State<SignupPageSix> {
  final styleKey = GlobalKey();
  final equipKey = GlobalKey();
  final placeKey = GlobalKey();
  final dayKey = GlobalKey();
  final durationKey = GlobalKey();
  final timeKey = GlobalKey();
  Set<int> styleSelected = {};
  int equipSelected = -1;
  int placeSelected = -1;
  int daySelected = -1;
  int durationSelected = -1;
  Set<int> timeSelected = {};
  Set<int> freeSelected = {};
  String? styleError;
  String? equipError;
  String? placeError;
  String? dayError;
  String? durationError;
  String? timeError;

  void saveData(){
    widget.data.styleIndex = styleSelected.toList();
    widget.data.equipIndex = equipSelected;
    widget.data.placeIndex = placeSelected;
    widget.data.dayIndex = daySelected;
    widget.data.durationIndex = durationSelected;
    widget.data.timeIndex = timeSelected.toList();
    widget.data.freeIndex = freeSelected.toList();
  }
  bool validateInput(){
    bool isValid = true;
    setState(() {
      if(styleSelected.isEmpty){
        styleError = 'Please select your preferred style.';
        isValid = false;
      }else {
        styleError = null;
      }
      if(equipSelected == -1){
        equipError = 'Please choose your available equipment options.';
        isValid = false;
      }else {
        equipError = null;
      }
      if(placeSelected == -1){
        placeError = 'Please select where you plan to work out.';
        isValid = false;
      }else {
        placeError = null;
      }
      if(daySelected == -1){
        dayError = 'Please specify how many days you will work out per week.';
        isValid = false;
      }else {
        dayError = null;
      }
      if(durationSelected == -1){
        durationError = 'Please enter how long each workout session will be.';
        isValid = false;
      }else {
        durationError = null;
      }
      if(timeSelected.isEmpty){
        timeError = 'Please select your preferred workout times.';
        isValid = false;
      }else {
        timeError = null;
      }
    });
    return isValid;
  }

  void _scrollToError(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  void handleNext(){
    final isValid = validateInput();
    if(!isValid){
      List<GlobalKey> errorKeys = [];
      if(styleError != null) errorKeys.add(styleKey);
      if(equipError != null) errorKeys.add(equipKey);
      if(placeError != null) errorKeys.add(placeKey);
      if(dayError != null) errorKeys.add(dayKey);
      if(durationError != null) errorKeys.add(durationKey);
      if(timeError != null) errorKeys.add(timeKey);

      if(errorKeys.isNotEmpty) _scrollToError(errorKeys.first);
      return;
    }
    saveData();
    context.read<DataProvider>().updatePageSix(widget.data);
    widget.onNext();
  }

  @override
  void initState() {
    super.initState();
    styleSelected = (widget.data.styleIndex).toSet();
    equipSelected = widget.data.equipIndex ?? -1;
    placeSelected = widget.data.placeIndex ?? -1;
    daySelected = widget.data.dayIndex ?? -1;
    durationSelected = widget.data.durationIndex ?? -1;
    timeSelected = (widget.data.timeIndex).toSet();
    freeSelected = (widget.data.freeIndex).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page6,
              const SizedBox(width: 10,),
              Text('How do you like to train?', style: Theme.of(context).textTheme.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('Pick what fits your schedule and preferences', style: Theme.of(context).textTheme.labelMedium,),
          const SizedBox(height: 20,),
          Text('Training Style Preference', key: styleKey,),
          if(styleError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(styleError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              trainingStyle('Strength Training', Emoji.style1, 0),
              trainingStyle('Cardio', Emoji.style2, 1),
              trainingStyle('HIIT', Emoji.style3, 2),
              trainingStyle('Yoga & Stretching', Emoji.style4, 3),
              trainingStyle('Pilates', Emoji.style5, 4),
              trainingStyle('Calisthenics', Emoji.style6, 5),
              trainingStyle('Sports & Athletics', Emoji.style7, 6),
              trainingStyle('Functional Training', Emoji.style8, 7),
              trainingStyle('Low Impact', Emoji.style9, 8),
              trainingStyle('Mixed', Emoji.style10, 9),
            ],
          ),
          const SizedBox(height: 20,),
          Text('Equipment Access', key: equipKey,),
          if(equipError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(equipError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              equipChip('None', Emoji.e1, 0),
              equipChip('Minimal', Emoji.e2, 1),
              equipChip('Full Gym', Emoji.e3, 2),
            ],
          ),
          const SizedBox(height: 20,),
          Text('Location Preference', key: placeKey,),
          if(placeError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(placeError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              placeChip('Home', Emoji.place1, 0),
              placeChip('Gym', Emoji.place2, 1),
              placeChip('Outdoors', Emoji.place3, 2),
              placeChip('Any', Emoji.style10, 3),
            ],
          ),
          const SizedBox(height: 20,),
          Text('Workout days per week', key: dayKey,),
          if(dayError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(dayError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              dayChip('2', 0),
              dayChip('3', 1),
              dayChip('4', 2),
              dayChip('5', 3),
              dayChip('6', 4),
            ],
          ),
          const SizedBox(height: 20,),
          Text('Session Duration', key: durationKey,),
          if(durationError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(durationError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              timeChip('15-30 min', 0),
              timeChip('30-45 min', 1),
              timeChip('45-60 min', 2),
              timeChip('60+ min', 3),
            ],
          ),
          const SizedBox(height: 20,),
          Text('Session time', key: timeKey,),
          if(timeError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(timeError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              sessionChip('Early Morning', Emoji.s1, 0),
              sessionChip('Late Morning', Emoji.s2, 1),
              sessionChip('Afternoon', Emoji.s3, 2),
              sessionChip('Evening', Emoji.s4, 3),
            ],
          ),
          const SizedBox(height: 20,),
          Text('Your Free Days'),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              freeChip('Son', 0),
              freeChip('Mon', 1),
              freeChip('Tue', 2),
              freeChip('Wed', 3),
              freeChip('Thu', 4),
              freeChip('Fri', 5),
              freeChip('Sat', 6),
            ],
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }

  Widget trainingStyle(String label, Image avatar, int value){
    return FilterChip(
        label: Text(label),
        showCheckmark: false,
        avatar: avatar,
        selected: styleSelected.contains(value),
      onSelected: (selected){
          setState(() {
            if(selected){
              styleSelected.add(value);
              if(styleError != null){
                styleError = null;
              }
            }else{
              styleSelected.remove(value);
            }
          });
      },
    );
  }
  Widget equipChip(String label, Image avatar, int value){
    return ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      avatar: avatar,
      selected: equipSelected == value,
      onSelected: (selected){
        setState(() {
          equipSelected = selected ? value : -1;
          if(equipError != null){
            equipError = null;
          }
        });
      },
    );
  }
  Widget placeChip(String label, Image avatar, int value){
    return ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      avatar: avatar,
      selected: placeSelected == value,
      onSelected: (selected){
        setState(() {
          placeSelected = selected ? value : -1;
          if(placeError != null){
            placeError = null;
          }
        });
      },
    );
  }
  Widget dayChip(String label, int value){
    return ChoiceChip(
      label: Text(label),
      selected: daySelected == value,
      onSelected: (selected){
        setState(() {
          daySelected = selected ? value : -1;
          if(dayError != null){
            dayError = null;
          }
        });
      },
    );
  }
  Widget timeChip(String label, int value){
    return ChoiceChip(
      label: Text(label),
      selected: durationSelected == value,
      onSelected: (selected){
        setState(() {
          durationSelected = selected ? value : -1;
          if(durationError != null){
            durationError = null;
          }
        });
      },
    );
  }
  Widget sessionChip(String label, Image avatar, int value){
    return FilterChip(
      showCheckmark: false,
      label: Text(label),
      avatar: avatar,
      selected: timeSelected.contains(value),
      onSelected: (selected){
        setState(() {
          if(selected){
           timeSelected.add(value);
           if(timeError != null){
             timeError = null;
           }
          }else{
            timeSelected.remove(value);
          }
        });
      },
    );
  }
  Widget freeChip(String label, int value){
    return ChoiceChip(
      label: Text(label),
      selected: freeSelected.contains(value),
      onSelected: (selected){
        setState(() {
          if(selected){
            freeSelected.add(value);
          }else{
            freeSelected.remove(value);
          }
        });
      },
    );
  }
}

class SignupPageSevenData{
  int? mealIndex;
  int? dietIndex;
  bool isHalal;
  List<int> regionIndex;
  List<String> selectedAllergens = [];

  SignupPageSevenData({
    this.mealIndex,
    this.dietIndex,
    this.isHalal = false,
    this.regionIndex = const [],
    List<String>? selectedAllergens,
  }) : selectedAllergens = selectedAllergens ?? [];

  String get mealType{
    const meals = ['2 meals/day', '3 meals/day', '4 meals/day', '5+ meals/day'];
    return meals[mealIndex!];
  }
  String get dietType{
    const diets = ['Omnivore', 'Vegetarian', 'Vegan', 'Pescatarian', 'Paleo', 'Keto'];
    return diets[dietIndex!];
  }
  List<String> get regionType{
    const regions = ['South Asian', 'East Asian', 'Southeast Asian', 'Middle Eastern', 'Mediterranean', 'East African', 'North African', 'Western', 'No preference'];
    return regionIndex.map((i) => regions[i]).toList();
  }
}

class SignupPageSeven extends StatefulWidget {
  final SignupPageSevenData data;
  final VoidCallback onNext;
  const SignupPageSeven({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageSeven> createState() => _SignupPageSevenState();
}

class _SignupPageSevenState extends State<SignupPageSeven> {
  final mealKey = GlobalKey();
  final dietKey = GlobalKey();
  int? meal;
  int? diet;
  Set<int> region = {};
  bool isHalal = false;
  String? mealError;
  String? dietError;

  void saveData(){
    widget.data.mealIndex = meal;
    widget.data.dietIndex = diet;
    widget.data.isHalal = isHalal;
    widget.data.regionIndex = region.isEmpty ? [8] : region.toList();
  }

  bool validateInput(){
    bool isValid = true;
    setState(() {
      if(meal == null){
        mealError = 'Please select how many meals you want to take a day.';
        isValid = false;
      }else{
        mealError = null;
      }
      if(diet == null){
        dietError = 'Please select your preferred diet type';
        isValid = false;
      }else{
        dietError = null;
      }
    });
    return isValid;
  }

  void _scrollToError(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  void handleNext(){
    final isValid = validateInput();
    if(!isValid){
      List<GlobalKey> errorKeys = [];
      if(mealError != null) errorKeys.add(mealKey);
      if(dietError != null) errorKeys.add(dietKey);

      if(errorKeys.isNotEmpty) _scrollToError(errorKeys.first);
      return;
    }
    saveData();
    context.read<DataProvider>().updatePageSeven(widget.data);
    widget.onNext();
  }

  @override
  void initState() {
    super.initState();
    meal = widget.data.mealIndex;
    diet = widget.data.dietIndex;
    isHalal = widget.data.isHalal;
    region = widget.data.regionIndex.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page7,
              const SizedBox(width: 10,),
              Text('Your Eating Habits', style: Theme.of(context).textTheme.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('Help us shape a plan that works for you', style: Theme.of(context).textTheme.labelMedium,),
          const SizedBox(height: 20,),
          Text('Meals per day', key: mealKey,),
          if(mealError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(mealError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              mealChip('2', 0),
              mealChip('3', 1),
              mealChip('4', 2),
              mealChip('5+', 3),
            ],
          ),
          const SizedBox(height: 20,),
          Text('Your Diet Preference', key: dietKey,),
          if(dietError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(dietError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              dietChip('Omnivore', Emoji.omni, 0),
              dietChip('Vegetarian', Emoji.veg, 1),
              dietChip('Vegan', Emoji.vegan, 2),
              dietChip('Pescatarian', Emoji.fish, 3),
              dietChip('Paleo', Emoji.paleo, 4),
              dietChip('Keto', Emoji.keto, 5),
            ],
          ),
          const SizedBox(height: 5,),
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('Halal'), const SizedBox(width: 10,), Icon(Symbols.prayer_times_rounded)]),
              value: isHalal,
              onChanged: (bool? value){
                setState(() {
                  isHalal = value!;
                });
              }
          ),
          const SizedBox(height: 5,),
          Text('Your Regional Preference for food'),
          const SizedBox(height: 5,),
          Text('This\'ll be suggested to you more', style: th.labelSmall,),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              regionChip('South Asian', Symbols.temple_hindu_rounded, 0),
              regionChip('East Asian', Symbols.temple_buddhist_rounded, 1),
              regionChip('Southeast Asian', Symbols.forest_rounded, 2),
              regionChip('Middle Eastern', Symbols.mosque_rounded, 3),
              regionChip('Mediterranean', Symbols.waves_rounded, 4),
              regionChip('East African', Symbols.landscape_2_rounded, 5),
              regionChip('North African', Symbols.sunny_rounded, 6),
              regionChip('Western', Symbols.account_balance_rounded, 7),
              regionChip('No preference', Symbols.all_inclusive_rounded, 8),
            ],
          ),
          const SizedBox(height: 20,),
          Row(children: [
            Icon(Symbols.allergies_rounded),
            const SizedBox(width: 10,),
            Text('Your Allergies'),
          ],),
          const SizedBox(height: 5,),
          AllergenChips(),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }
  Widget mealChip(String label, int value){
    return ChoiceChip(
      label: Text(label),
      selected: meal == value,
      onSelected: (selected){
        setState(() {
          meal = selected ? value : null;
          if(mealError != null){
            mealError = null;
          }
        });
      },
    );
  }
  Widget dietChip(String label, Image avatar, int value){
    return ChoiceChip(
      label: Text(label),
      selected: diet == value,
      showCheckmark: false,
      avatar: avatar,
      onSelected: (selected){
        setState(() {
          diet = selected ? value : null;
          if(dietError != null){
            dietError = null;
          }
        });
      },
    );
  }
  Widget regionChip(String label, IconData icon, int value){
    return FilterChip(
      label: Text(label),
      selected: region.contains(value),
      showCheckmark: false,
      avatar: Icon(icon),
      onSelected: (selected){
        setState(() {
          const noPreferenceValue = 8;
          if(value == noPreferenceValue){
            if(selected){
              region.clear();
              region.add(noPreferenceValue);
            }else{
              region.remove(noPreferenceValue);
            }
          }else{
            if(selected){
              region.add(value);
              region.remove(noPreferenceValue);
            }else{
              region.remove(value);
            }
          }
          final allSelected = List.generate(8, (i) => i).every((i) => region.contains(i));
          if(allSelected){
            region.clear();
            region.add(noPreferenceValue);
          }
        });
      },
    );
  }
}

class SignupPageEightData{
  List<String> selectedIntolerances = [];
  List<String> selectedDislikes = [];

  SignupPageEightData({
    List<String>? selectedIntolerances,
    List<String>? selectedDislikes,
  }) :  selectedIntolerances = selectedIntolerances ?? [],
        selectedDislikes = selectedDislikes ?? [];
}

class SignupPageEight extends StatefulWidget {
  final SignupPageEightData data;
  final VoidCallback onNext;
  const SignupPageEight({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageEight> createState() => _SignupPageEightState();
}

class _SignupPageEightState extends State<SignupPageEight> {
  void handleNext(){
    widget.onNext();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page8,
              const SizedBox(width: 10,),
              Text('Foods you want to Avoid', style: Theme.of(context).textTheme.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('We’ll leave these out of your plan', style: Theme.of(context).textTheme.labelMedium,),
          const SizedBox(height: 20,),
          Row(children: [
            Icon(Symbols.gastroenterology_rounded),
            const SizedBox(width: 10,),
            Text('Your Intolerances'),
          ],),
          const SizedBox(height: 5,),
          IntoleranceChips(),
          const SizedBox(height: 15,),
          Row(children: [
            Icon(Symbols.sentiment_dissatisfied_rounded),
            const SizedBox(width: 10,),
            Text('Your dislikes'),
          ],),
          const SizedBox(height: 5,),
          DislikedChips(),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }
}

class SignupPageNineData{
  String? username;
  String? password;
  String? phone;
  String? address;
  String? googleId;
  String? appleId;
  SignupPageNineData({
    this.username,
    this.password,
    this.phone,
    this.address,
    this.googleId,
    this.appleId,
  });

  bool get isGoogleLinked => googleId != null;
  bool get isAppleLinked => appleId != null;
  bool get hasLinked => isGoogleLinked || isAppleLinked;
}

class SignupPageNine extends StatefulWidget {
  final SignupPageNineData data;
  final VoidCallback onNext;
  const SignupPageNine({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageNine> createState() => _SignupPageNineState();
}

class _SignupPageNineState extends State<SignupPageNine> {
  final userKey = GlobalKey();
  final passKey = GlobalKey();
  final confirmKey = GlobalKey();
  final linkKey = GlobalKey();
  bool isLoading = false;
  late SignupPageNineData data;
  bool isHiddenOne = true;
  bool isHiddenTwo = true;
  String selectedCode = '+880';

  final List<Map<String, String>> codes = [
    {'name': 'BAN', 'code': '+880'},
    {'name': 'US', 'code': '+1'},
    {'name': 'UK', 'code': '+44'},
    {'name': 'IN', 'code': '+91'},
    {'name': 'CAN', 'code': '+1'},
    {'name': 'AUS', 'code': '+61'},
    {'name': 'GER', 'code': '+49'},
    {'name': 'FRA', 'code': '+33'},
    {'name': 'UAE', 'code': '+971'},
    {'name': 'SAU', 'code': '+966'},
  ];

  String? usernameError;
  String? passwordError;
  String? confirmError;
  String? linkError;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void saveData(){
    data.username = usernameController.text.trim();
    data.password = passwordController.text;
    final phone = phoneController.text.trim();
    data.phone = phone.isNotEmpty ? '$selectedCode$phone' : null;
    data.address = addressController.text.trim();
  }

  Future<bool> validateInput() async{
    bool isValid = true;
    setState(() {
      final u = usernameController.text.trim();
      if(u.isEmpty){
        usernameError = 'Username is required';
        isValid = false;
      }else if(!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(u)){
        usernameError = 'Only letters, numbers and underscore';
        isValid = false;
      }else{
        usernameError = null;
      }

      if(passwordController.text.isEmpty){
        passwordError = 'Password is required';
        isValid = false;
      }else if(passwordController.text.length < 8){
        passwordError = 'At least 8 characters';
        isValid = false;
      }else{
        passwordError = null;
      }

      if(confirmController.text.isEmpty){
        confirmError = 'Please confirm your password';
        isValid = false;
      }else if(confirmController.text != passwordController.text){
        confirmError = 'Passwords do not match';
        isValid = false;
      }else{
        confirmError = null;
      }
      if(!kIsWeb && !data.hasLinked){
        linkError = 'Link at least one account to continue';
        isValid = false;
      }else{
        linkError = null;
      }
    });
    if(isValid){
      final username = usernameController.text.trim();
      final existing = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).limit(1).get();
      if(existing.docs.isNotEmpty){
        setState(() {
          usernameError = 'Username already taken';
        });
        isValid = false;
      }
    }
    return isValid;
  }

  void _scrollToError(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  void handleNext() async{
    setState(() => isLoading = true);
    final isValid = await validateInput();
    if(!mounted) return;
    if(!isValid){
      setState(() => isLoading = false);
      List<GlobalKey> errorKeys = [];
      if(usernameError != null) errorKeys.add(userKey);
      if(passwordError != null) errorKeys.add(passKey);
      if(confirmError != null) errorKeys.add(confirmKey);
      if(linkError != null) errorKeys.add(linkKey);

      if(errorKeys.isNotEmpty){
        WidgetsBinding.instance.addPostFrameCallback((_){
          _scrollToError(errorKeys.first);
        });
      }
      return;
    }
    showDialog(context: context, builder: (context){
      return Center(
        child: CircularProgressIndicator(),
      );
    });
    saveData();
    if(!mounted) return;
    context.read<DataProvider>().updatePageNine(data);
    Navigator.pop(context);
    widget.onNext();
  }

  Future<void> _linkGoogle() async{
    try{
      final googleUser = await GoogleSignIn.instance.authenticate();
      final existing = await FirebaseFirestore.instance.collection('users').where('googleId',isEqualTo: googleUser.id).limit(1).get();
      if(existing.docs.isNotEmpty){
        await GoogleSignIn.instance.signOut();
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This Google account is already linked to another user')));
        }
        return;
      }

      setState(() {
        data.googleId = googleUser.id;
        linkError = null;
      });
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
      }
    }
  }

  Future<void> _unlinkGoogle() async{
    final confirm = await _showUnlinkDialog('Google');
    if(!confirm) return;
    if(kIsWeb){
      await GoogleSignIn.instance.signOut();
    }
    setState(() {
      data.googleId = null;
      if(!data.hasLinked) linkError = 'Link at least one account to continue';
    });
  }

  Future<void> _linkApple() async{
    try{
      final appleCredential = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email]);
      final existing = await FirebaseFirestore.instance.collection('users').where('appleId', isEqualTo: appleCredential.userIdentifier).limit(1).get();

      if(existing.docs.isNotEmpty){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This Apple account is already linked to another user')));
        }
        return;
      }

      setState(() {
        data.appleId = appleCredential.userIdentifier;
        linkError = null;
      });
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Apple sign-in failed: $e')));
      }
    }
  }

  Future<void> _unlinkApple() async{
    final confirm = await _showUnlinkDialog('Apple');
    if(!confirm) return;
    setState(() {
      data.appleId = null;
      if(!data.hasLinked) linkError = 'Link at least one account to continue';
    });
  }

  Future<bool> _showUnlinkDialog(String provider) async{
    return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Unlink $provider'),
          content: Text('This will remove your $provider connection.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Unlink')),
          ],
        )
    ) ?? false;
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;

    usernameController.text = data.username ?? '';
    passwordController.text = data.password ?? '';
    confirmController.text = data.password ?? '';
    addressController.text = data.address ?? '';
    if(data.phone != null){
      final allCodes = codes.map((c) => c['code']!).toList();
      allCodes.sort((a, b) => b.length.compareTo(a.length));
      final matchedCode = allCodes.firstWhere((code) => data.phone!.startsWith(code), orElse: () => '+880');
      selectedCode = matchedCode;
      phoneController.text = data.phone!.substring(matchedCode.length);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Emoji.page9,
                const SizedBox(width: 10,),
                Text('Create Your Account', style: Theme.of(context).textTheme.displaySmall,),
              ],
            ),
            const SizedBox(height: 10,),
            Text('Save your progress and access your plan anytime', style: Theme.of(context).textTheme.labelMedium,),
            const SizedBox(height: 20,),
            TextField(
              key: userKey,
              controller: usernameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                labelText: 'Username',
                helperText: '*Use letters, numbers and underscore',
                errorText: usernameError,
              ),
              onChanged: (_){
                setState(() {
                  if(usernameError != null){
                    usernameError = null;
                  }
                });
              },
            ),
            const SizedBox(height: 20,),
            TextField(
              key: passKey,
              controller: passwordController,
              obscureText: isHiddenOne,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded),
                labelText: 'Password',
                helperText: '*At least 8 characters',
                errorText: passwordError,
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      isHiddenOne = !isHiddenOne;
                    });
                  }, icon: isHiddenOne ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off_rounded),
                ),
              ),
              onChanged: (_){
                setState(() {
                  if(passwordError != null){
                    passwordError = null;
                  }
                });
              },
            ),
            const SizedBox(height: 20,),
            TextField(
              key: confirmKey,
              controller: confirmController,
              obscureText: isHiddenTwo,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_clock_outlined),
                labelText: 'Confirm Password',
                errorText: confirmError,
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      isHiddenTwo = !isHiddenTwo;
                    });
                  }, icon: isHiddenTwo ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off_rounded),
                ),
              ),
              onChanged: (_){
                setState(() {
                  if(confirmError != null){
                    confirmError = null;
                  }
                });
              },
            ),
            const SizedBox(height: 20,),
            Row(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                      SizedBox(
                      height: 56,
                      width: 90,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: countryCode(context),
                      )),
                  const SizedBox(height: 18,),
                    ],
              ),
              const SizedBox(width: 8,),
              Expanded(child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone no',
                  hintText: 'XXXXXXXXXX',
                  helperText: '*Optional',
                ),
              ))]),
            const SizedBox(height: 20,),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
                labelText: 'Address',
                helperText: '*Optional',
              ),
            ),
            const SizedBox(height: 20,),
            Text('Link with your Google or Apple id', key: linkKey,),
            if(linkError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(linkError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 10,),
            FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface
                ),
                onPressed: data.isGoogleLinked ? _unlinkGoogle : _linkGoogle,child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                  children: [
                   Emoji.google,
                    Expanded(child: Center(child: Text( data.isGoogleLinked ? 'Google Connected . Unlink' : 'Connect with Google', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),))),
                    data.isGoogleLinked ?
                    Icon(Icons.check_circle_outline, size: 24, color: CustomColors.greenPrimary(context),) : const SizedBox(height: 24, width: 24,),
                  ],
                ),
            )),
            const SizedBox(height: 20,),
            FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface
                ),
                onPressed: data.isAppleLinked ? _unlinkApple : _linkApple, child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                  children: [
                    Emoji.apple,
                    Expanded(child: Center(child: Text(data.isAppleLinked ? 'Apple Connected . Unlink' : 'Connect with Apple', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),))),
                    data.isAppleLinked ?
                    Icon(Icons.check_circle_outline, size: 24, color: CustomColors.greenPrimary(context),) : const SizedBox(height: 24, width: 24,),
                  ],
                ),
            )),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: handleNext,
                child: Text("Next",),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget countryCode(BuildContext context){
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(10),
              isDense: true,
              elevation: 0,
                style: Theme.of(context).textTheme.bodyMedium,
                value: selectedCode,
                items: codes.map<DropdownMenuItem<String>>((country){
                  return DropdownMenuItem<String>(
                  value: country['code'],
                    child: Text('${country['name']} (${country['code']})'),
                  );
            }).toList(),
                onChanged: (String? newCode) {
                  setState(() {
                    selectedCode = newCode!;
                  });
                },
              selectedItemBuilder: (BuildContext context){
                  return codes.map<Widget>((country){
                    return Text(country['code']!);
                  }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPageTenData{

}

class SignupPageTen extends StatefulWidget {
  final SignUpPageTenData data;
  final VoidCallback onNext;
  const SignupPageTen({super.key, required this.data, required this.onNext});

  @override
  State<SignupPageTen> createState() => _SignupPageTenState();
}

class _SignupPageTenState extends State<SignupPageTen> {
  late bool unitIsMetric;
  late bool notificationsIsOn;

  void handleNext(){

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page10,
              const SizedBox(width: 10,),
              Text('Your Plan is Ready', style: Theme.of(context).textTheme.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('Review your details and see your personalized setup', style: Theme.of(context).textTheme.labelMedium,),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: handleNext,
              child: Text("Next",),
            ),
          ),
        ],),
      ),
    );
  }
}
