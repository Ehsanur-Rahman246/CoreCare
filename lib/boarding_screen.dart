import 'package:core_care/data_provider.dart';
import 'package:core_care/pages/sign_up_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:core_care/main.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  bool onLastPage = false;
  late final List<AnimationController> _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = List.generate(
      4,
      (_) => AnimationController(vsync: this),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final c in _lottieController) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = (index == 3);
                  });
                  for (int i = 0; i < _lottieController.length; i++) {
                    if (i == index) {
                      if (_lottieController[i].duration != null) {
                        _lottieController[i].repeat();
                      }
                    } else {
                      _lottieController[i].stop();
                    }
                  }
                },
                controller: _controller,
                children: List.generate(4, (index) {
                  final lottie = [
                    'assets/logo/sc1.json',
                    'assets/logo/sc2.json',
                    'assets/logo/sc3.json',
                    'assets/logo/sc4.json',
                  ];
                  final title = [
                    'Fitness That Fits You',
                    'Track. Improve. Repeat.',
                    'We Guide. You Decide.',
                    'Small Steps. Big Results.',
                  ];
                  final subtitle = [
                    'Tailored workouts and meal plans based on your body, lifestyle, and goals.',
                    'Monitor progress and get smart insights to stay on course.',
                    'Personalized advice and motivation—your commitment makes it work.',
                    'Build habits, celebrate milestones, and watch your progress grow.',
                  ];
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Lottie.asset(
                              lottie[index],
                              controller: _lottieController[index],
                              onLoaded: (play) {
                                _lottieController[index].duration =
                                    play.duration;
                                if (_controller.page?.round() == index) {
                                  _lottieController[index].repeat();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                                title[index],
                                style: Theme.of(context).textTheme.displayLarge,
                            textAlign: TextAlign.center,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 40,
                          ),
                          child: Text(
                            subtitle[index],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: onLastPage
                  ? SizedBox()
                  : TextButton(
                      onPressed: () {
                        _controller.jumpToPage(3);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
            ),
            Container(
              alignment: Alignment(0, 0.60),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: WormEffect(
                  dotWidth: 7,
                  dotHeight: 7,
                  dotColor: Theme.of(context).colorScheme.tertiary,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              alignment: Alignment(0, 0.77),
              child: onLastPage
                  ? FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        for (final c in _lottieController) {
                          c.stop();
                        }
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Get Started'),
                    )
                  : FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Text('Next'),
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              alignment: Alignment(0, 0.95),
              child: onLastPage
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () async{
                        for (final c in _lottieController) {
                          c.stop();
                        }
                        final provider = Provider.of<DataProvider>(context, listen: false);
                        await provider.restoreSession();
                        if(context.mounted){
                          Navigator.pushReplacementNamed(context, '/auth');
                        }
                      },
                      child: Text('Sign In'),
                    )
                  : SizedBox(),
            ),
          ],
        ),
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
  SignupPageOneData pageOne = SignupPageOneData();
  SignupPageTwoData pageTwo = SignupPageTwoData();
  SignupPageThreeData pageThree = SignupPageThreeData();
  SignupPageFourData pageFour = SignupPageFourData();
  SignupPageFiveData pageFive = SignupPageFiveData();
  SignupPageSixData pageSix = SignupPageSixData();
  SignupPageSevenData pageSeven = SignupPageSevenData();
  SignupPageEightData pageEight = SignupPageEightData();
  SignupPageNineData pageNine = SignupPageNineData();
  SignupPageTenData pageTen = SignupPageTenData();

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

  void scrollTimeline(int index, double stepWidth) {
    int maxScroll = _totalSteps - visibleSteps;
    int scrollIndex = (index - (visibleSteps - 2)).clamp(0, maxScroll);

    double offset = scrollIndex * stepWidth;
    _timelineController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onNext(){
    if (currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double stepWidth = MediaQuery.of(context).size.width / visibleSteps;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                  Padding(
                    padding: const EdgeInsetsGeometry.only(left: 10),
                    child: IconButton(
                      onPressed: () {
                        if(currentPage == 0){
                          Navigator.pop(context);
                        }else{
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: Icon(Icons.chevron_left),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Step ${currentPage + 1} out of $_totalSteps",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
              child: SingleChildScrollView(
                controller: _timelineController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_totalSteps, (index) {
                    bool isFirst = index == 0;
                    bool isLast = index == _totalSteps - 1;
                    bool isActive = index == currentPage;
                    bool isDone =
                        index < currentPage ||
                        (currentPage == _totalSteps - 1 &&
                            index == _totalSteps - 1);
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
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                  scrollTimeline(index, stepWidth);
                },

                children: [
                  SignupPageOne(data: pageOne, onNext: onNext,),
                  SignupPageTwo(data: pageTwo, onNext: onNext,),
                  SignupPageThree(data: pageThree, onNext: onNext,),
                  SignupPageFour(data: pageFour, onNext: onNext,),
                  SignupPageFive(data: pageFive, onNext: onNext,),
                  SignupPageSix(data: pageSix, onNext: onNext,),
                  SignupPageSeven(data: pageSeven, onNext: onNext,),
                  SignupPageEight(data: pageEight, onNext: onNext,),
                  SignupPageNine(data: pageNine, onNext: onNext,),
                  SignupPageTen(data: pageTen, onNext: onNext,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepIndicator(bool isFirst, bool isLast, bool isActive, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        axis: TimelineAxis.horizontal,
        beforeLineStyle: LineStyle(
          color: isDone
              ? Theme.of(context).colorScheme.primary
              : isActive
              ? CustomColors.greenMuted(context)
              : Theme.of(context).colorScheme.tertiary,
        ),
        afterLineStyle: LineStyle(
          color: isDone
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.tertiary,
        ),
        indicatorStyle: IndicatorStyle(
          color: isDone
              ? Theme.of(context).colorScheme.primary
              : isActive
              ? CustomColors.greenMuted(context)
              : Theme.of(context).colorScheme.tertiary,
          iconStyle: IconStyle(
            iconData: isDone
                ? Icons.check
                : isActive
                ? Icons.circle_rounded
                : Icons.circle_outlined,
            color: isDone
                ? Theme.of(context).colorScheme.onPrimary
                : isActive
                ? CustomColors.greenOutline(context)
                : Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
