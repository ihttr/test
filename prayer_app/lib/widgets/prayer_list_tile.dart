import 'package:flutter/material.dart';
import '../models/prayer_model.dart';
import '../theme/app_theme.dart';

class PrayerListTile extends StatelessWidget {
  final PrayerTime prayer;
  final bool isNext;
  final bool isLast;
  final bool isDark;
  final ValueChanged<bool> onNotificationToggle;

  const PrayerListTile({
    super.key,
    required this.prayer,
    required this.isNext,
    required this.isLast,
    required this.isDark,
    required this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = prayer.time.isBefore(now);

    Color textColor = isDark ? AppTheme.darkText : AppTheme.lightText;
    Color secondaryColor = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    if (isPast && !isNext) {
      textColor = secondaryColor;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isNext
                      ? AppTheme.primaryGold.withOpacity(0.2)
                      : (isDark
                          ? AppTheme.darkCardLight
                          : AppTheme.lightCardAlt),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  prayer.icon,
                  color: isNext ? AppTheme.primaryGold : secondaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),

              // Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          prayer.nameArabic,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: isNext ? FontWeight.w700 : FontWeight.w600,
                            color: isNext ? AppTheme.primaryGold : textColor,
                          ),
                        ),
                        if (isNext) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.primaryGold.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'التالية',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                color: AppTheme.primaryGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (isPast && !isNext)
                      Text(
                        'انتهى الوقت',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: secondaryColor.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
              ),

              // Time
              Text(
                prayer.timeFormatted,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isNext ? AppTheme.primaryGold : textColor,
                ),
              ),
              const SizedBox(width: 12),

              // Notification toggle (not for sunrise)
              if (prayer.name != PrayerName.sunrise)
                GestureDetector(
                  onTap: () => onNotificationToggle(!prayer.notificationEnabled),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: prayer.notificationEnabled
                          ? AppTheme.primaryGold.withOpacity(0.15)
                          : (isDark
                              ? AppTheme.darkCardLight
                              : AppTheme.lightCardAlt),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      prayer.notificationEnabled
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_rounded,
                      size: 18,
                      color: prayer.notificationEnabled
                          ? AppTheme.primaryGold
                          : secondaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 80,
            endIndent: 20,
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
      ],
    );
  }
}
