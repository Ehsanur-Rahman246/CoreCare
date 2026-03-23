import 'package:core_care/main.dart';
import 'package:core_care/tags.dart';
import 'package:flutter/material.dart';
import 'package:core_care/decoration.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

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
}

class SignupPageOne extends StatefulWidget {
  final SignupPageOneData data;
  const SignupPageOne({super.key, required this.data});

  @override
  State<SignupPageOne> createState() => _SignupPageOneState();
}

class _SignupPageOneState extends State<SignupPageOne> {
  late SignupPageOneData data;
  String? nameError;
  String? dobError;
  String? genderError;
  String? heightError;
  String? weightError;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  double? getHeight(){
    return double.tryParse(heightController.text);
  }
  double? getWeight(){
    return double.tryParse(weightController.text);
  }

  double toHeightCm(double value, bool isFt){
    return isFt ? value * 30.48 : value;
  }

  double toWeightKg(double value, bool isKg){
    return isKg ? value : value * 0.453592;
  }

  DateTime? selectedDate;
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
  int calculateAge(DateTime dob){
    final today = DateTime.now();
    int age = today.year - dob.year;
    if(today.month < dob.month || (today.month == dob.month && today.day < dob.day)){
      age--;
    }
    return age;
  }

  String getAgeGroup(int age){
    if(age < 13) return 'Child';
    if(age < 18) return 'Teen';
    if(age < 30) return 'Young Adult';
    if(age < 60) return 'Adult';
    return 'Senior';
  }

  int? genderSelected;
  void selectGender(int g){
    setState(() {
      genderSelected = g;
    });
  }

  bool isHeightUnitOne = true;
  bool isWeightUnitOne = true;

  double calculateBMI(double h, double w){
    final height = h / 100;
    return w / (height * height);
  }
  double calculateBMR(double h, double w, int age, int gender){
    final base = (10 * w) + (6.25 * h) - (5 * age);
    return gender == 1 ? base + 5 : base - 161;
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

    final h = data.height;
    final w = data.weight;
    final dob = data.dob;
    final gender = data.gender;

    if(h != null && w != null && dob != null && gender != null){
      final heightCm = toHeightCm(h, data.isHeightFt);
      final weightKg = toWeightKg(w, data.isWeightKg);
      final age = calculateAge(dob);
      data.age = age;
      data.bmi = double.parse(calculateBMI(heightCm, weightKg).toStringAsFixed(1));
      data.bmr = double.parse(calculateBMR(heightCm, weightKg, age, gender).toStringAsFixed(1));
      data.ageGroup = getAgeGroup(age);
     }
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
    super.dispose();
    nameController.dispose();
    dateController.dispose();
    heightController.dispose();
    weightController.dispose();
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
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person_rounded),
            errorText: nameError,
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            prefixIcon: Icon(Icons.calendar_month_outlined),
            errorText: dobError,
          ),
          onTap: pickDate,
        ),
        const SizedBox(height: 20,),
        Text('Gender'),
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
        const SizedBox(height: 5,),
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
                controller: heightController,
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
                controller: weightController,
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
        const SizedBox(height: 20,),
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
  const SignupPageTwo({super.key, required this.data});

  @override
  State<SignupPageTwo> createState() => _SignupPageTwoState();
}

class _SignupPageTwoState extends State<SignupPageTwo> {
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
          const SizedBox(height: 20,),
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
}

class SignupPageThree extends StatefulWidget {
  final SignupPageThreeData data;
  const SignupPageThree({super.key, required this.data});

  @override
  State<SignupPageThree> createState() => _SignupPageThreeState();
}

class _SignupPageThreeState extends State<SignupPageThree> {
  int selectedWork = -1;
  int selectedActive = -1;
  int selectedSleep = -1;

  bool validateInput(){
    bool isValid = true;
    setState(() {
      if(selectedWork == -1) isValid = false;
      if(selectedActive == -1) isValid = false;
      if(selectedSleep == -1) isValid = false;
    });
    return isValid;
  }

