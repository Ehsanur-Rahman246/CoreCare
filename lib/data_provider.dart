import 'dart:async';
import 'package:core_care/pages/sign_up_pages.dart';
import 'package:flutter/material.dart';

class TimeProvider extends ChangeNotifier {
  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _is24Hour = true;

  DateTime get now => _now;
  bool get is24Hour => _is24Hour;

  TimeProvider(){
    _timer = Timer.periodic(const Duration(seconds: 1), (_){
      _now = DateTime.now();
      notifyListeners();
    });
  }

  void toggleFormat(){
    _is24Hour = !_is24Hour;
    notifyListeners();
  }

  String get formatTime{
    int hour = _now.hour;
    final minute = _now.minute.toString().padLeft(2, '0');
    if(_is24Hour){
      return '${hour.toString().padLeft(2,'0')}: $minute';
    }
    else{
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if(hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:$minute $period';
    }
  }

  String get formatDate{
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[_now.month - 1]} ${_now.day}, ${_now.year}';
  }
  
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

class RecommendationData{
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

  void updatePageOne(SignupPageOneData data){
    pageOne = data;
    notifyListeners();
  }
  void updatePageTwo(SignupPageTwoData data){
    pageTwo = data;
    notifyListeners();
  }
  void updatePageThree(SignupPageThreeData data){
    pageThree = data;
    notifyListeners();
  }
  void updatePageFour(SignupPageFourData data){
    pageFour = data;
    notifyListeners();
  }
  void updatePageFive(SignupPageFiveData data){
    pageFive = data;
    notifyListeners();
  }
  void updatePageSix(SignupPageSixData data){
    pageSix = data;
    notifyListeners();
  }
  void updatePageSeven(SignupPageSevenData data){
    pageSeven = data;
    notifyListeners();
  }
  void updatePageEight(SignupPageEightData data){
    pageEight = data;
    notifyListeners();
  }
  void updatePageNine(SignupPageNineData data){
    pageNine = data;
    notifyListeners();
  }

  RecommendationData get recommendationData{
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
  RuleResult get finalRecommendation{
    final d = recommendationData;
    for(final rule in rules){
      if(rule.condition(d)){
        return rule.result;
      }
    }
    return RuleResult(code: 5, profile: 'Starter');
  }

  void delete(){
    pageOne = SignupPageOneData();
    pageTwo = SignupPageTwoData();
    pageThree = SignupPageThreeData();
    pageFour = SignupPageFourData();
    pageFive = SignupPageFiveData();
    pageSix = SignupPageSixData();
    pageSeven = SignupPageSevenData();
    pageEight = SignupPageEightData();
    pageNine = SignupPageNineData();
    notifyListeners();
  }
}



class Rule{
  final bool Function(RecommendationData data) condition;
  final RuleResult result;

  Rule({
    required this.condition,
    required this.result,
  });
}

class RuleResult{
  final int code;
  final String profile;
  RuleResult({
    required this.code,
    required this.profile,
  });
}

final List<Rule> rules = [
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 0, profile: 'Energy Depleted'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Teen', result: RuleResult(code: 0, profile: 'Undernourished'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && (d.ageGroup == 'Young Adult' || d.ageGroup == 'Adult'), result: RuleResult(code: 0, profile: 'Underfueled'),),
  Rule(condition: (d) => d.category == 'Obese' && d.work == 0 && d.ageGroup == 'Adult', result: RuleResult(code: 3, profile: 'Obese Adult'),),
  Rule(condition: (d) => d.category == 'Obese' && d.work == 0 && d.ageGroup == 'Young Adult', result: RuleResult(code: 3, profile: 'Overweight Starter'),),
  Rule(condition: (d) => d.sleep == 0 && d.tdee! > 2600 && d.ageGroup == 'Adult', result: RuleResult(code: 0, profile: 'Sleep Deprived'),),
  Rule(condition: (d) => d.sleep == 0 && d.tdee! > 2600 && d.ageGroup == 'Young Adult', result: RuleResult(code: 0, profile: 'High Output'),),
  Rule(condition: (d) => (d.category == 'Overweight' || d.category == 'Obese') && d.active == 0 && d.ageGroup == 'Senior', result: RuleResult(code: 2, profile: 'Stiff Retiree'),),
  Rule(condition: (d) => d.fitness == 0 && d.ageGroup == 'Teen', result: RuleResult(code: 5, profile: 'Inactive Student'),),
  Rule(condition: (d) => (d.fitness == 1 || d.fitness == 2) && d.ageGroup == 'Teen', result: RuleResult(code: 6, profile: 'Developing Athlete'),),
  Rule(condition: (d) => d.gender == 1 && d.active == 2 && d.ageGroup == 'Young Adult', result: RuleResult(code: 1, profile: 'Gym Goer'),),
  Rule(condition: (d) => d.gender == 1 && d.active == 2 && d.ageGroup == 'Young Adult' && d.fitness == 2, result: RuleResult(code: 6, profile: 'Peak Performer'),),
  Rule(condition: (d) => d.gender == 1 && d.work == 1 && d.ageGroup == 'Young Adult', result: RuleResult(code: 5, profile: 'Desk Bound'),),
  Rule(condition: (d) => d.gender == 2 && d.ageGroup == 'Young Adult', result: RuleResult(code: 4, profile: 'Wellness Seeker'),),
  Rule(condition: (d) => d.category == 'Normal' && d.gender == 1 && d.active == 2 && d.ageGroup == 'Adult', result: RuleResult(code: 1, profile: 'Adult Rebuilder'),),
  Rule(condition: (d) => d.gender == 1 && d.ageGroup == 'Adult', result: RuleResult(code: 3, profile: 'Heavy Carrier'),),
  Rule(condition: (d) => d.category == 'Overweight' && d.gender == 2 && d.ageGroup == 'Adult', result: RuleResult(code: 4, profile: 'Metabolic Risk'),),
  Rule(condition: (d) => d.gender == 2 && d.ageGroup == 'Adult', result: RuleResult(code: 2, profile: 'Stiff Mover'),),
  Rule(condition: (d) => d.category == 'Obese' && d.ageGroup == 'Senior', result: RuleResult(code: 4, profile: 'Metabolic Struggle'),),
  Rule(condition: (d) => (d.fitness == 1 || d.fitness == 2) && d.active == 2 && d.ageGroup == 'Senior', result: RuleResult(code: 1, profile: 'Active Elder'),),
  Rule(condition: (d) => d.category == 'Normal' && d.active == 1 && d.ageGroup == 'Senior', result: RuleResult(code: 3, profile: 'Senior Mover'),),
  Rule(condition: (d) => d.ageGroup == 'Senior', result: RuleResult(code: 5, profile: 'Frail Elder'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 0, profile: 'Depleted Mover'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 5, profile: 'Sedentary Starter'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 2, profile: 'Overworked Mover'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 1, profile: 'High Performer'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 4, profile: 'Metabolic Drifter'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 5, profile: 'Grounded Beginner'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 1, profile: 'Steady Builder'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 6, profile: 'Elite Performer'),),
  Rule(condition: (d) => d.category == 'Underweight' && d.bmr! < 1400 && d.ageGroup == 'Senior', result: RuleResult(code: 3, profile: 'Controlled Mover'),),
];