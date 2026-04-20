import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_care/pages/diet_module.dart';
import 'package:core_care/pages/fitness_module.dart';
import 'package:core_care/pages/home_screen.dart';
import 'package:core_care/pages/shop_module.dart';
import 'package:core_care/pages/sign_up_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:core_care/decoration.dart';

class TimeProvider extends ChangeNotifier {
  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _is24Hour = true;

  DateTime get now => _now;

  bool get is24Hour => _is24Hour;

  TimeProvider() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = DateTime.now();
      notifyListeners();
    });
  }

  void toggleFormat() {
    _is24Hour = !_is24Hour;
    notifyListeners();
  }

  String get formatTime {
    int hour = _now.hour;
    final minute = _now.minute.toString().padLeft(2, '0');
    if (_is24Hour) {
      return '${hour.toString().padLeft(2, '0')}:$minute';
    } else {
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:$minute $period';
    }
  }

  String get formatDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[_now.month - 1]} ${_now.day}, ${_now.year}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class UserData {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String password;
  final String? googleId;
  final String? appleId;
  final String? googleEmail;
  final String? appleEmail;
  final String? phone;
  final String? address;
  final double heightCm;
  final double weightKg;
  final double bmi;
  final String bmiCategory;
  final double bmr;
  final double tdee;
  final String profileTag;
  final String ageGroup;
  final int age;
  final String gender;
  final String fitType;
  final String fundType;
  final String goalType;
  final String planType;
  final String workType;
  final String activityLevel;
  final String sleepPattern;
  final List<String> selectedMeds;
  final List<String> selectedInjuries;
  final List<String> styleType;
  final String equipType;
  final String placeType;
  final String dayType;
  final String durationType;
  final List<String> timeType;
  final List<String> freeType;
  final String mealType;
  final String dietType;
  final bool isHalal;
  final List<String> regionType;
  final List<String> selectedAllergens;
  final List<String> selectedIntolerances;
  final List<String> selectedDislikes;
  final bool wantNotifications;
  final bool wantMetricUnit;
  final String language;
  final String themeMode;
  final bool is24Hour;
  final DateTime createdAt;
  final int xp;
  final int streak;
  final int coins;
  final String xpTag;

  static int calculateXp({required String work, required String active, required String fit}){
    const workXp = {
      'Sedentary': 0,
      'Moderately Active': 100,
      'Physically Active': 200,
    };
    const activityXP = {
      'Low': 0,
      'Moderate': 200,
      'High': 400,
    };
    const fitXP = {
      'Beginner': 0,
      'Intermediate': 300,
      'Advanced': 600,
    };
    int base = 0;
    return base + (workXp[work] ?? 0) + (activityXP[active] ?? 0) + (fitXP[fit] ?? 0);
  }
  static Map<String, String> getLevelTag(int xp){
    if(xp < 500) return {'tag': 'Starter'};
    if(xp < 500) return {'tag': 'Active'};
    if(xp < 500) return {'tag': 'Commited'};
    if(xp < 500) return {'tag': 'Dedicated'};
    if(xp < 500) return {'tag': 'Advanced'};
    if(xp < 500) return {'tag': 'Expert'};
    if(xp < 500) return {'tag': 'Elite'};
    return {'tag': 'Legend'};
  }

  UserData({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.googleId,
    this.appleId,
    this.googleEmail,
    this.appleEmail,
    this.phone,
    this.address,
    required this.heightCm,
    required this.weightKg,
    required this.bmi,
    required this.bmiCategory,
    required this.bmr,
    required this.tdee,
    required this.ageGroup,
    required this.age,
    required this.gender,
    required this.fitType,
    required this.fundType,
    required this.goalType,
    required this.planType,
    required this.workType,
    required this.activityLevel,
    required this.sleepPattern,
    required this.selectedMeds,
    required this.selectedInjuries,
    required this.styleType,
    required this.equipType,
    required this.placeType,
    required this.dayType,
    required this.durationType,
    required this.timeType,
    required this.freeType,
    required this.mealType,
    required this.dietType,
    required this.isHalal,
    required this.regionType,
    required this.selectedAllergens,
    required this.selectedIntolerances,
    required this.selectedDislikes,
    required this.wantNotifications,
    required this.wantMetricUnit,
    required this.createdAt,
    required this.language,
    required this.themeMode,
    required this.is24Hour,
    required this.profileTag, required this.xp, required this.streak, required this.coins, required this.xpTag,
  });

  factory UserData.fromSignup({
    required String uid,
    required SignupPageOneData p1,
    required SignupPageTwoData p2,
    required SignupPageThreeData p3,
    required SignupPageFourData p4,
    required SignupPageFiveData p5,
    required SignupPageSixData p6,
    required SignupPageSevenData p7,
    required SignupPageEightData p8,
    required SignupPageNineData p9,
    required SignupPageTenData p10,
    required String profileTag,
  }) {
    final hCm = p1.toHeightCm(
      p1.height!,
      p1.isHeightFt,
      inches: p1.heightInches ?? 0,
    );
    final wKg = p1.toWeightKg(p1.weight!, p1.isWeightKg);
    String hashPassword(String password) {
      final bytes = utf8.encode(password);
      return sha256.convert(bytes).toString();
    }
    final startXP = UserData.calculateXp(work: p3.workType, active: p3.activityLevel, fit: p4.fitType);
    final level = UserData.getLevelTag(startXP);

    return UserData(
      uid: uid,
      name: p1.name!,
      username: p9.username!,
      email: p9.email!,
      password: hashPassword(p9.password!),
      googleId: p9.googleId,
      appleId: p9.appleId,
      googleEmail: p9.googleEmail,
      appleEmail: p9.appleEmail,
      phone: p9.phone,
      address: p9.address,
      heightCm: double.parse(hCm.toStringAsFixed(1)),
      weightKg: double.parse(wKg.toStringAsFixed(1)),
      bmi: p1.bmi!,
      bmiCategory: p1.category!,
      bmr: p1.bmr!,
      tdee: p4.tdee!,
      ageGroup: p1.ageGroup!,
      age: p1.age!,
      gender: p1.gender == 1 ? 'Male' : 'Female',
      fitType: p4.fitType,
      fundType: p5.fundType,
      goalType: p5.goalType!,
      planType: p5.planType,
      workType: p3.workType,
      activityLevel: p3.activityLevel,
      sleepPattern: p3.sleepPattern,
      selectedMeds: p2.selectedMeds,
      selectedInjuries: p2.selectedInjuries,
      styleType: p6.styleType,
      equipType: p6.equipType,
      placeType: p6.placeType,
      dayType: p6.dayType,
      durationType: p6.durationType,
      timeType: p6.timeType,
      freeType: p6.freeType,
      mealType: p7.mealType,
      dietType: p7.dietType,
      isHalal: p7.isHalal,
      regionType: p7.regionType,
      selectedAllergens: p7.selectedAllergens,
      selectedIntolerances: p8.selectedIntolerances,
      selectedDislikes: p8.selectedDislikes,
      wantNotifications: p10.wantNotifications,
      wantMetricUnit: p10.wantMetricUnit,
      createdAt: DateTime.now(),
      language: 'English',
      themeMode: 'system',
      is24Hour: true,
      profileTag: profileTag, xp: startXP, streak: 0, coins: 0, xpTag: level['tag']!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'googleId': googleId,
      'appleId': appleId,
      'googleEmail': googleEmail,
      'appleEmail': appleEmail,
      'phone': phone,
      'address': address,
      'height': heightCm,
      'weight': weightKg,
      'bmi': bmi,
      'bmiCategory': bmiCategory,
      'bmr': bmr,
      'tdee': tdee,
      'profileTag': profileTag,
      'group': ageGroup,
      'age': age,
      'gender': gender,
      'fitness': fitType,
      'fundamental': fundType,
      'goal': goalType,
      'plan': planType,
      'work': workType,
      'activity': activityLevel,
      'sleepPattern': sleepPattern,
      'medicals': selectedMeds,
      'injuries': selectedInjuries,
      'exercise': styleType,
      'equipment': equipType,
      'place': placeType,
      'workoutDays': dayType,
      'duration': durationType,
      'time': timeType,
      'freeDays': freeType,
      'mealsPerDay': mealType,
      'dietPref': dietType,
      'isHalal': isHalal,
      'regions': regionType,
      'allergens': selectedAllergens,
      'intolerances': selectedIntolerances,
      'dislikes': selectedDislikes,
      'notifications': wantNotifications,
      'unit': wantMetricUnit,
      'language': language,
      'theme': themeMode,
      'hourFormat': is24Hour,
      'createdAt': createdAt.toIso8601String(),
      'xp' : xp, 'streak' : streak, 'coins' : coins,
      'levelTag' : xpTag,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      googleId: map['googleId'],
      googleEmail: map['googleEmail'],
      appleId: map['appleId'],
      appleEmail: map['appleEmail'],
      phone: map['phone'] ?? 'None',
      address: map['address'] ?? '',
      password: map['password'] ?? '',
      heightCm: (map['height'] ?? 0).toDouble(),
      weightKg: (map['weight'] ?? 0).toDouble(),
      bmi: (map['bmi'] ?? 0).toDouble(),
      bmiCategory: map['bmiCategory'] ?? '',
      bmr: (map['bmr'] ?? 0).toDouble(),
      tdee: (map['tdee'] ?? 0).toDouble(),
      ageGroup: map['group'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      fitType: map['fitness'] ?? '',
      fundType: map['fundamental'] ?? '',
      goalType: map['goal'],
      planType: map['plan'] ?? '',
      workType: map['work'] ?? '',
      activityLevel: map['activity'] ?? '',
      sleepPattern: map['sleepPattern'] ?? '',
      selectedMeds: List<String>.from(map['medicals'] ?? []),
      selectedInjuries: List<String>.from(map['injuries'] ?? []),
      styleType: List<String>.from(map['exercise'] ?? []),
      equipType: map['equipment'] ?? '',
      placeType: map['place'] ?? '',
      dayType: map['workoutDays'] ?? '',
      durationType: map['duration'] ?? '',
      timeType: List<String>.from(map['time'] ?? []),
      freeType: List<String>.from(map['freeDays'] ?? []),
      mealType: map['mealsPerDay'],
      dietType: map['dietPref'] ?? '',
      isHalal: map['isHalal'] ?? false,
      regionType: List<String>.from(map['regions'] ?? []),
      selectedAllergens: List<String>.from(map['allergens'] ?? []),
      selectedIntolerances: List<String>.from(map['intolerances'] ?? []),
      selectedDislikes: List<String>.from(map['dislikes'] ?? []),
      wantNotifications: map['notifications'] ?? false,
      wantMetricUnit: map['unit'] ?? true,
      language: map['language'] ?? 'English',
      themeMode: map['theme'] ?? 'system',
      is24Hour: map['hourFormat'] ?? true,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      profileTag: map['profileTag'] ?? 'Starter', xp: map['xp'] ?? 0, streak: map['streak'] ?? 0, coins: map['coins'] ?? 0, xpTag: map['levelTag'] ?? 'Starter',
    );
  }
}

class DailyExeLog{
  final BoxState state;
  final double progress;
  final int doneExercises;
  final double totalBurn;
  final int totalTime;
  final DateTime day;
  DailyExeLog({required this.progress, required this.doneExercises, required this.totalBurn, required this.totalTime, required this.day, required this.state});
}

class DailyMealLog{
  final DietState state;
  final double totalCalories;
  final int takenMeals;
  final double totalCarbs;
  final double totalProtein;
  final double totalFats;
  final DateTime day;
  DailyMealLog({required this.state, required this.totalCalories, required this.takenMeals, required this.totalCarbs, required this.totalProtein, required this.totalFats, required this.day});
}

class ExerciseSchedule{
  final BoxState state;
  final List<String> schedule;
  final DateTime day;
  ExerciseSchedule({required this.state, required this.schedule, required this.day});
}

class ShopLog{
  final List<Item> recentSearch;
  final List<Item> cart;
  final List<Item> orders;
  final ShopItemState state;
  final DateTime day;
  ShopLog({required this.recentSearch, required this.cart, required this.orders, required this.state, required this.day});
}

class OngoingLogs{
  final double burn;
  final double intake;
  final double carb;
  final double protein;
  final double fat;
  final double progress;
  final int waterTaken;
  OngoingLogs({required this.burn, required this.intake, required this.carb, required this.protein, required this.fat, required this.progress, required this.waterTaken});
}

class UserLog{
  final DailyExeLog exeLogs;
  final DailyMealLog mealLogs;
  final ExerciseSchedule schedule;
  final ShopLog shopping;
  final OngoingLogs dailyData;
  UserLog({required this.exeLogs, required this.mealLogs, required this.schedule, required this.shopping, required this.dailyData});
}

class RecommendationData {
  final int? gender;
  final String? category;
  final double? bmr;
  final String? ageGroup;
  final int? work;
  final int? active;
  final int? sleep;
  final int? fitness;
  final double? tdee;

  RecommendationData({
    this.gender,
    this.category,
    this.bmr,
    this.ageGroup,
    this.work,
    this.active,
    this.sleep,
    this.fitness,
    this.tdee,
  });
}

class DataProvider extends ChangeNotifier {
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

  void updatePageOne(SignupPageOneData data) {
    pageOne = data;
    notifyListeners();
  }

  void updatePageTwo(SignupPageTwoData data) {
    pageTwo = data;
    notifyListeners();
  }

  void updatePageThree(SignupPageThreeData data) {
    pageThree = data;
    notifyListeners();
  }

  void updatePageFour(SignupPageFourData data) {
    pageFour = data;
    notifyListeners();
  }

  void updatePageFive(SignupPageFiveData data) {
    pageFive = data;
    notifyListeners();
  }

  void updatePageSix(SignupPageSixData data) {
    pageSix = data;
    notifyListeners();
  }

  void updatePageSeven(SignupPageSevenData data) {
    pageSeven = data;
    notifyListeners();
  }

  void updatePageEight(SignupPageEightData data) {
    pageEight = data;
    notifyListeners();
  }

  void updatePageNine(SignupPageNineData data) {
    pageNine = data;
    notifyListeners();
  }

  void updatePageTen(SignupPageTenData data) {
    pageTen = data;
    notifyListeners();
  }

  RecommendationData get recommendationData {
    return RecommendationData(
      gender: pageOne.gender!,
      category: pageOne.category!,
      bmr: pageOne.bmr!,
      ageGroup: pageOne.ageGroup!,
      work: pageThree.workIndex!,
      active: pageThree.activeIndex!,
      sleep: pageThree.sleepIndex!,
      fitness: pageFour.fitIndex!,
      tdee: pageFour.tdee!,
    );
  }

  RuleResult get finalRecommendation {
    final d = recommendationData;
    for (final rule in rules) {
      if (rule.condition(d)) {
        return rule.result;
      }
    }
    return RuleResult(code: 5, profile: 'Starter');
  }

  void reset() {
    pageOne = SignupPageOneData();
    pageTwo = SignupPageTwoData();
    pageThree = SignupPageThreeData();
    pageFour = SignupPageFourData();
    pageFive = SignupPageFiveData();
    pageSix = SignupPageSixData();
    pageSeven = SignupPageSevenData();
    pageEight = SignupPageEightData();
    pageNine = SignupPageNineData();
    pageTen = SignupPageTenData();
    notifyListeners();
  }

  static final Map<String, List<Image>> dietMap = {
    'Omnivore': [Emoji.carb1, Emoji.pro1, Emoji.fat1],
    'Vegetarian': [Emoji.carb2, Emoji.pro2, Emoji.fat2],
    'Vegan': [Emoji.carb3, Emoji.pro3, Emoji.fat3],
    'Pescatarian': [Emoji.carb4, Emoji.pro4, Emoji.fat4],
    'Paleo': [Emoji.carb5, Emoji.pro5, Emoji.fat5],
    'Keto': [Emoji.carb6, Emoji.pro6, Emoji.fat6],
  };

  List<Image> get _macroImages => dietMap[currentUser!.dietType]!;

  Image get carbImage => _macroImages[0];

  Image get proteinImage => _macroImages[1];

  Image get fatImage => _macroImages[2];

  //user data starts from here
  UserData? currentUser;
  bool isFetchingUser = false;
  String? profileImageBase64;
  bool _sessionRestored = false;

  Image get xpIcon {
    final xp = currentUser!.xp;
    return switch(xp){
      < 500 => Emoji.starter,
      < 1000 => Emoji.starter,
      < 1500 => Emoji.starter,
      < 2000 => Emoji.starter,
      < 3000 => Emoji.starter,
      < 4000 => Emoji.starter,
      < 5000 => Emoji.starter,
      _ => Emoji.legend,
    };
  }

  bool get sessionRestored => _sessionRestored;

  ThemeMode get savedThemeMode => switch (currentUser?.themeMode ?? 'system') {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  DataProvider() {
    restoreSession();
  }

  Future<void> restoreSession() async {
    _sessionRestored = false;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await fetchUser(firebaseUser.uid);
    }
    finishSession();
  }

  void beginSession() {
    _sessionRestored = false;
    notifyListeners();
  }

  void finishSession() {
    _sessionRestored = true;
    notifyListeners();
  }

  Future<void> fetchUser(String uid) async {
    isFetchingUser = true;
    notifyListeners();
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        currentUser = UserData.fromMap(doc.data()!);
        profileImageBase64 = doc.data()?['profileImage'];
      }
    } catch (e) {
      debugPrint('fetchUser error: $e');
    }
    isFetchingUser = false;
    notifyListeners();
  }

  Future<String?> uploadProfileImage(Uint8List imageBytes) async {
    if (currentUser == null) return null;
    try {
      final base64Image = base64Encode(imageBytes);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'profileImage': base64Image});
      profileImageBase64 = base64Image;
      notifyListeners();
    } catch (e) {
      debugPrint('uploadProfileImage error: $e');
      rethrow;
    }
    return null;
  }

  Future<void> removeProfileImage() async{
    if(currentUser == null) return;
    try{
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({'profileImage': null});
      profileImageBase64 = null;
      notifyListeners();
    }catch(e){
      debugPrint('removeProfileImage error: $e');
      rethrow;
    }
  }

  Future<void> updateSettings({
    bool? wantNotifications,
    bool? wantMetricUnit,
    String? language,
    String? themeMode,
    bool? is24Hour,
  }) async {
    if (currentUser == null) return;
    final fields = <String, dynamic>{};
    if (wantNotifications != null) fields['notifications'] = wantNotifications;
    if (wantMetricUnit != null) fields['unit'] = wantMetricUnit;
    if (language != null) fields['language'] = language;
    if (themeMode != null) fields['theme'] = themeMode;
    if (is24Hour != null) fields['hourFormat'] = is24Hour;

    if (fields.isEmpty) return;

    final updateMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updateMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updateSettings error: $e');
      rethrow;
    }
  }

  Future<void> updateProfileField(String field, dynamic value) async {
    if (currentUser == null) return;
    final updatedMap = currentUser!.toMap()..addAll({field: value});
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({field: value});
    } catch (e) {
      debugPrint('updatedProfileField error: $e');
      rethrow;
    }
  }

  Future<void> addXP(int gain) async{
    if(currentUser == null) return;
    final newXP = currentUser!.xp + gain;
    final level = UserData.getLevelTag(newXP);

    final fields = {
      'xp' : newXP,
      'levelTag' : level['tag'],
    };
    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updateXP error: $e');
      rethrow;
    }
  }

  String computeProfileTag({
    required String gender,
    required String bmiCategory,
    required double bmr,
    required String ageGroup,
    required String workType,
    required String activityLevel,
    required String sleepPattern,
    required String fitType,
    required double tdee,
  }) {
    const workMap = {
      'Sedentary': 0,
      'Moderately Active': 1,
      'Physically Active': 2,
    };
    const activeMap = {'Low': 0, 'Moderate': 1, 'High': 2};
    const sleepMap = {
      'Less than 5 hours': 0,
      '5 to 7 hours': 1,
      '7 to 9 hours': 2,
      'More than 9 hours': 3,
    };
    const fitMap = {'Beginner': 0, 'Intermediate': 1, 'Advanced': 2};

    final d = RecommendationData(
      gender: gender == 'Male' ? 1 : 2,
      category: bmiCategory,
      bmr: bmr,
      ageGroup: ageGroup,
      work: workMap[workType] ?? 0,
      active: activeMap[activityLevel] ?? 0,
      sleep: sleepMap[sleepPattern] ?? 2,
      fitness: fitMap[fitType] ?? 0,
      tdee: tdee,
    );

    for (final rule in rules) {
      if (rule.condition(d)) return rule.result.profile;
    }
    return 'Starter';
  }

  Future<void> updateBodyStats({
    required double heightCm,
    required double weightKg,
  }) async {
    if (currentUser == null) return;
    final bmi = double.parse(
      (weightKg / ((heightCm / 100) * (heightCm / 100))).toStringAsFixed(1),
    );
    String bmiCategory;
    if (bmi < 18.5) {
      bmiCategory = 'Underweight';
    } else if (bmi < 25) {
      bmiCategory = 'Normal';
    } else if (bmi < 30) {
      bmiCategory = 'Overweight';
    } else {
      bmiCategory = 'Obese';
    }
    final age = currentUser!.age;
    final genderInt = currentUser!.gender == 'Male' ? 1 : 2;
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    final bmr = double.parse(
      (genderInt == 1 ? base + 5 : base - 161).toStringAsFixed(1),
    );
    const workFactors = {
      'Sedentary': 1.2,
      'Moderately Active': 1.35,
      'Physically Active': 1.55,
    };
    const activeFactors = {'Low': 1.0, 'Moderate': 1.1, 'High': 1.2};
    const fitFactors = {
      'Beginner': 0.95,
      'Intermediate': 1.0,
      'Advanced': 1.05,
    };

    final workF = workFactors[currentUser!.workType] ?? 1.2;
    final activeF = activeFactors[currentUser!.activityLevel] ?? 1.0;
    final fitF = fitFactors[currentUser!.fitType] ?? 0.95;
    final tdee = double.parse(
      (bmr * workF * activeF * fitF).toStringAsFixed(1),
    );

    final profileTag = computeProfileTag(
      gender: currentUser!.gender,
      bmiCategory: bmiCategory,
      bmr: bmr,
      ageGroup: currentUser!.ageGroup,
      workType: currentUser!.workType,
      activityLevel: currentUser!.activityLevel,
      sleepPattern: currentUser!.sleepPattern,
      fitType: currentUser!.fitType,
      tdee: tdee,
    );

    final fields = <String, dynamic>{
      'height': double.parse(heightCm.toStringAsFixed(1)),
      'weight': double.parse(weightKg.toStringAsFixed(1)),
      'bmi': bmi,
      'bmiCategory': bmiCategory,
      'bmr': bmr,
      'tdee': tdee,
      'profileTag': profileTag,
    };

    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updateBodyStats error: $e');
      rethrow;
    }
  }

  Future<void> updateFitnessProfile({
    required String fitType,
    required String workType,
    required String activityLevel,
    required List<String> styleType,
    required String equipType,
    required String fundType,
    required String goalType,
    required String planType,
  }) async {
    if (currentUser == null) return;

    const workFactors = {
      'Sedentary': 1.2,
      'Moderately Active': 1.35,
      'Physically Active': 1.55,
    };
    const activeFactors = {'Low': 1.0, 'Moderate': 1.1, 'High': 1.2};
    const fitFactors = {
      'Beginner': 0.95,
      'Intermediate': 1.0,
      'Advanced': 1.05,
    };
    final workF = workFactors[workType] ?? 1.2;
    final activeF = activeFactors[activityLevel] ?? 1.0;
    final fitF = fitFactors[fitType] ?? 0.95;
    final tdee = double.parse(
      (currentUser!.bmr * workF * activeF * fitF).toStringAsFixed(1),
    );
    final profileTag = computeProfileTag(
      gender: currentUser!.gender,
      bmiCategory: currentUser!.bmiCategory,
      bmr: currentUser!.bmr,
      ageGroup: currentUser!.ageGroup,
      workType: workType,
      activityLevel: activityLevel,
      sleepPattern: currentUser!.sleepPattern,
      fitType: fitType,
      tdee: tdee,
    );

    final fields = <String, dynamic>{
      'fitness': fitType,
      'work': workType,
      'activity': activityLevel,
      'exercise': styleType,
      'equipment': equipType,
      'fundamental': fundType,
      'goal': goalType,
      'plan': planType,
      'tdee': tdee,
      'profileTag': profileTag,
    };

    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updateFitnessProfile error: $e');
      rethrow;
    }
  }

  Future<void> updateDietPreference({
    String? newDiet,
    String? newMeals,
    List<String>? newRegions,
  }) async {
    if (currentUser == null) return;

    final fields = <String, dynamic>{};
    if (newDiet != null) {
      fields['dietPref'] = newDiet;
      fields['intolerances'] = [];
      fields['dislikes'] = [];
    }
    if (newMeals != null) fields['mealsPerDay'] = newMeals;
    if (newRegions != null) fields['regions'] = newRegions;
    if (fields.isEmpty) return;

    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updateDietPreference error: $e');
      rethrow;
    }
  }

  Future<void> updateSchedule({
    String? sleepPattern,
    List<String>? timeType,
    String? durationType,
    String? dayType,
    List<String>? freeType,
    String? placeType,
  }) async {
    if (currentUser == null) return;
    final fields = <String, dynamic>{};
    if (sleepPattern != null) fields['sleepPattern'] = sleepPattern;
    if (timeType != null) fields['time'] = timeType;
    if (durationType != null) fields['duration'] = durationType;
    if (dayType != null) fields['workoutDays'] = dayType;
    if (freeType != null) fields['freeDays'] = freeType;
    if (placeType != null) fields['place'] = placeType;

    if (fields.isEmpty) return;

    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updateSchedule error: $e');
      rethrow;
    }
  }

  Future<void> updateUsernameAndEmail({
    required String username,
    required String email,
  }) async {
    if (currentUser == null) return;

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser == null) return;
    await firebaseUser.verifyBeforeUpdateEmail(email);
    final fields = <String, dynamic>{'username': username, 'email': email};

    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updateUsernameAndEmail error: $e');
      rethrow;
    }
  }

  Future<void> updateGoogleLink(String? id, String? email) async {
    if (currentUser == null) return;

    final fields = <String, dynamic>{'googleId': id, 'googleEmail': email};

    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updatedProfileField error: $e');
      rethrow;
    }
  }

  Future<void> updateAppleLink(String? id, String? email) async {
    if (currentUser == null) return;

    final fields = <String, dynamic>{'appleId': id, 'appleEmail': email};
    final updatedMap = currentUser!.toMap()..addAll(fields);
    currentUser = UserData.fromMap(updatedMap);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(fields);
    } catch (e) {
      debugPrint('updatedProfileField error: $e');
      rethrow;
    }
  }

  void clearUser() {
    currentUser = null;
    notifyListeners();
  }

  Future<void> deleteUserAccount() async {
    if (currentUser == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .delete();
    } catch (e) {
      debugPrint('deleteUserAccount error: $e');
      rethrow;
    }
  }
}

