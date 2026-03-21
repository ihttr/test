import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../models/prayer_model.dart';
import '../services/prayer_service.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_list_tile.dart';
import '../widgets/hijri_date_widget.dart';
import 'qibla_screen.dart';
import 'settings_screen.dart';
import 'hijri_calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomeScreen({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<PrayerTime> _prayers = [];
  PrayerTime? _nextPrayer;
  PrayerSettings _settings = PrayerSettings();
  bool _loading = true;
  String _cityName = 'جارٍ تحديد الموقع...';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    _settings = await PrayerService.loadSettings();

    double lat = _settings.latitude ?? 21.3891;
    double lng = _settings.longitude ?? 39.8579;
    String city = _settings.cityName ?? 'مكة المكرمة';

    // Try to get current location
    final position = await PrayerService.getCurrentLocation();
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
      city = PrayerService.cityName ?? 'موقعك الحالي';
      _settings.latitude = lat;
      _settings.longitude = lng;
      _settings.cityName = city;
      await PrayerService.saveSettings(_settings);
    }

    final prayers = PrayerService.calculatePrayerTimes(
      latitude: lat,
      longitude: lng,
    );

    await NotificationService.initialize();
    await NotificationService.schedulePrayerNotifications(
      prayers,
      _settings.minutesBefore,
      _settings.notificationsEnabled,
    );

    setState(() {
      _prayers = prayers;
      _nextPrayer = PrayerService.getNextPrayer(prayers);
      _cityName = city;
      _loading = false;
    });

    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.lightBg;

    return Scaffold(
      backgroundColor: bg,
      body: _loading
          ? _buildLoading(isDark)
          : FadeTransition(
              opacity: _fadeAnimation,
              child: _buildContent(isDark),
            ),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryGold,
                strokeWidth: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'جارٍ تحميل المواقيت...',
            style: TextStyle(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              fontSize: 16,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(isDark),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                HijriDateWidget(isDark: isDark),
                const SizedBox(height: 20),
                if (_nextPrayer != null)
                  NextPrayerCard(prayer: _nextPrayer!, isDark: isDark),
                const SizedBox(height: 24),
                _buildPrayerList(isDark),
                const SizedBox(height: 24),
                _buildQuickActions(isDark),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(bool isDark) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(
            isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
            color: AppTheme.primaryGold,
          ),
          onPressed: widget.toggleTheme,
          tooltip: 'تغيير الثيم',
        ),
      ),
      title: Column(
        children: [
          Text(
            'مواقيت الصلاة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: isDark ? AppTheme.darkText : AppTheme.lightText,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 12,
                color: AppTheme.primaryGold,
              ),
              const SizedBox(width: 4),
              Text(
                _cityName,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_rounded,
            color: isDark ? AppTheme.darkText : AppTheme.lightText,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  settings: _settings,
                  isDark: isDark,
                  onSave: (s) async {
                    _settings = s;
                    await PrayerService.saveSettings(s);
                    _loadData();
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPrayerList(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 4),
          child: Text(
            'أوقات الصلاة اليوم',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.darkText : AppTheme.lightText,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: Column(
            children: _prayers.asMap().entries.map((entry) {
              final idx = entry.key;
              final prayer = entry.value;
              final isLast = idx == _prayers.length - 1;
              final isNext = prayer == _nextPrayer;

              return PrayerListTile(
                prayer: prayer,
                isNext: isNext,
                isLast: isLast,
                isDark: isDark,
                onNotificationToggle: (enabled) {
                  setState(() => prayer.notificationEnabled = enabled);
                  NotificationService.schedulePrayerNotifications(
                    _prayers,
                    _settings.minutesBefore,
                    _settings.notificationsEnabled,
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.explore_rounded,
            label: 'القبلة',
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QiblaScreen(isDark: isDark),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.calendar_month_rounded,
            label: 'التقويم الهجري',
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HijriCalendarScreen(isDark: isDark),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppTheme.primaryGold, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkText : AppTheme.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
