import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/prayer_model.dart';

class PrayerService {
  static PrayerTimes? _prayerTimes;
  static Position? _currentPosition;
  static String? _cityName;

  static final Map<PrayerName, IconData> _prayerIcons = {
    PrayerName.fajr: Icons.nights_stay_rounded,
    PrayerName.sunrise: Icons.wb_twilight_rounded,
    PrayerName.dhuhr: Icons.wb_sunny_rounded,
    PrayerName.asr: Icons.sunny_snowing,
    PrayerName.maghrib: Icons.wb_twilight_rounded,
    PrayerName.isha: Icons.dark_mode_rounded,
  };

  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      );

      // Get city name
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          _cityName = p.locality ?? p.subAdministrativeArea ?? p.administrativeArea ?? 'موقعك الحالي';
        }
      } catch (_) {
        _cityName = 'موقعك الحالي';
      }

      return _currentPosition;
    } catch (e) {
      return null;
    }
  }

  static List<PrayerTime> calculatePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.umm_al_qura().getParameters();
    params.madhab = Madhab.shafi;

    final dateComponents = DateComponents.from(date ?? DateTime.now());
    _prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    return [
      PrayerTime(
        name: PrayerName.fajr,
        nameArabic: 'الفجر',
        time: _prayerTimes!.fajr,
        icon: _prayerIcons[PrayerName.fajr]!,
      ),
      PrayerTime(
        name: PrayerName.sunrise,
        nameArabic: 'الشروق',
        time: _prayerTimes!.sunrise,
        icon: _prayerIcons[PrayerName.sunrise]!,
        notificationEnabled: false,
      ),
      PrayerTime(
        name: PrayerName.dhuhr,
        nameArabic: 'الظهر',
        time: _prayerTimes!.dhuhr,
        icon: _prayerIcons[PrayerName.dhuhr]!,
      ),
      PrayerTime(
        name: PrayerName.asr,
        nameArabic: 'العصر',
        time: _prayerTimes!.asr,
        icon: _prayerIcons[PrayerName.asr]!,
      ),
      PrayerTime(
        name: PrayerName.maghrib,
        nameArabic: 'المغرب',
        time: _prayerTimes!.maghrib,
        icon: _prayerIcons[PrayerName.maghrib]!,
      ),
      PrayerTime(
        name: PrayerName.isha,
        nameArabic: 'العشاء',
        time: _prayerTimes!.isha,
        icon: _prayerIcons[PrayerName.isha]!,
      ),
    ];
  }

  static PrayerTime? getNextPrayer(List<PrayerTime> prayers) {
    final now = DateTime.now();
    for (final prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }
    return null;
  }

  static String? get cityName => _cityName;

  static Future<PrayerSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('prayer_settings');
    if (jsonStr != null) {
      return PrayerSettings.fromJson(jsonDecode(jsonStr));
    }
    return PrayerSettings();
  }

  static Future<void> saveSettings(PrayerSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayer_settings', jsonEncode(settings.toJson()));
  }
}
