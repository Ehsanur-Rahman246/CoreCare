import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:step_progress/step_progress.dart';
import 'package:core_care/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index){
              setState(() {
                onLastPage = (index == 3);
              });
            },
            controller: _controller,
            children: [
              Container(
                color: Colors.blue,
              ),
              Container(
                color: Colors.yellow,
              ),
              Container(
                color: Colors.green,
              ),
              Container(
                color: Colors.red,
              ),
            ],
          ),
          Container(
              alignment: Alignment(0, 0.75),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                TextButton(onPressed: (){
                  _controller.jumpToPage(3);
                }, child: Text('Skip')),
                SmoothPageIndicator(
                  controller: _controller, count: 4, effect: WormEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    dotColor: Theme.of(context).colorScheme.tertiary, activeDotColor: Theme.of(context).colorScheme.primary),),
                    onLastPage ?
                        FilledButton(onPressed: (){
                          Navigator.pushNamed(context, '/signup');
                        }, child: Text('Done')) :
                    FilledButton(onPressed: (){
                      _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                    }, child: Text('Next')),
              ])),
        ],
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late StepProgressController _stepController;
  final int _totalSteps = 10;
  int currStep = 0;

  @override
  void initState() {
    super.initState();
    _stepController = StepProgressController(totalSteps: _totalSteps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: IconButton(onPressed:() {}, icon: Icon(Icons.eighteen_mp)),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 20,
            child: StepProgress(totalSteps: _totalSteps,
              nodeIconBuilder: (index, currStep){
              if(index < currStep){
                return Icon(Icons.check_circle_outline, size: 12, color: Theme.of(context).colorScheme.onPrimary,);
              }
              else if(index == currStep) {
                return Icon(Icons.circle, size: 12, color: CustomColors.greenOutline(context),);
              }
              else{
                return Icon(Icons.circle_outlined, size: 15, color: CustomColors.greyLight(context),);
              }
              },
              theme: StepProgressThemeData(

                defaultForegroundColor: CustomColors.greyDark(context),
                activeForegroundColor: Theme.of(context).colorScheme.primary,
                stepLineStyle: StepLineStyle(
                  lineThickness: 2,
                ),
                stepNodeStyle: StepNodeStyle(

                ),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
            stepNodeSize: 15,
            controller: _stepController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              onStepChanged: (index){
              setState(() {
                currStep = index;
              });
              },
            ),
          ),
        ],
      ),
    );
  }
}