  void saveData(){
    widget.data.workIndex = selectedWork;
    widget.data.activeIndex = selectedActive;
    widget.data.sleepIndex = selectedSleep;
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
          Text('Work / Occupation type'),
          const SizedBox(height: 5,),
          Text('What is your everyday work?', style: th.labelSmall,),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedWork = 0;
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
          Text('Daily activity level'),
          const SizedBox(height: 5,),
          Text('How often do you exercise?', style: th.labelSmall,),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedActive = 0;
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
          Text('Sleep Pattern'),
          const SizedBox(height: 5,),
          Text('How much sleep do you get everyday?', style: th.labelSmall,),
          const SizedBox(height: 10,),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedSleep = 0;
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
          const SizedBox(height: 20,),
        ],),
      ),
    );
  }
}

class SignupPageFourData{}

class SignupPageFour extends StatefulWidget {
  final SignupPageFourData data;
  const SignupPageFour({super.key, required this.data});

  @override
  State<SignupPageFour> createState() => _SignupPageFourState();
}

class _SignupPageFourState extends State<SignupPageFour> {
  int selectedFit = -1;
  bool selectionFinal = false;

  @override
  Widget build(BuildContext context) {
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
          Text('Fitness Level'),
          const SizedBox(height: 5,),
          Text('What is your current fitness ability?', style: th.labelSmall,),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedFit = 0;
                selectionFinal = true;
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
                  ),child: Emoji.o1,
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
                selectionFinal = true;
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
                  ),child: Emoji.o2,
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
                selectionFinal = true;
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
                  ),child: Emoji.o3,
                ),
                title: Text('Advanced'),
                subtitle: Text('Intense training'),
                subtitleTextStyle: th.labelMedium,
                trailing: selectedFit == 2 ? Icon(Icons.check) : SizedBox(),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          if(selectionFinal)
            Text('Based on your data, we recommend you to choose this goal. Go to next page to choose.'),
        ],),
      ),
    );
  }
}

class SignupPageFiveData{}

class SignupPageFive extends StatefulWidget {
  final SignupPageFiveData data;
  const SignupPageFive({super.key, required this.data});

  @override
  State<SignupPageFive> createState() => _SignupPageFiveState();
}

class _SignupPageFiveState extends State<SignupPageFive> {
  int selectedFund = -1;
  bool hasFundSelected = false;
  bool isRecommended = false;

