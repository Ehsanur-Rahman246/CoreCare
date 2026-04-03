import 'package:core_care/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Emoji{
  Emoji._();
  static const double emojiSize = 24.0;
  static const double iconSize = 18.0;
  static const double logoSize = 30.0;
  static const double textSize = 16.0;

  static final Image starter = Image.asset('assets/emojis/reminder_ribbon.png', width: emojiSize, height: emojiSize,);
  static final Image active = Image.asset('assets/emojis/third_place_medal.png', width: emojiSize, height: emojiSize,);
  static final Image commited = Image.asset('assets/emojis/second_place_medal.png.png', width: emojiSize, height: emojiSize,);
  static final Image dedicated = Image.asset('assets/emojis/first_place_medal.png.png', width: emojiSize, height: emojiSize,);
  static final Image advanced = Image.asset('assets/emojis/sports_medal.png', width: emojiSize, height: emojiSize,);
  static final Image expert = Image.asset('assets/emojis/medal.png', width: emojiSize, height: emojiSize,);
  static final Image elite = Image.asset('assets/emojis/rosette.png', width: emojiSize, height: emojiSize,);
  static final Image legend = Image.asset('assets/emojis/crown.png', width: emojiSize, height: emojiSize,);

  static final Image fire = Image.asset('assets/emojis/fire.png', width: emojiSize, height: emojiSize,);
  static final Image coin = Image.asset('assets/emojis/coin.png', width: emojiSize, height: emojiSize,);

  static final Image profile = Image.asset('assets/emojis/bust_in_silhouette.png', width: logoSize, height: logoSize,);
  static final Image fit = Image.asset('assets/emojis/man-lifting-weights.png', width: logoSize, height: logoSize,);
  static final Image time = Image.asset('assets/emojis/clock2.png', width: logoSize, height: logoSize,);
  static final Image settings = Image.asset('assets/emojis/gear.png', width: logoSize, height: logoSize,);
  static final Image diet = Image.asset('assets/emojis/ramen.png', width: logoSize, height: logoSize,);
  static final Image med = Image.asset('assets/emojis/stethoscope.png', width: logoSize, height: logoSize,);
  static final Image stat = Image.asset('assets/emojis/muscle.png', width: logoSize, height: logoSize,);
  static final Image id = Image.asset('assets/emojis/technologist.png', width: logoSize, height: logoSize,);

  static final Image page1 = Image.asset('assets/emojis/bust_in_silhouette.png', width: logoSize, height: logoSize,);
  static final Image page2 = Image.asset('assets/emojis/stethoscope.png', width: logoSize, height: logoSize,);
  static final Image page3 = Image.asset('assets/emojis/crescent_moon.png', width: logoSize, height: logoSize,);
  static final Image page4 = Image.asset('assets/emojis/man-lifting-weights.png', width: logoSize, height: logoSize,);
  static final Image page5 = Image.asset('assets/emojis/dart.png', width: logoSize, height: logoSize,);
  static final Image page6 = Image.asset('assets/emojis/clock2.png', width: logoSize, height: logoSize,);
  static final Image page7 = Image.asset('assets/emojis/knife_fork_plate.png', width: logoSize, height: logoSize,);
  static final Image page8 = Image.asset('assets/emojis/no_entry_sign.png', width: logoSize, height: logoSize,);
  static final Image page9 = Image.asset('assets/emojis/closed_lock_with_key.png', width: logoSize, height: logoSize,);
  static final Image page10 = Image.asset('assets/emojis/bar_chart.png', width: logoSize, height: logoSize,);

  static final Image google = Image.asset('assets/logo/google.png', width: logoSize, height: logoSize,);
  static final Image apple = Image.asset('assets/logo/apple.png', width: logoSize, height: logoSize,);

  static final Image o1 = Image.asset('assets/emojis/chair.png', width: logoSize, height: logoSize,);
  static final Image o2 = Image.asset('assets/emojis/teacher.png', width: logoSize, height: logoSize,);
  static final Image o3 = Image.asset('assets/emojis/construction_worker.png', width: logoSize, height: logoSize,);

  static final Image a1 = Image.asset('assets/emojis/couch_and_lamp.png', width: logoSize, height: logoSize,);
  static final Image a2 = Image.asset('assets/emojis/walking.png', width: logoSize, height: logoSize,);
  static final Image a3 = Image.asset('assets/emojis/runner.png', width: logoSize, height: logoSize,);

  static final Image f1 = Image.asset('assets/emojis/hatching_chick.png', width: logoSize, height: logoSize,);
  static final Image f2 = Image.asset('assets/emojis/runner.png', width: logoSize, height: logoSize,);
  static final Image f3 = Image.asset('assets/emojis/man_climbing.png', width: logoSize, height: logoSize,);

  static final Image fund1 = Image.asset('assets/emojis/zap.png', width: emojiSize, height: emojiSize,);
  static final Image fund2 = Image.asset('assets/emojis/muscle.png', width: emojiSize, height: emojiSize,);
  static final Image fund3 = Image.asset('assets/emojis/runner.png', width: emojiSize, height: emojiSize,);
  static final Image fund4 = Image.asset('assets/emojis/scales.png', width: emojiSize, height: emojiSize,);
  static final Image fund5 = Image.asset('assets/emojis/dna.png', width: emojiSize, height: emojiSize,);
  static final Image fund6 = Image.asset('assets/emojis/standing_person.png', width: emojiSize, height: emojiSize,);
  static final Image fund7 = Image.asset('assets/emojis/seedling.png', width: emojiSize, height: emojiSize,);

  static final Image s1 = Image.asset('assets/emojis/city_sunrise.png');
  static final Image s2 = Image.asset('assets/emojis/cityscape.png');
  static final Image s3 = Image.asset('assets/emojis/city_sunset.png');
  static final Image s4 = Image.asset('assets/emojis/night_with_stars.png');

  static final Image omni = Image.asset('assets/emojis/meat_on_bone.png');
  static final Image veg = Image.asset('assets/emojis/broccoli.png');
  static final Image vegan = Image.asset('assets/emojis/seedling.png');
  static final Image fish = Image.asset('assets/emojis/fish.png');
  static final Image paleo = Image.asset('assets/emojis/cut_of_meat.png');
  static final Image keto = Image.asset('assets/emojis/avocado.png');

  static final Image al1 = Image.asset('assets/emojis/peanuts.png');
  static final Image al2 = Image.asset('assets/emojis/chestnut.png');
  static final Image al3 = Image.asset('assets/emojis/chestnut.png');
  static final Image al4 = Image.asset('assets/emojis/chestnut.png');
  static final Image al5 = Image.asset('assets/emojis/chestnut.png');
  static final Image al6 = Image.asset('assets/emojis/glass_of_milk.png');
  static final Image al7 = Image.asset('assets/emojis/egg.png');
  static final Image al8 = Image.asset('assets/emojis/ear_of_rice.png');
  static final Image al9 = Image.asset('assets/emojis/bread.png');
  static final Image al10 = Image.asset('assets/emojis/seedling.png');
  static final Image al11 = Image.asset('assets/emojis/tropical_fish.png');
  static final Image al12 = Image.asset('assets/emojis/shrimp.png');
  static final Image al13 = Image.asset('assets/emojis/herb.png');
  static final Image al14 = Image.asset('assets/emojis/large_yellow_circle.png');
  static final Image al15 = Image.asset('assets/emojis/wine_glass.png');
  static final Image al16 = Image.asset('assets/emojis/corn.png');
  static final Image al17 = Image.asset('assets/emojis/leafy_green.png');
  static final Image al18 = Image.asset('assets/emojis/cherry_blossom.png');
  static final Image al19 = Image.asset('assets/emojis/shell.png');
  static final Image al20 = Image.asset('assets/emojis/coconut.png');
  static final Image al21 = Image.asset('assets/emojis/sunflower.png');
  static final Image al22 = Image.asset('assets/emojis/hibiscus.png');

  static final Image style1 = Image.asset('assets/emojis/man-lifting-weights.png');
  static final Image style2 = Image.asset('assets/emojis/runner.png');
  static final Image style3 = Image.asset('assets/emojis/zap.png');
  static final Image style4 = Image.asset('assets/emojis/person_in_lotus_position.png');
  static final Image style5 = Image.asset('assets/emojis/kneeling_person.png');
  static final Image style6 = Image.asset('assets/emojis/man-cartwheeling.png');
  static final Image style7 = Image.asset('assets/emojis/soccer.png');
  static final Image style8 = Image.asset('assets/emojis/toolbox.png');
  static final Image style9 = Image.asset('assets/emojis/feather.png');
  static final Image style10 = Image.asset('assets/emojis/arrows_counterclockwise.png');

  static final Image place1 = Image.asset('assets/emojis/house_with_garden.png');
  static final Image place2 = Image.asset('assets/emojis/elevator.png');
  static final Image place3 = Image.asset('assets/emojis/playground_slide.png');
  static final Image e1 = Image.asset('assets/emojis/no_entry_sign.png');
  static final Image e2 = Image.asset('assets/emojis/wrench.png');
  static final Image e3 = Image.asset('assets/emojis/stadium.png');

  static final Image goal = Image.asset('assets/emojis/dart.png');

  static final Image m1 = Image.asset('assets/emojis/sunrise.png', height: iconSize, width: iconSize,);
  static final Image m2 = Image.asset('assets/emojis/sunrise_over_mountains.png', height: iconSize, width: iconSize,);
  static final Image sun1 = Image.asset('assets/emojis/sunny.png', height: iconSize, width: iconSize,);
  static final Image sun2 = Image.asset('assets/emojis/sun_with_face.png', height: iconSize, width: iconSize,);
  static final Image wave = Image.asset('assets/emojis/wave.png', height: iconSize, width: iconSize,);
  static final Image hi = Image.asset('assets/emojis/raised_hands.png', height: iconSize, width: iconSize,);
  static final Image smile = Image.asset('assets/emojis/relaxed.png', height: iconSize, width: iconSize,);
  static final Image grin = Image.asset('assets/emojis/grin.png', height: iconSize, width: iconSize,);
  static final Image glass = Image.asset('assets/emojis/sunglasses.png', height: iconSize, width: iconSize,);
  static final Image laugh = Image.asset('assets/emojis/smile.png', height: iconSize, width: iconSize,);
  static final Image evening = Image.asset('assets/emojis/city_sunset.png', height: iconSize, width: iconSize,);
  static final Image moon = Image.asset('assets/emojis/crescent_moon.png', height: iconSize, width: iconSize,);
  static final Image night = Image.asset('assets/emojis/milky_way.png', height: iconSize, width: iconSize,);
  static final Image noon = Image.asset('assets/emojis/mostly_sunny.png', height: iconSize, width: iconSize,);
  static final Image sleep1 = Image.asset('assets/emojis/sleeping.png', height: iconSize, width: iconSize,);
  static final Image sleep2 = Image.asset('assets/emojis/zzz.png', height: iconSize, width: iconSize,);
  static final Image star = Image.asset('assets/emojis/sparkles.png', height: iconSize, width: iconSize,);
  static final Image welcome = Image.asset('assets/emojis/tada.png', height: iconSize, width: iconSize,);

  static final Image carb1 = Image.asset('assets/emojis/bread.png', height: textSize, width: textSize,);
  static final Image pro1 = Image.asset('assets/emojis/poultry_leg.png', height: textSize, width: textSize,);
  static final Image fat1 = Image.asset('assets/emojis/butter.png', height: textSize, width: textSize,);
  static final Image carb2 = Image.asset('assets/emojis/corn.png', height: textSize, width: textSize,);
  static final Image pro2 = Image.asset('assets/emojis/beans.png', height: textSize, width: textSize,);
  static final Image fat2 = Image.asset('assets/emojis/avocado.png', height: textSize, width: textSize,);
  static final Image carb3 = Image.asset('assets/emojis/rice.png', height: textSize, width: textSize,);
  static final Image pro3 = Image.asset('assets/emojis/chestnut.png', height: textSize, width: textSize,);
  static final Image fat3 = Image.asset('assets/emojis/coconut.png', height: textSize, width: textSize,);
  static final Image carb4 = Image.asset('assets/emojis/potato.png', height: textSize, width: textSize,);
  static final Image pro4 = Image.asset('assets/emojis/fish.png', height: textSize, width: textSize,);
  static final Image fat4 = Image.asset('assets/emojis/olive.png', height: textSize, width: textSize,);
  static final Image carb5 = Image.asset('assets/emojis/sweet_potato.png', height: textSize, width: textSize,);
  static final Image pro5 = Image.asset('assets/emojis/cut_of_meat.png', height: textSize, width: textSize,);
  static final Image fat5 = Image.asset('assets/emojis/peanuts.png', height: textSize, width: textSize,);
  static final Image carb6 = Image.asset('assets/emojis/broccoli.png', height: textSize, width: textSize,);
  static final Image pro6 = Image.asset('assets/emojis/egg.png', height: textSize, width: textSize,);
  static final Image fat6 = Image.asset('assets/emojis/cheese_wedge.png', height: textSize, width: textSize,);
}

