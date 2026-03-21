import 'package:flutter/material.dart';
import '../models/prayer_model.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final PrayerSettings settings;
  final bool isDark;
  final ValueChanged<PrayerSettings> onSave;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.isDark,
    required this.onSave,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late PrayerSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = PrayerSettings(
      notificationsEnabled: widget.settings.notificationsEnabled,
      minutesBefore: widget.settings.minutesBefore,
      adhanSoundEnabled: widget.settings.adhanSoundEnabled,
      selectedAdhan: widget.settings.selectedAdhan,
      darkMode: widget.settings.darkMode,
      calculationMethod: widget.settings.calculationMethod,
      latitude: widget.settings.latitude,
      longitude: widget.settings.longitude,
      cityName: widget.settings.cityName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        foregroundColor: isDark ? AppTheme.darkText : AppTheme.lightText,
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(_settings);
              Navigator.pop(context);
            },
            child: const Text(
              'حفظ',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppTheme.primaryGold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(title: 'الإشعارات', isDark: isDark),
          _SettingsCard(
            isDark: isDark,
            children: [
              _ToggleTile(
                title: 'تفعيل الإشعارات',
                subtitle: 'استلام إشعار قبل أذان كل صلاة',
                value: _settings.notificationsEnabled,
                isDark: isDark,
                onChanged: (v) => setState(() => _settings.notificationsEnabled = v),
              ),
              _DividerLine(isDark: isDark),
              _SliderTile(
                title: 'وقت الإشعار قبل الأذان',
                value: _settings.minutesBefore.toDouble(),
                min: 0,
                max: 30,
                divisions: 6,
                label: '${_settings.minutesBefore} دقيقة',
                isDark: isDark,
                onChanged: (v) => setState(() => _settings.minutesBefore = v.round()),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _SectionTitle(title: 'الأذان', isDark: isDark),
          _SettingsCard(
            isDark: isDark,
            children: [
              _ToggleTile(
                title: 'صوت الأذان',
                subtitle: 'تشغيل الأذان عند وقت الصلاة',
                value: _settings.adhanSoundEnabled,
                isDark: isDark,
                onChanged: (v) => setState(() => _settings.adhanSoundEnabled = v),
              ),
              _DividerLine(isDark: isDark),
              _SelectTile(
                title: 'المؤذن',
                isDark: isDark,
                value: _settings.selectedAdhan,
                options: const {
                  'makkah': 'الحرم المكي',
                  'madinah': 'المدينة المنورة',
                  'egypt': 'مصر',
                },
                onChanged: (v) => setState(() => _settings.selectedAdhan = v),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _SectionTitle(title: 'الحساب والموقع', isDark: isDark),
          _SettingsCard(
            isDark: isDark,
            children: [
              _InfoTile(
                title: 'طريقة الحساب',
                value: 'أم القرى (السعودية)',
                isDark: isDark,
                icon: Icons.calculate_rounded,
              ),
              _DividerLine(isDark: isDark),
              _InfoTile(
                title: 'الموقع الحالي',
                value: _settings.cityName ?? 'مكة المكرمة',
                isDark: isDark,
                icon: Icons.location_on_rounded,
              ),
            ],
          ),

          const SizedBox(height: 20),
          _SectionTitle(title: 'حول التطبيق', isDark: isDark),
          _SettingsCard(
            isDark: isDark,
            children: [
              _InfoTile(
                title: 'الإصدار',
                value: '1.0.0',
                isDark: isDark,
                icon: Icons.info_outline_rounded,
              ),
              _DividerLine(isDark: isDark),
              _InfoTile(
                title: 'طريقة الحساب',
                value: 'Adhan Library',
                isDark: isDark,
                icon: Icons.mosque_rounded,
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryGold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _SettingsCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkText : AppTheme.lightText,
                    )),
                Text(subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    )),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final bool isDark;
  final ValueChanged<double> onChanged;

  const _SliderTile({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                  )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppTheme.primaryGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppTheme.primaryGold,
            inactiveColor: AppTheme.primaryGold.withOpacity(0.2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final String title;
  final String value;
  final Map<String, String> options;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _SelectTile({
    required this.title,
    required this.value,
    required this.options,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkText : AppTheme.lightText,
              )),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.entries.map((e) {
              final selected = e.key == value;
              return GestureDetector(
                onTap: () => onChanged(e.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.primaryGold
                        : AppTheme.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppTheme.primaryGold
                          : AppTheme.primaryGold.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    e.value,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppTheme.primaryGold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final bool isDark;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.isDark,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGold, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkText : AppTheme.lightText,
                )),
          ),
          Text(value,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              )),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  final bool isDark;
  const _DividerLine({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06),
    );
  }
}
