import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';
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
  late PageController _pageController;
  bool onLastScreen = false;
  final int _totalSteps = 10;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index){
                onLastScreen = (index == _totalSteps - 1);
                },
            controller: _pageController,
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.red,
                  ),
                  TimelineTile(
                    isFirst: true,
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.blue,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.green,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.yellow,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.black,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.purple,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.orange,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.grey,
                  ),
                  TimelineTile(),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.cyan,
                  ),
                  TimelineTile(
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
          IconButton.filled(onPressed: (){}, icon: Icon(Icons.navigate_next)),
        ],
      ),
    );
  }
  Widget stepIndicator(bool isFirst, bool isLast, bool isActive){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        axis: TimelineAxis.horizontal,
        beforeLineStyle: LineStyle(
          color: Theme.of(context).colorScheme.primary
        ),
        indicatorStyle: IndicatorStyle(
          color: Theme.of(context).colorScheme.primary,
          iconStyle: IconStyle(iconData: Icons.check, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}

