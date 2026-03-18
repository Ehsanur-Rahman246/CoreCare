import 'package:flutter/material.dart';
import 'package:core_care/decoration.dart';

class SignupPageOne extends StatefulWidget {
  const SignupPageOne({super.key});

  @override
  State<SignupPageOne> createState() => _SignupPageOneState();
}

class _SignupPageOneState extends State<SignupPageOne> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SignupPageTwo extends StatefulWidget {
  const SignupPageTwo({super.key});

  @override
  State<SignupPageTwo> createState() => _SignupPageTwoState();
}

class _SignupPageTwoState extends State<SignupPageTwo> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SignupPageThree extends StatefulWidget {
  const SignupPageThree({super.key});

  @override
  State<SignupPageThree> createState() => _SignupPageThreeState();
}

class _SignupPageThreeState extends State<SignupPageThree> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
    return const Placeholder();
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
    return const Placeholder();
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
    return const Placeholder();
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
    return const Placeholder();
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
    return const Placeholder();
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
                Emoji.id,
                Text('Create Your Account', style: Theme.of(context).textTheme.displaySmall,),
              ],
            ),
            const SizedBox(height: 10,),
            Text('Add login details to secure progress and get started', style: Theme.of(context).textTheme.labelMedium,),
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
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email or Apple id'
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
      {'name': 'SA', 'code': '+966'},
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
    return const Placeholder();
  }
}