class Rule {
  final bool Function(RecommendationData data) condition;
  final RuleResult result;

  Rule({required this.condition, required this.result});
}

class RuleResult {
  final int code;
  final String profile;

  RuleResult({required this.code, required this.profile});
}

final List<Rule> rules = [
  Rule(
    condition: (d) =>
        d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior',
    result: RuleResult(code: 0, profile: 'Energy Depleted'),
  ),
  Rule(
    condition: (d) =>
        d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Teen',
    result: RuleResult(code: 0, profile: 'Undernourished'),
  ),
  Rule(
    condition: (d) =>
        d.category == 'Underweight' &&
        d.bmr! < 1400 &&
        (d.ageGroup == 'Young Adult' || d.ageGroup == 'Adult'),
    result: RuleResult(code: 0, profile: 'Underfueled'),
  ),
  Rule(
    condition: (d) =>
        d.category == 'Obese' && d.work == 0 && d.ageGroup == 'Adult',
    result: RuleResult(code: 3, profile: 'Obese Adult'),
  ),
  Rule(
    condition: (d) =>
        d.category == 'Obese' && d.work == 0 && d.ageGroup == 'Young Adult',
    result: RuleResult(code: 3, profile: 'Overweight Starter'),
  ),
  Rule(
    condition: (d) => d.sleep == 0 && d.tdee! > 2600 && d.ageGroup == 'Adult',
    result: RuleResult(code: 0, profile: 'Sleep Deprived'),
  ),
  Rule(
    condition: (d) =>
        d.sleep == 0 && d.tdee! > 2600 && d.ageGroup == 'Young Adult',
    result: RuleResult(code: 0, profile: 'High Output'),
  ),
  Rule(
    condition: (d) =>
        (d.category == 'Overweight' || d.category == 'Obese') &&
        d.active == 0 &&
        d.ageGroup == 'Senior',
    result: RuleResult(code: 2, profile: 'Stiff Retiree'),
  ),
  Rule(
    condition: (d) => d.fitness == 0 && d.ageGroup == 'Teen',
    result: RuleResult(code: 5, profile: 'Inactive Student'),
  ),
  Rule(
    condition: (d) =>
        (d.fitness == 1 || d.fitness == 2) && d.ageGroup == 'Teen',
    result: RuleResult(code: 6, profile: 'Developing Athlete'),
  ),
  Rule(
    condition: (d) =>
        d.gender == 1 &&
        d.active == 2 &&
        d.ageGroup == 'Young Adult' &&
        d.fitness == 2,
    result: RuleResult(code: 6, profile: 'Peak Performer'),
  ),
  Rule(
    condition: (d) =>
        d.gender == 1 && d.active == 2 && d.ageGroup == 'Young Adult',
    result: RuleResult(code: 1, profile: 'Gym Goer'),
  ),
  Rule(
    condition: (d) =>
        d.gender == 1 && d.work == 1 && d.ageGroup == 'Young Adult',
    result: RuleResult(code: 5, profile: 'Desk Bound'),
  ),
  Rule(
    condition: (d) => d.gender == 2 && d.ageGroup == 'Young Adult',
    result: RuleResult(code: 4, profile: 'Wellness Seeker'),
  ),
  Rule(
    condition: (d) =>
        d.category == 'Normal' &&
        d.gender == 1 &&
        d.active == 2 &&
        d.ageGroup == 'Adult',
    result: RuleResult(code: 1, profile: 'Adult Rebuilder'),
  ),
  Rule(
    condition: (d) => d.gender == 1 && d.ageGroup == 'Adult',
    result: RuleResult(code: 3, profile: 'Heavy Carrier'),
  ),
  Rule(
    condition: (d) =>
        d.category == 'Overweight' && d.gender == 2 && d.ageGroup == 'Adult',
    result: RuleResult(code: 4, profile: 'Metabolic Risk'),
  ),
  Rule(
    condition: (d) => d.gender == 2 && d.ageGroup == 'Adult',
    result: RuleResult(code: 2, profile: 'Stiff Mover'),
  ),
  Rule(
    condition: (d) => d.category == 'Obese' && d.ageGroup == 'Senior',
    result: RuleResult(code: 4, profile: 'Metabolic Struggle'),
  ),
  Rule(
    condition: (d) =>
        (d.fitness == 1 || d.fitness == 2) &&
        d.active == 2 &&
        d.ageGroup == 'Senior',
    result: RuleResult(code: 1, profile: 'Active Elder'),
  ),
  Rule(
    condition: (d) =>
        d.category == 'Normal' && d.active == 1 && d.ageGroup == 'Senior',
    result: RuleResult(code: 3, profile: 'Senior Mover'),
  ),
  Rule(
    condition: (d) => d.ageGroup == 'Senior',
    result: RuleResult(code: 5, profile: 'Frail Elder'),
  ),
  Rule(
    condition: (d) => d.active == 0 && d.bmr! < 1400,
    result: RuleResult(code: 0, profile: 'Depleted Mover'),
  ),
  Rule(
    condition: (d) => d.work == 0 && d.active == 0 && d.fitness == 0,
    result: RuleResult(code: 5, profile: 'Sedentary Starter'),
  ),
  Rule(
    condition: (d) => d.sleep == 1 && d.work == 2,
    result: RuleResult(code: 2, profile: 'Overworked Mover'),
  ),
  Rule(
    condition: (d) => d.active == 2 && d.tdee! > 2600 && d.bmr! > 1800,
    result: RuleResult(code: 1, profile: 'High Performer'),
  ),
  Rule(
    condition: (d) => d.sleep == 3 && d.active == 0,
    result: RuleResult(code: 4, profile: 'Metabolic Drifter'),
  ),
  Rule(
    condition: (d) => d.fitness == 0,
    result: RuleResult(code: 5, profile: 'Grounded Beginner'),
  ),
  Rule(
    condition: (d) => d.fitness == 1,
    result: RuleResult(code: 1, profile: 'Steady Builder'),
  ),
  Rule(
    condition: (d) => d.fitness == 2 && d.active == 2,
    result: RuleResult(code: 6, profile: 'Elite Performer'),
  ),
  Rule(
    condition: (d) => d.fitness == 2 && (d.active == 1 || d.active == 0),
    result: RuleResult(code: 3, profile: 'Controlled Mover'),
  ),
];
