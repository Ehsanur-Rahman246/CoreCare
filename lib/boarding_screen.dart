import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
                          Navigator.pushNamed(context, '/home');
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
