import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../theme/app_theme.dart';

class HijriCalendarScreen extends StatefulWidget {
  final bool isDark;
  const HijriCalendarScreen({super.key, required this.isDark});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late HijriCalendar _currentMonth;
  int _displayMonth = 0;
  int _displayYear = 0;

  final List<String> _monthNames = [
    'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
    'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
    'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
  ];

  final List<String> _dayNames = ['أح', 'إث', 'ث', 'أر', 'خ', 'ج', 'س'];

  @override
  void initState() {
    super.initState();
    _currentMonth = HijriCalendar.now();
    _displayMonth = _currentMonth.hMonth;
    _displayYear = _currentMonth.hYear;
  }

  void _previousMonth() {
    setState(() {
      _displayMonth--;
      if (_displayMonth < 1) {
        _displayMonth = 12;
        _displayYear--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth++;
      if (_displayMonth > 12) {
        _displayMonth = 1;
        _displayYear++;
      }
    });
  }

  int _daysInHijriMonth(int month, int year) {
    // Hijri months alternate 30 and 29 days
    return month % 2 == 0 ? 29 : 30;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final today = HijriCalendar.now();
    final daysInMonth = _daysInHijriMonth(_displayMonth, _displayYear);

    // Find start weekday for the month
    final firstDay = HijriCalendar()
      ..hYear = _displayYear
      ..hMonth = _displayMonth
      ..hDay = 1;
    final firstGregorian = firstDay.hijriToGregorian(_displayYear, _displayMonth, 1);
    final startWeekday = firstGregorian.weekday % 7; // 0 = Sunday

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: const Text('التقويم الهجري', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        foregroundColor: isDark ? AppTheme.darkText : AppTheme.lightText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Month Navigation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.primaryGold,
                        ),
                        onPressed: _previousMonth,
                      ),
                      Column(
                        children: [
                          Text(
                            _monthNames[_displayMonth - 1],
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppTheme.darkText : AppTheme.lightText,
                            ),
                          ),
                          Text(
                            '$_displayYear هـ',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: AppTheme.primaryGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: AppTheme.primaryGold,
                        ),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Day names
                  Row(
                    children: _dayNames.map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Calendar grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: startWeekday + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < startWeekday) {
                        return const SizedBox();
                      }
                      final day = index - startWeekday + 1;
                      final isToday = day == today.hDay &&
                          _displayMonth == today.hMonth &&
                          _displayYear == today.hYear;

                      // Friday highlight
                      final dayOfWeek = (startWeekday + day - 1) % 7;
                      final isFriday = dayOfWeek == 5;

                      return Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppTheme.primaryGold
                                : isFriday
                                    ? AppTheme.primaryGold.withOpacity(0.12)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                                color: isToday
                                    ? Colors.white
                                    : isFriday
                                        ? AppTheme.primaryGold
                                        : isDark
                                            ? AppTheme.darkText
                                            : AppTheme.lightText,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Islamic occasions
            _buildIslamicOccasions(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildIslamicOccasions(bool isDark) {
    final occasions = [
      {'month': 1, 'day': 10, 'name': 'يوم عاشوراء'},
      {'month': 3, 'day': 12, 'name': 'المولد النبوي الشريف'},
      {'month': 7, 'day': 27, 'name': 'ليلة المعراج'},
      {'month': 8, 'day': 15, 'name': 'ليلة النصف من شعبان'},
      {'month': 9, 'day': 1, 'name': 'بداية رمضان'},
      {'month': 9, 'day': 27, 'name': 'ليلة القدر'},
      {'month': 10, 'day': 1, 'name': 'عيد الفطر'},
      {'month': 12, 'day': 9, 'name': 'يوم عرفة'},
      {'month': 12, 'day': 10, 'name': 'عيد الأضحى'},
    ];

    final thisMonthOccasions = occasions
        .where((o) => o['month'] == _displayMonth)
        .toList();

    if (thisMonthOccasions.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المناسبات الإسلامية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.darkText : AppTheme.lightText,
            ),
          ),
          const SizedBox(height: 12),
          ...thisMonthOccasions.map((o) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${o['day']}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  o['name'] as String,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