  void selectFund (int f){
    setState(() {
      selectedFund = f;
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;

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
          Text('Select your starting point', style: th.labelSmall,),
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
              selectFundamental(context, 4, Emoji.fund5, ' Composition & vitals'),
              const SizedBox(width: 10,),
              selectFundamental(context, 5, Emoji.fund6, 'Function & posture'),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
              children: [selectFundamental(context, 6, Emoji.fund7, 'Growth & adaptation '),
                const SizedBox(width: 10,),
                Expanded(child: const SizedBox(),),
              ],
          ),
          const SizedBox(height: 20,),
          if(hasFundSelected)
          Text('Now choose your goal'),
          const SizedBox(height: 10,),
        ],),
      ),
    );
  }

  Widget selectFundamental(BuildContext context, int select, Image icon, String label){
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectFund(select);
          hasFundSelected = true;
        },
        child: Container(
          decoration: BoxDecoration(
            color: selectedFund != select ? ch.surface : CustomColors.primaryMuted(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selectedFund == select ? ch.primary : Colors.transparent),
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
}

class SignupPageSixData{}

class SignupPageSix extends StatefulWidget {
  final SignupPageSixData data;
  const SignupPageSix({super.key, required this.data});

  @override
  State<SignupPageSix> createState() => _SignupPageSixState();
}

class _SignupPageSixState extends State<SignupPageSix> {
  int? styleSelected;
  int? equipSelected;
  int? placeSelected;
  int? daySelected;
  int? timeSelected;
  int? durationSelected;
  int? freeSelected;

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
          Text('Training Style Preference'),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              trainingStyle('Strength Training', Emoji.o1, 0),
              trainingStyle('Cardio', Emoji.o1, 1),
              trainingStyle('HIIT', Emoji.o1, 2),
              trainingStyle('Yoga & Stretching', Emoji.o1, 3),
              trainingStyle('Pilates', Emoji.o1, 4),
              trainingStyle('Calisthenics', Emoji.o1, 5),
              trainingStyle('Sports & Athletics', Emoji.o1, 6),
              trainingStyle('Functional Training', Emoji.o1, 7),
              trainingStyle('Low Impact', Emoji.o1, 8),
              trainingStyle('Any', Emoji.o1, 9),
            ],
          ),
          const SizedBox(height: 15,),
          Text('Equipment Access'),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: Text('None'),
                showCheckmark: false,
                avatar: Emoji.o1,
                selected: equipSelected == 0,
                onSelected: (selected){
                  setState(() {
                    equipSelected = selected ? 0 : null;
                  });
                },
              ),
              ChoiceChip(
                label: Text('Minimal'),
                showCheckmark: false,
                avatar: Emoji.o1,
                selected: equipSelected == 1,
                onSelected: (selected){
                  setState(() {
                    equipSelected = selected ? 1 : null;
                  });
                },
              ),
              ChoiceChip(
                label: Text('Full Gym'),
                showCheckmark: false,
                avatar: Emoji.o1,
                selected: equipSelected == 2,
                onSelected: (selected){
                  setState(() {
                    equipSelected = selected ? 2 : null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Text('Location Preference'),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: Text('Home'),
                showCheckmark: false,
                avatar: Emoji.o1,
                selected: placeSelected == 0,
                onSelected: (selected){
                  setState(() {
                    placeSelected = selected ? 0 : null;
                  });
                },
              ),
              ChoiceChip(
                label: Text('Gym'),
                showCheckmark: false,
                avatar: Emoji.o1,
                selected: placeSelected == 1,
                onSelected: (selected){
                  setState(() {
                    placeSelected = selected ? 1 : null;
                  });
                },
              ),
              ChoiceChip(
                label: Text('Outdoors'),
                showCheckmark: false,
                avatar: Emoji.o1,
                selected: placeSelected == 2,
                onSelected: (selected){
                  setState(() {
                    placeSelected = selected ? 2 : null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Text('Workout days per week'),
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
          const SizedBox(height: 15,),
          Text('Session Time'),
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
          const SizedBox(height: 15,),
          Text('Session Duration'),
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
          const SizedBox(height: 15,),
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
          const SizedBox(height: 20,),
        ],),
      ),
    );
  }

  Widget trainingStyle(String label, Image avatar, int value){
    return ChoiceChip(
        label: Text(label),
        showCheckmark: false,
        avatar: avatar,
        selected: styleSelected == value,
      onSelected: (selected){
          setState(() {
            styleSelected = selected ? value : null;
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
          daySelected = selected ? value : null;
        });
      },
    );
  }
  Widget timeChip(String label, int value){
    return ChoiceChip(
      label: Text(label),
      selected: timeSelected == value,
      onSelected: (selected){
        setState(() {
          timeSelected = selected ? value : null;
        });
      },
    );
  }
  Widget sessionChip(String label, Image avatar, int value){
    return ChoiceChip(
      showCheckmark: false,
      label: Text(label),
      avatar: avatar,
      selected: durationSelected == value,
      onSelected: (selected){
        setState(() {
          durationSelected = selected ? value : null;
        });
      },
    );
  }
  Widget freeChip(String label, int value){
    return ChoiceChip(
      label: Text(label),
      selected: freeSelected == value,
      onSelected: (selected){
        setState(() {
          freeSelected = selected ? value : null;
        });
      },
    );
  }
}

class SignupPageSevenData{}

class SignupPageSeven extends StatefulWidget {
  final SignupPageSevenData data;
  const SignupPageSeven({super.key, required this.data});

  @override
  State<SignupPageSeven> createState() => _SignupPageSevenState();
}

class _SignupPageSevenState extends State<SignupPageSeven> {
  int? meal;
  int? diet;
  int? region;
  bool isHalal = false;

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
          Text('Meals per day'),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: Text('2'),
                selected: meal == 0,
                onSelected: (selected){
                  setState(() {
                    meal = selected ? 0 : null;
                  });
                },
              ),
              ChoiceChip(
                label: Text('3'),
                selected: meal == 1,
                onSelected: (selected){
                  setState(() {
                    meal = selected ? 1 : null;
                  });
                },
              ),
              ChoiceChip(
                label: Text('4'),
                selected: meal == 2,
                onSelected: (selected){
                  setState(() {
                    meal = selected ? 2 : null;
                  });
                },
              ),
              ChoiceChip(
                label: Text('5+'),
                selected: meal == 3,
                onSelected: (selected){
                  setState(() {
                    meal = selected ? 3 : null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Text('Your Diet Preference'),
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
              regionChip('East African', Symbols.float_landscape_2_rounded, 5),
              regionChip('North African', Symbols.sunny_rounded, 6),
              regionChip('Western', Symbols.account_balance_rounded, 7),
              regionChip('No preference', Symbols.all_inclusive_rounded, 8),
            ],
          ),
          const SizedBox(height: 15,),
          Row(children: [
            Icon(Symbols.allergies_rounded),
            const SizedBox(width: 10,),
            Text('Your Allergies'),
          ],),
          const SizedBox(height: 5,),
          AllergenChips(),
          const SizedBox(height: 20,),
        ],),
      ),
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
        });
      },
    );
  }
  Widget regionChip(String label, IconData icon, int value){
    return FilterChip(
      label: Text(label),
      selected: region == value,
      showCheckmark: false,
      avatar: Icon(icon),
      onSelected: (selected){
        setState(() {
          region = selected ? value : null;
        });
      },
    );
  }
}

