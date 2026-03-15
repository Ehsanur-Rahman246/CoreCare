import 'package:flutter/material.dart';

class Emoji{
  Emoji._();
  static const double emojiSize = 24.0;
  static const double iconSize = 16.0;
  static const double logoSize = 30.0;

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

  static final Image google = Image.asset('assets/logo/google.png', width: logoSize, height: logoSize,);
  static final Image apple = Image.asset('assets/logo/apple.png', width: logoSize, height: logoSize,);
}