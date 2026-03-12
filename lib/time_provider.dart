import 'dart:async';
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