class SignupPageEightData{}

class SignupPageEight extends StatefulWidget {
  final SignupPageEightData data;
  const SignupPageEight({super.key, required this.data});

  @override
  State<SignupPageEight> createState() => _SignupPageEightState();
}

class _SignupPageEightState extends State<SignupPageEight> {
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
          const SizedBox(height: 20,),
        ],),
      ),
    );
  }
}

class SignupPageNineData{}

class SignupPageNine extends StatefulWidget {
  final SignupPageNineData data;
  const SignupPageNine({super.key, required this.data});

  @override
  State<SignupPageNine> createState() => _SignupPageNineState();
}

class _SignupPageNineState extends State<SignupPageNine> {
  bool isHiddenOne = true;
  bool isHiddenTwo = true;
  String selectedCode = 'BAN';
  bool isGoogleConnected = true;
  bool isAppleConnected = false;

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
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                labelText: 'Username',
                helperText: '*Use letters, numbers and underscore',
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              obscureText: isHiddenOne,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded),
                labelText: 'Password',
                helperText: '*At least 8 characters',
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      isHiddenOne = !isHiddenOne;
                    });
                  }, icon: isHiddenOne ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off_rounded),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              obscureText: isHiddenTwo,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_clock_outlined),
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      isHiddenTwo = !isHiddenTwo;
                    });
                  }, icon: isHiddenTwo ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off_rounded),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Row(children: [
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
              const SizedBox(width: 8,),
              Expanded(child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone no',
                  hintText: 'XXXXXXXXXX',
                ),
              ))]),
            const SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
                labelText: 'Address',
                helperText: '*Optional',
              ),
            ),
            const SizedBox(height: 20,),
            Text('Link with your Google or Apple id'),
            const SizedBox(height: 10,),
            FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface
                ),
                onPressed: (){}, child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                  children: [
                   Emoji.google,
                    Expanded(child: Center(child: Text('Connect with Google', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),))),
                    isGoogleConnected ?
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
                onPressed: (){}, child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                  children: [
                    Emoji.apple,
                    Expanded(child: Center(child: Text('Connect with Apple', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),))),
                    isAppleConnected ?
                    Icon(Icons.check_circle_outline, size: 24, color: CustomColors.greenPrimary(context),) : const SizedBox(height: 24, width: 24,),
                  ],
                ),
            )),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
  Widget countryCode(BuildContext context){
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
                  value: country['name'],
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

class SignupPageTen extends StatefulWidget {
  const SignupPageTen({super.key});

  @override
  State<SignupPageTen> createState() => _SignupPageTenState();
}

class _SignupPageTenState extends State<SignupPageTen> {
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
          const SizedBox(height: 20,),
        ],),
      ),
    );
  }
}
