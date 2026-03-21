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

  SignupPageOneData({
    this.name,
    this.dob,
    this.gender,
    this.height,
    this.weight,
    this.isHeightFt = true,
    this.isWeightKg = true,
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

  int? genderSelected;
  void selectGender(int g){
    setState(() {
      genderSelected = g;
    });
  }

  bool isHeightUnitOne = true;
  bool isWeightUnitOne = true;

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
          OutlinedButton(onPressed: (){}, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              const SizedBox(width: 8,),
              Text('Add'),
            ],
          )),
          const SizedBox(height: 20,),
          Row(children: [
            Icon(Icons.personal_injury_rounded),
            const SizedBox(width: 10,),
            Text('Current Injuries'),
          ],),
          const SizedBox(height: 10,),
          OutlinedButton(onPressed: (){}, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              const SizedBox(width: 8,),
              Text('Add'),
            ],
          )),
          const SizedBox(height: 20,),
        ],),
      ),
    );
  }
}

class SignupPageThree extends StatefulWidget {
  const SignupPageThree({super.key});

  @override
  State<SignupPageThree> createState() => _SignupPageThreeState();
}

class _SignupPageThreeState extends State<SignupPageThree> {
  int selectedWork = -1;
  int selectedActive = -1;
  int selectedSleep = -1;
  
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

class SignupPageFour extends StatefulWidget {
  const SignupPageFour({super.key});

  @override
  State<SignupPageFour> createState() => _SignupPageFourState();
}

class _SignupPageFourState extends State<SignupPageFour> {
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
        ],),
      ),
    );
  }
}

class SignupPageFive extends StatefulWidget {
  const SignupPageFive({super.key});

  @override
  State<SignupPageFive> createState() => _SignupPageFiveState();
}

class _SignupPageFiveState extends State<SignupPageFive> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(
            children: [
              Emoji.page5,
              const SizedBox(width: 10,),
              Text('What are you working toward?', style: Theme.of(context).textTheme.displaySmall,),
            ],
          ),
          const SizedBox(height: 10,),
          Text('We’ll use this to guide your plan', style: Theme.of(context).textTheme.labelMedium,),
          const SizedBox(height: 20,),
        ],),
      ),
    );
  }
}

class SignupPageSix extends StatefulWidget {
  const SignupPageSix({super.key});

  @override
  State<SignupPageSix> createState() => _SignupPageSixState();
}

class _SignupPageSixState extends State<SignupPageSix> {
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
        ],),
      ),
    );
  }
}

class SignupPageSeven extends StatefulWidget {
  const SignupPageSeven({super.key});

  @override
  State<SignupPageSeven> createState() => _SignupPageSevenState();
}

class _SignupPageSevenState extends State<SignupPageSeven> {
  @override
  Widget build(BuildContext context) {
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
          Row(children: [
            Icon(Symbols.allergies_rounded),
            const SizedBox(width: 10,),
            Text('Your Allergies'),
          ],),
          const SizedBox(height: 10,),
          OutlinedButton(onPressed: (){}, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              const SizedBox(width: 8,),
              Text('Add'),
            ],
          )),
          const SizedBox(height: 20,),
          Row(children: [
            Icon(Symbols.gastroenterology_rounded),
            const SizedBox(width: 10,),
            Text('Your Intolerances'),
          ],),
          const SizedBox(height: 10,),
          OutlinedButton(onPressed: (){}, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              const SizedBox(width: 8,),
              Text('Add'),
            ],
          )),
          const SizedBox(height: 20,),
        ],),
      ),
    );
  }
}

class SignupPageEight extends StatefulWidget {
  const SignupPageEight({super.key});

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
        ],),
      ),
    );
  }
}

class SignupPageNine extends StatefulWidget {
  const SignupPageNine({super.key});

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

class SignupPageTen extends StatelessWidget {
  const SignupPageTen({super.key});

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
