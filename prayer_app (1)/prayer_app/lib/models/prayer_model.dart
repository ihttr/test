import 'package:flutter/material.dart';

enum PrayerName { fajr, sunrise, dhuhr, asr, maghrib, isha }

class PrayerTime {
  final PrayerName name;
  final String nameArabic;
  final DateTime time;
  final IconData icon;
  bool notificationEnabled;
  int notificationMinutesBefore;

  PrayerTime({
    required this.name,
    required this.nameArabic,
    required this.time,
    required this.icon,
    this.notificationEnabled = true,
    this.notificationMinutesBefore = 5,
  });

  bool get isNext {
    final now = DateTime.now();
    return time.isAfter(now);
  }

  String get timeFormatted {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$h:$minute $period';
  }

  Duration get timeUntil {
    return time.difference(DateTime.now());
  }
}

class PrayerSettings {
  bool notificationsEnabled;
  int minutesBefore;
  bool adhanSoundEnabled;
  String selectedAdhan;
  bool darkMode;
  String calculationMethod;
  double? latitude;
  double? longitude;
  String? cityName;

  PrayerSettings({
    this.notificationsEnabled = true,
    this.minutesBefore = 5,
    this.adhanSoundEnabled = true,
    this.selectedAdhan = 'makkah',
    this.darkMode = true,
    this.calculationMethod = 'ummAlQura',
    this.latitude,
    this.longitude,
    this.cityName,
  });

  Map<String, dynamic> toJson() => {
    'notificationsEnabled': notificationsEnabled,
    'minutesBefore': minutesBefore,
    'adhanSoundEnabled': adhanSoundEnabled,
    'selectedAdhan': selectedAdhan,
    'darkMode': darkMode,
    'calculationMethod': calculationMethod,
    'latitude': latitude,
    'longitude': longitude,
    'cityName': cityName,
  };

  factory PrayerSettings.fromJson(Map<String, dynamic> json) => PrayerSettings(
    notificationsEnabled: json['notificationsEnabled'] ?? true,
    minutesBefore: json['minutesBefore'] ?? 5,
    adhanSoundEnabled: json['adhanSoundEnabled'] ?? true,
    selectedAdhan: json['selectedAdhan'] ?? 'makkah',
    darkMode: json['darkMode'] ?? true,
    calculationMethod: json['calculationMethod'] ?? 'ummAlQura',
    latitude: json['latitude'],
    longitude: json['longitude'],
    cityName: json['cityName'],
  );
}