enum TimeType{morning, afternoon, evening, night, midnight}

class Greet{
  final String text;
  final Image emoji;
  final TimeType time;
  final List<String> groups;

  Greet({required this.text, required this.emoji, required this.time, required this.groups});
}

class Greetings extends StatefulWidget {
  const Greetings({super.key});

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  final List<Greet> greetings = [
    Greet(text: 'Morning, ', emoji: Emoji.m1, time: TimeType.morning, groups: ['Teen', 'Young Adult', 'Adult', 'Senior']),
    Greet(text: 'Morning! ', emoji: Emoji.sun1, time: TimeType.morning, groups: ['Teen']),
    Greet(text: 'Good Morning! ', emoji: Emoji.sun2, time: TimeType.morning, groups: ['Teen']),
    Greet(text: 'Morning, ', emoji: Emoji.sun2, time: TimeType.morning, groups: ['Young Adult', 'Adult', 'Senior']),
    Greet(text: 'Hello! ', emoji: Emoji.smile, time: TimeType.morning, groups: ['Teen', 'Young Adult']),
    Greet(text: 'Welcome, ', emoji: Emoji.hi, time: TimeType.morning, groups: ['Young Adult']),
    Greet(text: 'Welcome, ', emoji: Emoji.smile, time: TimeType.morning, groups: ['Adult', 'Senior']),
    Greet(text: 'Rise & shine! ', emoji: Emoji.m2, time: TimeType.morning, groups: ['Teen']),
    Greet(text: 'Rise and shine, ', emoji: Emoji.m2, time: TimeType.morning, groups: ['Young Adult']),
    Greet(text: 'Afternoon, ', emoji: Emoji.noon, time: TimeType.afternoon, groups: ['Teen']),
    Greet(text: 'Good Afternoon, ', emoji: Emoji.noon, time: TimeType.afternoon, groups: ['Young Adult', 'Adult', 'Senior']),
    Greet(text: 'Hey there! ', emoji: Emoji.laugh, time: TimeType.afternoon, groups: ['Teen']),
    Greet(text: 'Hello! ', emoji: Emoji.wave, time: TimeType.afternoon, groups: ['Teen']),
    Greet(text: 'Hello, ', emoji: Emoji.wave, time: TimeType.afternoon, groups: ['Young Adult', 'Adult']),
    Greet(text: 'Hi! ', emoji: Emoji.smile, time: TimeType.afternoon, groups: ['Teen', 'Young Adult']),
    Greet(text: 'What’s up? ', emoji: Emoji.glass, time: TimeType.afternoon, groups: ['Teen']),
    Greet(text: 'Welcome! ', emoji: Emoji.welcome, time: TimeType.afternoon, groups: ['Teen']),
    Greet(text: 'Welcome back, ', emoji: Emoji.smile, time: TimeType.afternoon, groups: ['Adult']),
    Greet(text: 'Evening, ', emoji: Emoji.evening, time: TimeType.evening, groups: ['Teen', 'Young Adult', 'Adult', 'Senior']),
    Greet(text: 'Good evening, ', emoji: Emoji.moon, time: TimeType.evening, groups: ['Teen', 'Young Adult', 'Adult', 'Senior']),
    Greet(text: 'Welcome back! ', emoji: Emoji.hi, time: TimeType.evening, groups: ['Teen']),
    Greet(text: 'Welcome back, ', emoji: Emoji.hi, time: TimeType.evening, groups: ['Young Adult']),
    Greet(text: 'Welcome back, ', emoji: Emoji.smile, time: TimeType.evening, groups: ['Adult']),
    Greet(text: 'Hello again, ', emoji: Emoji.smile, time: TimeType.evening, groups: ['Young Adult']),
    Greet(text: 'Hey again! ', emoji: Emoji.grin, time: TimeType.evening, groups: ['Teen']),
    Greet(text: 'Night, ', emoji: Emoji.moon, time: TimeType.night, groups: ['Teen', 'Young Adult', 'Adult', 'Senior']),
    Greet(text: 'Good night, ', emoji: Emoji.night, time: TimeType.night, groups: ['Teen', 'Young Adult', 'Adult', 'Senior']),
    Greet(text: 'Night! ', emoji: Emoji.sleep1, time: TimeType.night, groups: ['Teen', 'Young Adult', 'Adult']),
    Greet(text: 'Hello tonight! ', emoji: Emoji.moon, time: TimeType.night, groups: ['Teen', 'Young Adult']),
    Greet(text: 'Sleep tight! ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Teen']),
    Greet(text: 'Catch some ', emoji: Emoji.sleep2, time: TimeType.midnight, groups: ['Teen']),
    Greet(text: 'Night, champ! ', emoji: Emoji.star, time: TimeType.midnight, groups: ['Teen']),
    Greet(text: 'Sweet dreams! ', emoji: Emoji.night, time: TimeType.midnight, groups: ['Teen']),
    Greet(text: 'Don’t stay up late! ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Teen']),
    Greet(text: 'Time to recharge ', emoji: Emoji.sleep1, time: TimeType.midnight, groups: ['Young Adult']),
    Greet(text: 'Good night! ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Young Adult']),
    Greet(text: 'Rest up ', emoji: Emoji.star, time: TimeType.midnight, groups: ['Young Adult']),
    Greet(text: 'Sleep well! ', emoji: Emoji.night, time: TimeType.midnight, groups: ['Young Adult']),
    Greet(text: 'Sweet dreams! ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Young Adult']),
    Greet(text: 'Peaceful night ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Adult']),
    Greet(text: 'Time to rest ', emoji: Emoji.sleep1, time: TimeType.midnight, groups: ['Adult']),
    Greet(text: 'Sleep well ', emoji: Emoji.star, time: TimeType.midnight, groups: ['Adult']),
    Greet(text: 'Rest fuels progress ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Adult']),
    Greet(text: 'Good night ', emoji: Emoji.star, time: TimeType.midnight, groups: ['Adult', 'Senior']),
    Greet(text: 'Restful night ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Senior']),
    Greet(text: 'Sleep peacefully ', emoji: Emoji.sleep1, time: TimeType.midnight, groups: ['Senior']),
    Greet(text: 'Sweet dreams ', emoji: Emoji.night, time: TimeType.midnight, groups: ['Senior']),
    Greet(text: 'Rest and wake refreshed ', emoji: Emoji.moon, time: TimeType.midnight, groups: ['Senior']),
  ];

  Greet? _cachedGreet;
  DateTime? _lastGenerated;

  Greet? getRandomGreeting(List<Greet> greet, BuildContext context){
    final now = DateTime.now();
    final time = context.watch<TimeProvider>().now.hour;
    final group = context.watch<DataProvider>().currentUser!.ageGroup;

    if(_cachedGreet != null && _lastGenerated != null && now.difference(_lastGenerated!).inMinutes < 5){
      return _cachedGreet;
    }

    TimeType currentTime;
    if(time >= 5 && time < 12){
      currentTime = TimeType.morning;
    }else if(time >= 12 && time < 17){
      currentTime = TimeType.afternoon;
    }else if(time >= 17 && time < 21){
      currentTime = TimeType.evening;
    }else if(time >= 21 && time < 24){
      currentTime = TimeType.night;
    }else{
      currentTime = TimeType.midnight;
    }

    final selectedGreets = greetings.where((g) {
      return g.time == currentTime && g.groups.contains(group);
    }).toList();

    if(selectedGreets.isNotEmpty){
      _cachedGreet = selectedGreets[Random().nextInt(selectedGreets.length)];
      _lastGenerated = now;
      return _cachedGreet;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final st = Theme.of(context).textTheme.headlineSmall;
    final greet = getRandomGreeting(greetings, context);
    final username = context.watch<DataProvider>().currentUser!.name;
    final name = username.split(' ')[0];

    return greet != null ?
        RichText(text: TextSpan(children: [
          TextSpan(text: greet.text, style: st),
          if(greet.time != TimeType.midnight)
            TextSpan(text: '$name ', style: st),
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: greet.emoji),
        ]))
        : Text('Welcome to CoreCare!');
  }
}
