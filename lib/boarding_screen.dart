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
  final PageController _pageController = PageController();
  final ScrollController _timelineController = ScrollController();
  int currentPage = 0;
  final int _totalSteps = 10;
  final int visibleSteps = 4;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _timelineController.dispose();
  }

  void scrollTimeline(int index, double stepWidth){
    int maxScroll = _totalSteps - visibleSteps;
    int scrollIndex = (index - (visibleSteps - 2)).clamp(0, maxScroll);

    double offset = scrollIndex * stepWidth;
    _timelineController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final double stepWidth = MediaQuery.of(context).size.width / visibleSteps;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: 60,
              child: SingleChildScrollView(
                controller: _timelineController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_totalSteps, (index){
                    bool isFirst = index == 0;
                    bool isLast = index == _totalSteps - 1;
                    bool isActive = index == currentPage;
                    bool isDone = index < currentPage;

                    return SizedBox(
                      width: stepWidth,
                      child: stepIndicator(isFirst, isLast, isActive, isDone),
                    );
                  }),
                ),
              ),
            ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index){
                setState(() {
                  currentPage = index;
                });
                scrollTimeline(index, stepWidth);
              },

              children: [
                Container(color: Colors.red,),
                Container(color: Colors.blue,),
                Container(color: Colors.green,),
                Container(color: Colors.yellow,),
                Container(color: Colors.orange,),
                Container(color: Colors.purple,),
                Container(color: Colors.black,),
                Container(color: Colors.white,),
                Container(color: Colors.cyan,),
                Container(color: Colors.brown,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: IconButton.filled(onPressed: (){
              if(currentPage < _totalSteps - 1){
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            }, icon: Icon(Icons.navigate_next)),
          ),
        ],
      ),
    );
  }
  Widget stepIndicator(bool isFirst, bool isLast, bool isActive, bool isDone){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        axis: TimelineAxis.horizontal,
        beforeLineStyle: LineStyle(
          color: isDone ? Theme.of(context).colorScheme.primary : isActive ? CustomColors.greenMuted(context) : Theme.of(context).colorScheme.tertiary,
        ),
        afterLineStyle: LineStyle(
          color: isDone ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
        ),
        indicatorStyle: IndicatorStyle(
          color: isDone ? Theme.of(context).colorScheme.primary : isActive ? CustomColors.greenMuted(context) : Theme.of(context).colorScheme.tertiary,
          iconStyle: IconStyle(
              iconData: isDone ? Icons.check : isActive ? Icons.circle_rounded : Icons.circle_outlined,
              color: isDone ? Theme.of(context).colorScheme.onPrimary : isActive ? CustomColors.greenOutline(context) : Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}

